# PVE API Shell
Shell Script to manage VMs on a Proxmox VE Server using the Proxmox VE API

## How To
First you sould clone the repo or download the pve\_vm\_api.sh file

### API Token
- First you should create a new user on your Proxmox Server
- Grant only the necessary permissons for this user  
These would be */vms/VM.Audit* and */vms/VM.PowerMgmt*
- Create a API Token for this user
- Save the token as a file named *token* into the same folder as the .sh script
- The content of the file should look like this: ***<user\>@pam!<tokenname\>=<token-secret\>***

### Config
You can add a file named *pve.conf* into the same folder as the script and token file
This file can contain following default parameters:
- URL=<url to yout PVE server\> e.g. *https://pve.example.local:8006*
- NODE=<the node where your vm lives\> e.g. *pve01*

### Run the script
``./pve_vm_api.sh <vm id> <start|stop|shutdown|current> [<url> <node>]``

These are all positional arguments!
*url* and *node* will override the values given in the config file