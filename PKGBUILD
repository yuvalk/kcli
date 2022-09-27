# This is an example PKGBUILD file. Use this as a start to creating your own,
# and remove these comments. For more information, see 'man PKGBUILD'.
# NOTE: Please fill out the license field for your package! If it is unknown,
# then please put 'unknown'.

# Maintainer: Yuval Kashtan <yuvalkashtan@gmail.com>
pkgname=kcli
pkgver=0.1
pkgrel=1
arch=('x86_64')
license=('GPL')
pkgdesc="Wrapper for libvirt,gcp,aws,ovirt,openstack,kubevirt and vsphere"
url="https://github.com/karmab/kclii#master"
makedepends=('python-setuptools')
depends=(
	'python'
	'libvirt-python'
	'cdrtools'
	'nmap-netcat'
	'python-prettytable'
	'python-jinja'
	'python-yaml'
	'python-argcomplete'
	'python-requests'
)
source=("git+https://github.com/karmab/kcli")

build() {
	cd ${pkgname}
	sed -i "s/, 'libvirt.*/\]/" setup.py
	INSTALL=$(grep -m 1 INSTALL setup.py  | sed 's/INSTALL = //')
	sed -i "s/install_requires=INSTALL/install_requires=$INSTALL/" setup.py
	sed -i '/INSTALL/d' setup.py
	GIT_VERSION="$(curl -s https://github.com/karmab/kcli/commits/master | grep 'https://github.com/karmab/kcli/commits/master?' | sed 's@.*=\(.......\).*+.*@\1@') $(date +%Y/%m/%d)"
	echo $GIT_VERSION > kvirt/version/git
	python setup.py build
}

package() {
	cd ${pkgname}
	python setup.py install --root="$pkgdir" --optimize=1
}
