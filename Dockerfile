FROM archlinux:latest
RUN pacman -Syu --noconfirm && pacman -S --noconfirm nano vim bash base-devel git shellcheck clamav rkhunter cmake make && useradd -m buildtest && echo "buildtest ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 
WORKDIR /home/buildtest/app
COPY . . 
RUN cmake . && make 
RUN chown -R buildtest /home/buildtest/
ENTRYPOINT ["./aurtester"]
