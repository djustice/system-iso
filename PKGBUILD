# J

pkgname=swiftiso
pkgver=1
pkgrel=1
pkgdesc='Tools for creating system iso images'
arch=('any')
license=('GPL')
url='invalid.url'
depends=('make' 'arch-install-scripts' 'squashfs-tools' 'libisoburn' 'dosfstools' 'lynx')
source=("${pkgname}-${pkgver}.tar.xz"
        "${pkgname}-${pkgver}.tar.xz.sig")
sha256sums=('08780fc7e0ce224d4e786b9c78499cd7f7727eff97b37d04def7d0395174aa3e'
            'SKIP')

package() {
    make DESTDIR="${pkgdir}" install
}
