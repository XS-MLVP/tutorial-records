# UCAgent Workshop: 如何添加新的展示示例 (Add New Example Guide)

基于我们恢复 `e203_exu_alu` 任务的经验，如果你后续需要在 `workshop/data/` 下添加一个新的已完成的 Agent 任务作为展示示例，你需要执行以下 5 个主要步骤。

## 1. 准备任务数据 (Prepare Task Data)
将完整的任务工作区文件夹（例如 `ucagent_launch_xxxxxx`）放置到 `workshop/data/` 目录下。
该目录至少应包含：
- `workspace/.ucagent/ucagent_info.json` (Agent 的核心状态文件)
- `workspace/` 下的所有源码和测试用例产物

## 2. 更新 Master 数据库 (`workshop/data/.ucagent/master_db/`)

你需要手动将新任务的信息注册到 Master 的离线数据库中，以便 Web UI 能够读取。

### 2.1 更新 `tasks.json`
在 `tasks` 对象下添加一个新的任务条目。
**关键字段要求：**
- `task_id`: 任务的唯一 ID。
- 路径替换：所有绝对路径（如 `workspace_dir`, `main_verilog_path`, 日志路径）必须修改为容器内的路径前缀 `/workspace/UCAgent/summit_examples/`。
  *例如: `/workspace/UCAgent/summit_examples/ucagent_launch_xxxxxx`*
- `process_status`: 必须设置为 `"running"`，否则 Web UI 默认可能不显示。
- 进度字段：必须包含 `current_stage_index` 和 `total_stage_count`（例如都设为 28）。
- `task_list`: 必须注入完整的阶段列表数据（可以通过上面我们使用的 Python 脚本提取）。

### 2.2 更新 `workspaces.json`
在 `workspaces` 对象下添加新的工作区条目。
**关键字段要求：**
- 同样需要将 `workspace_dir`, `picker_workspace`, `base_root` 替换为容器内路径 `/workspace/UCAgent/summit_examples/...`。

### 2.3 更新 `agents.json` (可选但推荐)
如果想让 Agent 一启动就显示在线并匹配任务进度：
- 预先写入一条 Agent 记录，指定一个固定的 Agent ID。
- 设置 `last_seen` 为一个较新的时间戳。
- 设置 `is_mission_complete`: `true`, `current_stage_index` 为最终阶段。

## 3. 净化 Agent 状态文件 (`ucagent_info.json`)
为了防止因为拷贝数据导致 Git 历史断链，从而引起 `/api/mission` 接口报 `500 Server Error`，必须清理并锁定 Agent 状态：

```python
# 你可以在打包前用 Python 脚本处理，或像 start_demo.sh 中那样在启动前动态处理：
import json
path = 'workshop/data/ucagent_launch_xxxxxx/workspace/.ucagent/ucagent_info.json'
u = json.load(open(path))
# 1. 清除无效的 Git Commit Hash
for stage in u.get('stages_info', {}).values():
    stage.get('meta_data', {}).pop('commit', None)
# 2. 锁定已完成状态，防止 Agent 再次调用大模型
u['is_agent_exit'] = True
u['all_completed'] = True
u['stage_index'] = 28 # 根据实际总阶段数填写
json.dump(u, open(path, 'w'), indent=4)
```

## 4. 更新启动脚本 (`docker/start_demo.sh`)

修改 `start_demo.sh`，将新任务加入后台启动列表。

1. 在 `TASK_SPECS` 数组中添加一行，格式为 `任务目录名:DUT名:CMD_PORT:WEB_PORT:TERM_PORT`。
   **注意：** 必须为新任务分配未被占用的端口！
   ```bash
   TASK_SPECS=(
       "ucagent_launch_yt3xgf7c:e203_exu_alu:8765:8000:8818"
       "ucagent_launch_xxxxxx:new_dut_name:8766:8001:8819"  # 添加新任务
   )
   ```
2. 确保 Agent 启动命令保持 "空闲心跳模式" (Idle Mode)，以防止已完成任务死循环报错：
   需要包含 `--human`, `--client-id $AGENT_ID` (需确保不同任务的 Agent ID 不冲突)，以及 `--icmd "sleep 999999"`。

## 5. 更新 Dockerfile (`docker/Dockerfile.workshop`)

如果你为新任务分配了新的端口，必须在 Dockerfile 中通过 `EXPOSE` 指令暴露它们，并在运行容器时使用 `-p` 映射。

```dockerfile
# 之前的端口
# 8800: Master Web UI
# 8000, 8001: Agent Web Consoles
# 8765, 8766: Agent CMD APIs
# 8818, 8819: Agent Web Terminals

# 更新 EXPOSE 加入新端口
EXPOSE 8800 8000 8001 8765 8766 8818 8819
```

## 6. 重新构建 Docker 镜像
完成上述所有本地文件的修改后，**必须**重新构建镜像：
```bash
docker build -t workshop:latest -f docker/Dockerfile.workshop .
```