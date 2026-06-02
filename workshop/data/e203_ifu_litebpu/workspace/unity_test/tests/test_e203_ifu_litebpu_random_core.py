#coding=utf-8

from e203_ifu_litebpu_api import *  # 必须使用 import *，确保 fixture 和 API 均可被 pytest 发现
import random
import ucagent


U32_MASK = 0xFFFFFFFF


def _rand_u32(rng):
    return rng.getrandbits(32) & U32_MASK


def test_random_predict_and_operands(env):
    """随机验证 JAL/Bxx/JALR x0/x1 的静态预测和操作数选择。

    该用例只选择无已知设计缺陷的组合：有效指令、JALR x1 无依赖、JALR x0。
    """
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-JAL-PREDICT", test_random_predict_and_operands, ["CK-JAL-TAKEN", "CK-JAL-NO-WAIT"]
    )
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-JALR-PREDICT", test_random_predict_and_operands, ["CK-JALR-X0-TAKEN", "CK-JALR-X1-TAKEN-READY"]
    )
    env.dut.fc_cover["FG-PREDICT"].mark_function(
        "FC-BXX-PREDICT", test_random_predict_and_operands, ["CK-BXX-BACKWARD-TAKEN", "CK-BXX-FORWARD-NOT-TAKEN"]
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-PC", test_random_predict_and_operands, ["CK-JAL-OP1-PC", "CK-BXX-OP1-PC"]
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-JALR-X0", test_random_predict_and_operands, ["CK-X0-OP1-ZERO"]
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-JALR-X1", test_random_predict_and_operands, ["CK-X1-OP1-VALUE", "CK-X1-VALUE-BOUNDARY"]
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP2-IMM", test_random_predict_and_operands, ["CK-IMM-POSITIVE", "CK-IMM-NEGATIVE", "CK-IMM-EXTREME"]
    )

    rng = random.Random(0xE203B001)
    for i in range(ucagent.repeat_count()):
        pc = _rand_u32(rng)
        imm = _rand_u32(rng)
        x1_value = _rand_u32(rng)
        case = rng.choice(("jal", "bxx", "jalr_x0", "jalr_x1"))

        if case == "jal":
            actual_output = api_e203_ifu_litebpu_jal(env, pc=pc, imm=imm)
            expected_output = {
                "prdt_taken": 1,
                "prdt_pc_add_op1": pc,
                "prdt_pc_add_op2": imm,
                "bpu_wait": 0,
                "bpu2rf_rs1_ena": 0,
            }
        elif case == "bxx":
            actual_output = api_e203_ifu_litebpu_bxx(env, pc=pc, imm=imm)
            expected_output = {
                "prdt_taken": 1 if (imm & 0x80000000) else 0,
                "prdt_pc_add_op1": pc,
                "prdt_pc_add_op2": imm,
                "bpu_wait": 0,
                "bpu2rf_rs1_ena": 0,
            }
        elif case == "jalr_x0":
            actual_output = api_e203_ifu_litebpu_jalr(
                env, pc=pc, imm=imm, rs1idx=0, rf2bpu_x1=x1_value, rf2bpu_rs1=_rand_u32(rng)
            )
            expected_output = {
                "prdt_taken": 1,
                "prdt_pc_add_op1": 0,
                "prdt_pc_add_op2": imm,
                "bpu_wait": 0,
                "bpu2rf_rs1_ena": 0,
            }
        else:
            actual_output = api_e203_ifu_litebpu_jalr(
                env,
                pc=pc,
                imm=imm,
                rs1idx=1,
                rf2bpu_x1=x1_value,
                rf2bpu_rs1=_rand_u32(rng),
                oitf_empty=1,
                jalr_rs1idx_cam_irrdidx=0,
            )
            expected_output = {
                "prdt_taken": 1,
                "prdt_pc_add_op1": x1_value,
                "prdt_pc_add_op2": imm,
                "bpu_wait": 0,
                "bpu2rf_rs1_ena": 0,
            }

        assert actual_output == expected_output, (
            f"随机预测/操作数失败: iter={i}, case={case}, pc=0x{pc:08x}, imm=0x{imm:08x}, "
            f"expected={expected_output}, actual={actual_output}"
        )


def test_random_x1_dependency_wait(env):
    """随机验证 JALR x1 的 OITF/IR CAM 依赖等待规则。"""
    env.dut.fc_cover["FG-JALR-DEPENDENCY"].mark_function(
        "FC-X1-DEPENDENCY",
        test_random_x1_dependency_wait,
        ["CK-X1-OITF-BUSY-WAIT", "CK-X1-IR-CAM-WAIT", "CK-X1-READY-NO-WAIT"],
    )

    rng = random.Random(0xE203B002)
    for i in range(ucagent.repeat_count()):
        pc = _rand_u32(rng)
        imm = _rand_u32(rng)
        x1_value = _rand_u32(rng)
        oitf_empty = rng.randint(0, 1)
        cam_hit = rng.randint(0, 1)

        actual_output = api_e203_ifu_litebpu_jalr(
            env,
            pc=pc,
            imm=imm,
            rs1idx=1,
            rf2bpu_x1=x1_value,
            oitf_empty=oitf_empty,
            jalr_rs1idx_cam_irrdidx=cam_hit,
        )
        expected_wait = 1 if ((not oitf_empty) or cam_hit) else 0
        expected_output = {
            "prdt_taken": 1,
            "prdt_pc_add_op1": x1_value,
            "prdt_pc_add_op2": imm,
            "bpu_wait": expected_wait,
            "bpu2rf_rs1_ena": 0,
        }

        assert actual_output == expected_output, (
            f"随机 x1 依赖失败: iter={i}, oitf_empty={oitf_empty}, cam_hit={cam_hit}, "
            f"expected={expected_output}, actual={actual_output}"
        )


def test_random_rs1_read_state_and_gating(env):
    """随机验证 xN rs1 读请求产生、单周期抑制重复读以及门控条件。"""
    env.dut.fc_cover["FG-RS1-READ"].mark_function(
        "FC-RS1-READ-REQUEST", test_random_rs1_read_state_and_gating, ["CK-XN-READ-ENABLE"]
    )
    env.dut.fc_cover["FG-RS1-READ"].mark_function(
        "FC-RS1-READ-STATE",
        test_random_rs1_read_state_and_gating,
        ["CK-NO-REPEAT-READ", "CK-READ-STATE-CLEAR"],
    )
    env.dut.fc_cover["FG-RS1-READ"].mark_function(
        "FC-RS1-READ-GATING",
        test_random_rs1_read_state_and_gating,
        ["CK-NON-JALR-NO-READ", "CK-X0-X1-NO-XN-READ", "CK-DEPENDENCY-NO-READ"],
    )
    env.dut.fc_cover["FG-OPERAND"].mark_function(
        "FC-OP1-JALR-XN", test_random_rs1_read_state_and_gating, ["CK-XN-OP1-RS1", "CK-XN-VALUE-BOUNDARY"]
    )

    rng = random.Random(0xE203B003)
    for i in range(ucagent.repeat_count()):
        api_e203_ifu_litebpu_reset(env)
        pc = _rand_u32(rng)
        imm = _rand_u32(rng)
        rs1idx = rng.randint(2, 31)
        rs1_value = _rand_u32(rng)

        first = api_e203_ifu_litebpu_jalr(
            env, pc=pc, imm=imm, rs1idx=rs1idx, rf2bpu_rs1=rs1_value, oitf_empty=1, ir_empty=1
        )
        assert first["bpu2rf_rs1_ena"] == 1, (
            f"xN ready 首周期应读 rs1: iter={i}, rs1idx={rs1idx}, actual={first}"
        )
        assert first["prdt_pc_add_op1"] == rs1_value, (
            f"xN op1 应选择 rf2bpu_rs1: iter={i}, expected=0x{rs1_value:08x}, actual={first}"
        )

        second = api_e203_ifu_litebpu_jalr(
            env, pc=pc, imm=imm, rs1idx=rs1idx, rf2bpu_rs1=rs1_value, oitf_empty=1, ir_empty=1
        )
        assert second["bpu2rf_rs1_ena"] == 0, f"读状态置位后不应重复读: iter={i}, actual={second}"

        cleared = api_e203_ifu_litebpu_predict(env, pc=pc, dec_i_valid=1)
        assert cleared["bpu2rf_rs1_ena"] == 0, f"非 JALR 周期应清除读请求输出: iter={i}, actual={cleared}"

        gated_jal = api_e203_ifu_litebpu_jal(env, pc=pc, imm=imm)
        assert gated_jal["bpu2rf_rs1_ena"] == 0, f"JAL 不应产生 xN 读请求: iter={i}, actual={gated_jal}"

        gated_x0 = api_e203_ifu_litebpu_jalr(env, pc=pc, imm=imm, rs1idx=0)
        gated_x1 = api_e203_ifu_litebpu_jalr(env, pc=pc, imm=imm, rs1idx=1, rf2bpu_x1=_rand_u32(rng))
        assert gated_x0["bpu2rf_rs1_ena"] == 0, f"JALR x0 不应产生 xN 读请求: iter={i}, actual={gated_x0}"
        assert gated_x1["bpu2rf_rs1_ena"] == 0, f"JALR x1 不应产生 xN 读请求: iter={i}, actual={gated_x1}"

        blocked = api_e203_ifu_litebpu_jalr(
            env, pc=pc, imm=imm, rs1idx=rs1idx, rf2bpu_rs1=rs1_value, oitf_empty=0
        )
        assert blocked["bpu_wait"] == 1, f"xN OITF busy 时应等待: iter={i}, actual={blocked}"
        assert blocked["bpu2rf_rs1_ena"] == 0, f"xN OITF busy 时不应读 rs1: iter={i}, actual={blocked}"
