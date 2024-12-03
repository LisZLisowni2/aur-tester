FROM archlinux:latest
RUN pacman -Syu --noconfirm && pacman -S --noconfirm base-devel git
WORKDIR /aur-package
ENTRYPOINT ['/bin/bash']
