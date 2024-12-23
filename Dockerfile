FROM archlinux:latest
RUN pacman -Syu --noconfirm && pacman -S --noconfirm bash base-devel git shellcheck clamav rkhunter && useradd -m buildtest && echo "buildtest ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /home/buildtest/aur-package
RUN chown -R buildtest /home/buildtest/aur-package
ENTRYPOINT ["/bin/bash"]
