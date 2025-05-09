# README for Tutorial Audience

## Download the Docker Image

### Local Laptop

If you want to run the image locally, it is recommended to use our local Wireless Hotspot to download the image, due to the internet connection speed. The Image is about 1GB, so it may take a while to download.  

You can connect to the wifi hotspot with the following credentials:
- **SSID**: `UnityChip`
- **Password**: `UnityChip2025`

Once connected, you can run the following command to download the image:
```sh
wget -O - http://192.168.100.2/envfull.tar.gz
gzip -d envfull.tar.gz
docker load -i envfull.tar
```

### Remote Server

If you are using a remote server, you can download the Docker image from the GitHub Container Registry.
```sh
docker pull ghcr.io/xs-mlvp/envfull:latest
```

## Run the Docker Image

### Shell Access

If shell access is enough for you, run the image with the following command:
```sh
docker run -it --network host ghcr.io/xs-mlvp/envfull:latest 
```

If you want to use ssh or vscode remote development, run this command in the container:
```sh
sudo service ssh start
```
and go to the next section for SSH access. **(no need to docker run again)**

### SSH Access

If you want to use ssh or vscode remote development, run the image with the following command:
```sh
docker run -itd --network host ghcr.io/xs-mlvp/envfull:latest sudo /usr/sbin/sshd -D
```

Then, SSH into the container (security reason: /etc/ssh/sshd_config is set to only listen to localhost):
```sh
ssh -p 51202 user@localhost # password: user
```

If you are running the container on a remote server, you can use the following command for port forwarding when connecting to the remote server:
```sh
ssh -L 51202:localhost:51202 <your-server-user>@<your-remote-server-ip>
```
> Note: This step is optional if you are running the container on your local machine, it's map server port to localhost for security reason.

### VSCode Remote Development

If you want to use VSCode remote development, just use remote-ssh extension to connect to the container.

