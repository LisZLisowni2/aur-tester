# Aur-tester

AUR packages are like downloading suspicious files from Internet and install it on Windows.
AUR packages are not offcially verified and you are responsible for your safety.
Aur-tester will help you with that. Aur-tester creates a isolated environment using Docker containers
and test package that you want to install in that environment. Also will be launched scripts to scan
system for malware and rootkits (clamav and rkhunter).  
**WARNING! EVEN WITH THIS TOOL YOU ARE STILL RESPONSIBLE FOR THE SECURITY OF YOUR SYSTEM!**

## Features

- Automates scanning for malicious files from AUR package
- Isolated environment for safety of your system

## Installation

### From AUR

Follow the instructions by installing other packages from AUR

### Source

Clone a git repository and run `makepkg -is`

```sh
sudo pacman -S git base-devel
git clone [AUR LINK IN FUTURE]
cd aur-tester
makepkg -is
```

## Usage

Basic syntax: `aur-tester [OPTIONS] <PACKAGE NAME>`

#### Basic operations

<table>
  <tr><th>Command</th><th>Description</th></tr>
  <tr><td>aur-tester --version</td><td>Display version</td></tr>
  <tr><td>aur-tester -v <PACKAGE NAME></td><td>More output</td></tr>
  <tr><td>aur-tester -s <PACKAGE NAME></td><td>Scan only changed files by installation</td></tr>
</table>

## Support

If you have a issue, question or something else request via Github issues. This package isn't offcial support by Arch linux so don't search answers on offcial channels.    
In issue put crucial informations like full output and used tool to install package.
