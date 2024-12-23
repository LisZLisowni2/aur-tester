FROM archlinux:latest
RUN pacman -Syu --noconfirm && pacman -S --noconfirm bash base-devel git shellcheck clamav rkhunter cmake make && useradd -m buildtest && echo "buildtest ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
WORKDIR /home/buildtest/app
RUN chown -R buildtest /home/buildtest/app
COPY . . 
RUN cmake . && make 
ENTRYPOINT ["./aurtester"]
