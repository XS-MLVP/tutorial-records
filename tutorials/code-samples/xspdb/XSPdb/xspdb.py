#coding=utf-8

import pdb
from .ui import enter_simple_tui
from collections import OrderedDict
import os
import inspect
import pkgutil

from XSPdb.cmd.util import message, info, error, build_prefix_tree, register_commands, YELLOW, RESET, set_log, set_log_file
from XSPdb.cmd.util import load_module_from_file, load_package_from_dir

class XSPdb(pdb.Pdb):
    def __init__(self, dut, df, xsp, default_file=None,
                 mem_base=0x80000000, flash_base=0x10000000, defautl_mem_size=1024*1024*1024):
        """Create a PDB debugger for XiangShan

        Args:
            dut (DUT): DUT exported by picker
            df (difftest): Difftest exported from DUT Python library
            xsp (xspcomm): xspcomm exported from DUT Python library
            default_file (string): Default bin file to load
            mem_base (int): Memory base address
            flash_base (int): Flash base address
        """
        super().__init__()
        self.dut = dut
        self.df = df
        self.xsp = xsp
        self.mem_base = mem_base
        self.flash_base = flash_base
        self.dut_tree = build_prefix_tree(dut.GetInternalSignalList())
        self.prompt = "(XiangShan) "
        self.in_tui = False
        # Init dut uart echo
        self.dut.InitClock("clock")
        self.c_stderr_echo = xsp.ComUseEcho(dut.difftest_uart_out_valid.CSelf(), dut.difftest_uart_out_ch.CSelf())
        self.dut.StepRis(self.c_stderr_echo.GetCb(), self.c_stderr_echo.CSelf(), "uart_echo")
        # Init difftest
        self.exec_bin_file = default_file
        self.mem_size = defautl_mem_size
        self.mem_inited = False
        if self.exec_bin_file:
            assert os.path.exists(self.exec_bin_file), "file %s not found" % self.exec_bin_file
            info("load: %s" % self.exec_bin_file)
            self.df.InitRam(self.exec_bin_file, self.mem_size)
            self.mem_inited = True
        self.df.InitFlash("")
        self.xspdb_init_bin = "xspdb_flash_init.bin"
        self.flash_bin_file = None
        self.df.difftest_init()
        self.difftest_stat =  df.GetDifftest(0).dut
        self.difftest_flash = df.GetFlash()
        self.register_map = OrderedDict()
        self.load_cmds()
        self.api_init_waveform()

    def load_cmds(self):
        import XSPdb.cmd
        cmd_count = self.api_load_custom_pdb_cmds(XSPdb.cmd)
        info(f"Loaded {cmd_count} functions from XSPdb.cmd")

    # override the default PDB function to avoid None cmd error
    def parseline(self, line):
        cmd, arg, line = super().parseline(line)
        return cmd or "", arg, line

    def api_load_custom_pdb_cmds(self, path_or_module):
        """Load custom command

        Args:
            path_or_module (string/Module): Command file path or directory (or python module)
        """
        if isinstance(path_or_module, str):
            if path_or_module.strip().endswith("/"):
                path_or_module = path_or_module.strip()[:-1]
        mod = path_or_module
        if not inspect.ismodule(path_or_module):
            if os.path.isdir(path_or_module):
                mod = load_package_from_dir(path_or_module)
            elif os.path.isfile(path_or_module):
                mod = load_module_from_file(path_or_module)
                return register_commands(mod, self.__class__, self)
            else:
                error(f"Invalid path or module: {path_or_module}")
                return -1
        # module
        cmd_count = 0
        for _, modname, _ in pkgutil.iter_modules(mod.__path__):
            if not modname.startswith("cmd_"):
                continue
            submod = __import__(f"{mod.__name__}.{modname}", fromlist=[modname])
            cmd_count += register_commands(submod, self.__class__, self)
        return cmd_count

    def do_xuse_custom_cmds(self, arg):
        """Load custom command from file or directory

        Args:
            arg (string): Command file path or directory (or python module)
        """
        if not arg:
            error("Please specify a file or directory")
            message("usage: xuse_custom_cmds <file/directory/module>")
            return
        cmd_count = self.api_load_custom_pdb_cmds(arg)
        info(f"Loaded {cmd_count} commands from {arg}")

    def complete_xuse_custom_cmds(self, text, line, begidx, endidx):
        """Complete the custom command file or directory"""
        return self.api_complite_localfile(text)

    def do_xexportself(self, var):
        """Set a variable to XSPdb self

        Args:
            var (string): Variable name
        """
        self.curframe.f_locals[var] = self

    def do_xlist_xclock_cb(self, arg):
        """List all xclock callbacks

        Args:
            arg (None): No arguments
        """
        message("Ris Cbs:")
        for cb in self.dut.xclock.ListSteRisCbDesc():
            message("\t", cb)
        message("Fal Cbs:")
        for cb in self.dut.xclock.ListSteFalCbDesc():
            message("\t", cb)

    def do_xui(self, arg):
        """Enter the Text UI interface

        Args:
            arg (None): No arguments
        """
        if self.in_tui:
            error("Already in TUI")
            return
        self.in_tui = True
        enter_simple_tui(self)
        self.in_tui = False
        self.on_update_tstep = None
        self.interrupt = False
        info("XUI Exited.")

    def do_xcmds(self, arg):
        """Print all xcmds

        Args:
            arg (None): No arguments
        """
        cmd_count = 0
        max_cmd_len = 0
        cmds = []
        for cmd in dir(self):
            if not cmd.startswith("do_x"):
                continue
            cmd_name = cmd[3:]
            max_cmd_len = max(max_cmd_len, len(cmd_name))
            cmd_desc = f"{YELLOW}Description not found{RESET}"
            try:
                cmd_desc = getattr(self, cmd).__doc__.split("\n")[0]
            except Exception as e:
                pass
            cmds.append((cmd, cmd_name, cmd_desc))
            cmd_count += 1
        cmds.sort(key=lambda x: x[0])
        for c in cmds:
            message(("%-"+str(max_cmd_len+2)+"s: %s (from %s)") % (c[1], c[2], self.register_map.get(c[0], self.__class__.__name__)))
        info(f"Total {cmd_count} xcommands")

    def do_xapis(self, arg):
        """Print all APIs

        Args:
            arg (None): No arguments
        """
        api_count = 0
        max_api_len = 0
        apis = []
        for api in dir(self):
            if not api.startswith("api_"):
                continue
            api_name = api
            max_api_len = max(max_api_len, len(api_name))
            api_desc = f"{YELLOW}Description not found{RESET}"
            try:
                api_desc = getattr(self, api).__doc__.split("\n")[0]
            except Exception as e:
                pass
            apis.append((api, api_name, api_desc))
            api_count += 1
        apis.sort(key=lambda x: x[0])
        for c in apis:
            message(("%-"+str(max_api_len+2)+"s: %s (from %s)") % (c[1], c[2], self.register_map.get(c[0], self.__class__.__name__)))
        info(f"Total {api_count} APIs")

    def do_xset_log(self, arg):
        """Set log on or off

        Args:
            arg (string): Log level
        """
        if not arg:
            message("usage: xset_log <on or off>")
            return
        if arg == "on":
            info("Set log on")
            set_log(True)
        elif arg == "off":
            set_log(False)
            info("Set log off")
        else:
            message("usage: xset_log <on or off>")
    
    def do_xset_log_file(self, arg):
        """Set log file

        Args:
            arg (string): Log file name
        """
        if not arg:
            message("usage: xset_log_file <log file>")
            return
        set_log_file(arg)
        info("Set log file to %s" % arg)
