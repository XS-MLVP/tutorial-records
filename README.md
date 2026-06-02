# UnityChip Tutorial Environment Repository 🐳 


This repository contains everything needed to set up the Picker tool's complete development environment. It provides pre-built Docker images and materials for our tutorial series.


## 📦 Repository Contents

```sh
.
├── docker/                  # Docker configurations
│   ├── Dockerfile           # Base image definition 
│   ├── build-scripts/       # Automated build utilities
├── tutorials/               # Traditional tutorial materials
│   ├── README.md            # Basic environment setup guide
│   ├── slides/              # Presentation slides
│   └── code-samples/        # Picker usage examples
├── workshop/                # 🎓 UCAgent Workshop (LLM + Verification)
│   ├── README.md            # Workshop Quick Start
│   ├── env.template         # LLM API configuration template
│   └── examples/            # Pre-loaded verification cases
├── LICENSE
└── README.md                # This document
```

---

## 🎓 UCAgent Workshop

The `workshop` directory provides a ready-to-use environment for exploring **AI-driven automated verification**. 

- **Docker Image**: A one-stop, pre-configured environment containing the UCAgent toolkit and all necessary dependencies.
- **Interactive UI**: Manage AI-driven verification tasks and review history via a unified Web interface (port 8800).
- **Pre-loaded Cases**: Includes classic designs like `exu_alu` and `WayLookup` with historical records.

👉 **Ready to start?** Head over to the [Workshop Quick Start](./workshop/README.md).

---

**If you are in the tutorial, please read the [README.md](./tutorials/README.md) in the tutorials directory first.**

## 🚀 Getting Started

### Pre-built Docker Images 💿

1. ​Basic environment
    ```sh
    # This is the base image for the UnityChip tutorial environment, only picker tool is installed without any additional frameworks (e.g. toffee, XSPdb, etc.)
    docker pull ghcr.io/xs-mlvp/envbase:latest
    ```
    Ubuntu 22.04, Python 3.10 + essential development tools
    > Note: This image is smaller and faster to download, but it does not include any additional frameworks. You can install them manually if needed. If you want try picker for your own, this is the image to start with.

2. ​Full environment
    ```sh
    # This is the full image for the UnityChip tutorial environment, which includes the picker tool and all additional frameworks.
    docker pull ghcr.io/xs-mlvp/envfull:latest
    ```
    Ubuntu 22.04, Python 3.10 + essential development tools + additional frameworks (e.g. toffee, XSPdb, etc.)
    > Note: The full image is larger and may take longer to download, but it includes everything you need to get started with the UnityChip tutorial environment.

3. How to run the image

    Start with shell access:
    ```sh
    # 1. If shell is enough for you, run the image with the following command:
    docker run -it --network host ghcr.io/xs-mlvp/envfull:latest
    # 2. If you want to use ssh or vscode remote development, run this command in the container:
    sudo service ssh start
    ```
    > Note: The `--network host` flag allows the container to use the host's network stack. This is useful for accessing services running on the host machine.

    Start with SSH access:
    ```sh
    # 1. If you want to use ssh or vscode remote development, run the image with the following command:
    docker run -itd --network host ghcr.io/xs-mlvp/envfull:latest sudo /usr/sbin/sshd -D
    # 2. SSH into the container (security reason: /etc/ssh/sshd_config is set to only listen to localhost)
    ssh -p 51202 user@localhost # password: user
    # 3. (Optional) If you are running container on a remote server, you can use the following command port forwarding when connecting to the remote server:
    ssh -L 51202:localhost:51202 <your-server-user>@<your-remote-server-ip>
    ```
    > Note: The container ssh port is hardcoded to 51202, so you need to specify this port when connecting. The default password is `user`. You can change it by modifying the Dockerfile or the sshd_config file in the container. The `-D` flag runs the SSH daemon in the foreground, which is necessary for the container to keep running.

### Build Your Own Image 🔨

If you want to build your own image, you can use the provided Dockerfile. This is useful if you want to customize the environment or add additional tools.

#### Requirements

- Docker Engine ≥20.10
- 8GB+ free disk space

#### Build Commands

```sh
# Build base image
./docker/build-scripts/build-base.sh

# Build full toolkit image 
./docker/build-scripts/build-full.sh
```

### Image Contents 🛠️

Images include:

- `Picker` in /usr/local/bin
- `verilator` in /usr/local/bin
- Examples in /workspace/

## 📚 Tutorial Materials

Find workshop resources in repo's /tutorials directory:

- Slide decks (PDF/PPTX)
- Code templates