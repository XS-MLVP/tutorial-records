# UCAgent Workshop Quick Start Guide

Welcome to the UCAgent Workshop! The code and environment for this workshop demonstration are available at the official repository: [https://github.com/XS-MLVP/tutorial-records](https://github.com/XS-MLVP/tutorial-records).

This guide will walk you through pulling the pre-built environment, launching the Web UI, and exploring the pre-configured digital circuit verification cases.

## 📦 Repository Overview

In this repository, you will find:
- **Pre-prepared Cases**: Classic verification examples along with their historical offline verification records.
- **Docker Scripts**: The `Dockerfile` and `start_demo.sh` scripts, which our CI uses to automatically build and publish the workshop image.
- **Environment Template**: A `.env.template` file for optional API configuration.

---

## 🚀 Quick Start (Viewing the Demo)

You **do not** need to build the Docker image yourself. The tutorial repository's CI has automatically built and published the image for you.

### 1. Pull the Docker Image
First, pull the latest workshop image to your local machine:
```bash
docker pull ghcr.io/xs-mlvp/ucagent:workshop_demo
```

### 2. Launch the Demo Environment
Start the container using the following command. This will spin up the Master API server and load the pre-configured background agents:
```bash
docker run -it --rm --network host ghcr.io/xs-mlvp/ucagent:workshop_demo
```
*(Note: We use `--network host` so the container can easily map to your local ports and share your host's network settings.)*

### 3. Explore the Web UI
Once the terminal indicates that all services have started, open your web browser and navigate to:
👉 **http://localhost:8800**

In this unified Master Web Interface, you can:
- **View Pre-loaded Tasks**: On the left-hand task panel, you will see the cases. Both should have a green **Online** status indicator.
- **Review History**: Click the **API** connection button next to any task to jump into its real-time control center. Here, you can review previously generated code, stage verification logs, and Diff files without needing any LLM API keys.

---

## 🛠️ Advanced: Running Verifications Yourself (Optional)

The quick start above is perfect for exploring the UI and viewing the pre-generated results. However, if you wish to write custom prompts and have UCAgent actively generate new code and run verifications in real-time, you must configure your Large Language Model (LLM) credentials.

1. **Prepare your `.env` file**  
   Copy the provided template and fill in your API credentials (e.g., OpenAI or a compatible interface):
   ```bash
   cp .env.template .env
   # Edit .env to add your OPENAI_API_KEY, OPENAI_API_BASE, and OPENAI_MODEL
   ```

2. **Launch with API Access**  
   Run the container again, this time attaching your `.env` file so the agents can connect to the LLM:
   ```bash
   docker run -it --rm --network host --env-file .env ghcr.io/xs-mlvp/ucagent:workshop_demo
   ```
   
With your API keys successfully loaded, the Agents are now fully empowered to execute new automated verification workflows based on your commands!
