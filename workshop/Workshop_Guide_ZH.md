# UCAgent Workshop 快速上手指南

欢迎来到 UCAgent Workshop！本次 Workshop 演示的代码和环境已经全部开源在官方仓库中：[https://github.com/XS-MLVP/tutorial-records](https://github.com/XS-MLVP/tutorial-records)。

本指南将带你拉取预先构建好的环境、启动 Web UI，并探索我们为你准备好的数字电路芯片验证案例。

## 📦 仓库内容简介

在这个仓库中，包含了以下内容：
- **预置验证案例**：经典的数字电路验证案例（如 Adder 加法器和 ALU754 浮点运算器），以及它们离线跑完的历史验证记录。
- **Docker 脚本**：`Dockerfile` 和 `start_demo.sh`，我们的 CI 流水线会自动使用它们来构建和发布本次 Workshop 的镜像。
- **环境配置模板**：`.env.template` 文件，用于你在后续环节配置自己的大模型 API。

---

## 🚀 快速开始（体验演示案例）

你**不需要**从头开始构建 Docker 镜像，tutorial 仓库的 CI 已经自动帮你打包并发布好了。

### 1. 拉取镜像
首先，将最新的 Workshop 镜像拉取到你的本地电脑：
```bash
docker pull ghcr.io/xs-mlvp/ucagent:workshop_demo
```

### 2. 启动演示环境
运行以下命令来启动容器。这会自动启动 Master API 服务，并在后台加载好我们为你准备的预置任务：
```bash
docker run -it --rm --network host ghcr.io/xs-mlvp/ucagent:workshop_demo
```
*(注意：我们使用了 `--network host` 参数，这样容器可以直接映射并使用你宿主机的网络和端口。)*

### 3. 探索 Web UI
当终端提示服务启动完毕后，打开你的浏览器并访问：
👉 **http://localhost:8800**

在这个统一管理的 Master Web 界面中，你可以：
- **查看预置任务**：在左侧的任务面板中，你会看到 `Adder` 和 `ALU754` 两个案例，它们应该都已经亮起了绿色的 **Online** 状态灯。
- **复盘历史记录**：点击任意任务旁边的 **API** 按钮，即可进入该任务的实时控制台。在这里，你不需要配置任何大模型 Key，就可以直接查看 AI 之前生成的验证代码、日志以及阶段比对（Diff）。

---

## 🛠️ 进阶操作：亲自运行大模型验证（可选）

上述的基础体验步骤非常适合浏览 UI 和查看预生成的验证结果。但是，如果你想亲自向 AI 下发 Prompt，让 UCAgent 实时为你生成新的验证代码并执行测试，你就需要配置自己的大模型（LLM）API 凭证了。

1. **准备 `.env` 配置文件**  
   复制我们提供的模板文件，填入你的 API Key 等信息（支持 OpenAI 或兼容接口）：
   ```bash
   cp .env.template .env
   # 编辑 .env 文件，补全 OPENAI_API_KEY, OPENAI_API_BASE 和 OPENAI_MODEL
   ```

2. **携带 API 权限启动**  
   使用挂载了环境变量的命令重新运行容器，让内部的 Agent 连接到大模型网络：
   ```bash
   docker run -it --rm --network host --env-file .env ghcr.io/xs-mlvp/ucagent:workshop_demo
   ```
   
配置成功后，各个 Agent 就拥有了完整的执行能力，你可以开始下达新的指令，开启真正的自动化验证之旅了！
