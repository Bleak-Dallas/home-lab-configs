============================================================
🏠 Homelab Master Guide
============================================================

This document combines key setup guides, commands, and best practices for your homelab, covering Proxmox, Ubuntu, Docker, Robocopy, Python virtual environments, and common admin tasks.

============================================================
📑 Table of Contents
============================================================
1. Proxmox: VM/Container Setup & Templates
2. Docker Installation (Ubuntu)
3. Ubuntu User Setup Guide
4. Robocopy Best Settings
5. Python Virtual Environments (venv)
6. Rsync Commands for File/Folder Sync


------------------------------------------------------------
1. Proxmox: VM/Container Setup & Templates
------------------------------------------------------------
- Change timezone:
```bash
timedatectl list-timezones
sudo timedatectl set-timezone America/Denver
timedatectl
```

- Optional user setup:
```bash
sudo adduser <username>
sudo usermod -aG sudo <username>
sudo usermod -aG docker <username>
```

- Prepare VM/container template:
```bash
sudo apt install cloud-init
cd /etc/ssh && sudo rm ssh_host_*
sudo truncate -s 0 /etc/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
sudo apt clean && sudo apt autoremove
sudo cloud-init clean
sudo poweroff
```

- Proxmox GUI tasks:
    * Right click instance → Create Template
    * Hardware → CD drive → Do not use any media
    * Add CloudInit drive → Configure → Regenerate Image

- Container post-clone fixes:
```bash
sudo dpkg-reconfigure openssh-server
sudo nano /etc/hostname
sudo nano /etc/hosts
```

------------------------------------------------------------
2. Docker Installation (Ubuntu)
------------------------------------------------------------
- Remove old versions:
```bash
sudo apt-get remove docker docker-engine docker.io containerd runc
```

- Install prerequisites:
```bash
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
```

- Add Docker’s GPG key & repo:
```bash
sudo install -m 0755 -d /etc/apt/keyrings
```
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
```bash
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo $VERSION_CODENAME) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

- Install Docker & Compose:
```bash
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

- Verify:
```bash
docker version
docker compose version
```

- Add user to docker group:
```bash
sudo usermod -aG docker <username>
```

------------------------------------------------------------
3. Ubuntu User Setup Guide
------------------------------------------------------------
- Create user:
```bash
sudo adduser <username>
```

- Grant sudo:
```bash
sudo usermod -aG sudo <username>
```

- Switch user:
```bash
sudo -i -u <username>
```

- Setup SSH:
```bash
mkdir -p ~/.ssh && chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

- Passwordless sudo:
```bash
echo -e "<username> ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopasswd-users
sudo chmod 440 /etc/sudoers.d/nopasswd-users
```

- Fish shell:
```bash
which fish
sudo chsh -s /usr/bin/fish <username>
```

------------------------------------------------------------
4. Robocopy Best Settings
------------------------------------------------------------
```bash
robocopy "N:\mediaserver\other videos\Basement Finishing Videos" "D:\Basement Finishing Videos" /E /MT:32 /R:1 /W:1 /NFL /NDL /NP /LOG+:robocopy.log
```

- /E → copy subfolders (incl. empty)
- /MT:32 → multithreaded (CPU supports 64, but USB bottlenecks)
- /R:1 /W:1 → quick retry on error
- /NFL /NDL → suppress file/folder logs
- /NP → no per-file progress
- /LOG+: → append log

------------------------------------------------------------
5. Python Virtual Environments (venv)
------------------------------------------------------------
- Create:
```bash
python -m venv <env_name>
```

- Activate:
```bash
Windows: <env_name>\Scripts\activate
Linux/macOS: source <env_name>/bin/activate
```

- Install packages:
    pip install numpy pandas

- Deactivate:
    deactivate

- Freeze dependencies:
    pip freeze > requirements.txt
    pip install -r requirements.txt

------------------------------------------------------------
------------------------------------------------------------
6. Rsync Commands for File/Folder Sync
------------------------------------------------------------
Rsync is a powerful tool for syncing files between systems over SSH.

Common flags explained:
- -r → recursive (include subdirectories)
- -l → copy symlinks as symlinks
- -t → preserve modification times
- -D → preserve device and special files
- -v → verbose output
- -z → enable compression during transfer
- -P → show progress and allow resume of partial transfers
- --no-perms/--no-owner/--no-group → do not preserve ownership or permissions (useful across systems)
- -m → prune empty directories
- --dry-run → simulate the command without making changes
- -e "ssh" → specify remote shell (ssh)

==== FILES ====
Simulate syncing files containing "defiance" (case-insensitive) from remote to local:

```bash
rsync -rltDvzP --no-perms --no-owner --no-group -m --dry-run \
```
  -e "ssh" \
  --include='*/' \
  --include='*[Dd][Ee][Ff][Ii][Aa][Nn][Cc][Ee]*' \
  --exclude='*' \
  'dbleak42@tamarind.whatbox.ca:/home/dbleak42/files/' \
  /mnt/hdd-storage-1/mediaserver/torrents/

==== FOLDER ====
Simulate syncing entire folders containing "defiance" (case-insensitive):

```bash
rsync -rltDvzP --no-perms --no-owner --no-group -m --dry-run \
```
  -e "ssh" -s \
  --include='*/' \
  --include='*[Dd][Ee][Ff][Ii][Aa][Nn][Cc][Ee]*/**' \
  --exclude='*' \
  dbleak42@tamarind.whatbox.ca:/home/dbleak42/files/ \
  /mnt/hdd-storage-1/mediaserver/torrents/

============================================================
✅ End of Guide
============================================================