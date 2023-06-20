# OVH-Backup
Have you ever try to create an automatic way to backup your own snapshots from your [OVH Cloud](https://github.com/ovh) VPS? Well, me too. That's why I decided to create this project that uses a Raspberry Pi Zero W to create, get and download the snapshot to an external hard drive connected to the Raspberry!

# 📌 Requirements
| Software |                   Donwload Link                   | Older Version Tested | Status |
|:--------:|:-------------------------------------------------:|:--------------------:|:------:|
|  NodeJS  | [Download NodeJS](https://nodejs.org/en/download) |       v12.22.12      |    ✅   |
|    NPM   |                    *from NodeJS                   |        v7.5.2        |    ✅   |
|    Git   |   [Download Git](https://git-scm.com/downloads)   |        v2.30.2       |    ✅   |

# 📌 How to use
<em>*can be different for other devices/operating systems than Raspberry Pi Zero W</em>
```console
# Clone this repository
git clone https://github.com/RobertoValente/ovh-backup.git

# Navigate to the folder
cd ovh-backup

# Install all dependencies of the project
npm install

# Rename the file '.env.example' to '.env'
mv .env.example .env

# Change "XXXXXX" to the correct information (tips inside of '.env')
nano .env
```

<br> ⭐ **Don't forget to Start this repository if you like it!**
