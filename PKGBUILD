pkgname=aur-tester
pkgver=1.0.0
pkgrel=1
pkgdesc="Automate testing AUR packages in an isolated Docker environment"
arch=('x86_64')
url="https://github.com/LisZLisowni2/aur-tester"
license=('MIT')
depends=('docker' 'bash')
source=("Dockerfile" "aur-tester.sh" "LICENSE")
sha256sums=('SKIP' 'SKIP' 'SKIP')

build() {
	chmod +x $srcdir/aur-tester.sh
}

package() {
	install -Dm755 "$srcdir/aur-tester.sh" "$pkgdir/usr/bin/aur-tester"
	install -Dm644 "LICENSE" "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

build() {
	echo "Configuring Docker for user $(whoami)..."
	systemctl start docker
	if ! [ -w docker version ]; then
		sudo chmod 666 /var/run/docker.sock	
	fi

	if ! groups $(whoami) | grep -qw docker; then 
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
	
	echo "Create image of Dockerfile"
	docker build -t aur-tester-image:$pkgver -f "$srcdir/Dockerfile" "$srcdir"
	systemctl stop docker
}
