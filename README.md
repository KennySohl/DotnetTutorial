# Create a web app

## create VM

- Create the provision file `provision_vm_dotnet.sh` with the following content:

```bash
#!/bin/bash

RESOURCE_GROUP_NAME=DotnetTutorialRG
VM_NAME=DotnetTutorialVM
PORT=5000

az group create --name $RESOURCE_GROUP_NAME --location northeurope

az vm create \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $VM_NAME \
  --image Ubuntu2404 \
  --size Standard_B1s \
  --admin-username azureuser \
  --generate-ssh-keys

az vm open-port \
  --resource-group $RESOURCE_GROUP_NAME \
  --name $VM_NAME \
  --port $PORT \
```

- run the file

```bash
./provision_vm_dotnet.sh
```

## Create mvc

- choose the folder to install your app
- Write this command in that folder:

```bash
1.Cloud2025/DotnetTutorial/DotnetApp $ dotnet new mvc
```

- To run the app write:

```bash
1.Cloud2025/DotnetTutorial/DotnetApp $ dotnet run
```

- Get your public IP address from the VM you created in Azure and SSH into it:

```bash
/1.Cloud2025/DotnetTutorial/DotnetApp $ ssh azureuser@52.164.204.19
```

- say yes to continue to login

- Follow the instructions on the Microsoft website to install .NET (choose your .NET version):
  - [Install .NET on Ubuntu](https://learn.microsoft.com/en-us/dotnet/core/install/linux-ubuntu-install?tabs=dotnet9&pivots=os-linux-ubuntu-2404)

```bash
sudo add-apt-repository ppa:dotnet/backports -y
sudo apt-get update
sudo apt-get install -y aspnetcore-runtime-9.0
sudo apt-get install -y dotnet-sdk-9.0
```

- Create the directory for your app:

```bash
azureuser@CliAzureTutorialVM:~$ mkdir -p /opt/DotnetApp
```

- If you get a permission question, use:

```bash
sudo !!
```

- Set the admin user:

```bash
sudo chown azureuser:azureuser /opt/DotnetApp
```

- To publish the app, use:

```bash
1.Cloud2025/DotnetTutorial/DotnetApp $ dotnet publish
```

- Right-click on the publish folder and "open in integrated terminal", then use SCP to copy the files to the VM:

```bash
C:\1.Cloud2025\DotnetTutorial\DotnetApp\bin\Release\net9.0\publish> scp -r ./ azureuser@40.69.43.253:/opt/DotnetApp/
```

- Login to SSH and type following:

```bash
azureuser@CliAzureTutorialVM:/opt/DotnetApp$ export ASPNETCORE_URLS=http://*:5000
```

- Create the service file:

```bash
azureuser@CliAzureTutorialVM:/opt/DotnetApp$ sudo nano /etc/systemd/system/dotnetapp.service
```

- Paste the following content:

```
[Unit]
Description=DotnetApp .NET web Application
After=network.target

[Service]
WorkingDirectory=/opt/DotnetApp
ExecStart=/usr/bin/dotnet /opt/DotnetApp/DotnetApp.dll
Restart=always
User=www-data
Group=www-data
Environment=DOTNET_ENVIRONMENT=Production
Environment=ASPNETCORE_URLS=http://0.0.0.0:5000

[Install]
WantedBy=multi-user.target
```

- Save and close the file (press `Ctrl+X`, then `Y`, and `Enter`).

```bash
sudo systemctl daemon-reload
sudo systemctl enable dotnetapp
sudo systemctl start dotnetapp
```

- Check the status:

```bash
sudo systemctl status dotnetapp
```

- To start or stop the service:

```bash
sudo systemctl start dotnetapp.service
sudo systemctl stop dotnetapp.service
```

- To restart the web app using Azure CLI:

```bash
az webapp restart --name DotnetApp --resource-group DotnetTutorialRG
```
