# UnityChip Tutorial Environment Repository 🐳 


This repository contains everything needed to set up the Picker tool's complete development environment. It provides pre-built Docker images and materials for our tutorial series.


## 📦 Repository Contents

```sh
.
├── docker/                  # Docker configurations
│   ├── Dockerfile           # Base image definition 
│   ├── Dockerfile.full      # Full image definition
│   ├── build-scripts/       # Automated build utilities
│   └── compose/             # (Optional) Docker-compose files
├── tutorials/               # Workshop materials
│   ├── ppt/                 # Presentation slides
│   └── code-samples/        # Demo scripts
├── LICENSE
└── README.md                 # This document
```

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