pkgname=aur-tester
pkgver=1.0.0
pkgrel=1
pkgdesc="Automate testing AUR packages in an isolated Docker environment"
arch=('x86_64')
url="https://github.com/LisZLisowni2/aur-tester"
license=('MIT')
depends=('docker', 'bash')
source=("$pkgname")
sha256sums=('SKIP')

package() {
	install -Dm755 "$srcdir/$pkgname" "$pkgdir/usr/bin/$pkgname"
	install -Dm644 "$srcdir/LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

post_install() {
	systemctl start docker
	echo "Configuring Docker for user $(whoami)..."
	if ! groups $(whoami) | grep -qw docker; then 
		sudo groupadd -f docker
		sudo usermod -aG docker $(whoami)
		echo "User $(whoami) added to Docker group, Please log out and log back in for this to take effect"
	else
		echo "User $(whoami) is already in the Docker group"
	fi

	if ! docker images | grep -qw "archlinux"; then
		echo "Downloading the Arch Linux Docker image..."
		docker pull archlinux:latest
	else
		echo "Arch linux Docker image already exists"
	fi

	dockerfilepath = $pkgdir/etc/aurtester/
	touch $dockerfilepath/Dockerfile
	echo "FROM archlinux:latest" > $dockerfilepath/Dockerfile
	echo "RUN pacman -Syu --noconfirm && \ " >> $dockerfilepath/Dockerfile
	echo "	pacman -S --noconfirm base-devel git clamav" >> $dockerfilepath/Dockerfile
	echo "RUN freshclam" >> $dockerfilepath/Dockerfile
	echo "WORKDIR /aur-package" >> $dockerfilepath/Dockerfile
	echo "ENTRYPOINT ['/bin/bash']" >> $dockerfilepath/Dockerfile
	docker build -t aurtesterimage:$pkgver $dockerfilepath 
	systemctl stop docker
}
