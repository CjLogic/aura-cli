pkgname=aura-cli
pkgdesc='Aura CLI tool and dotfiles'
pkgver=1.0
pkgrel=1
arch=('x86_64')
url='https://github.com/CjLogic/aura-cli'
license=('GPL-3.0-only')
depends=('python' 'python-pillow' 'python-materialyoucolor' 'libnotify' 'swappy' 'grim' 'dart-sass' 'wl-clipboard' 'slurp' 'gpu-screen-recorder' 'glib2' 'cliphist' 'fuzzel')
makedepends=('python-build' 'python-installer' 'python-wheel')
optdepends=('app2unit: systemd user service manager')

prepare() {
  # Copy local files to srcdir (only if not already there)
  if [ "$BUILDDIR" != "$srcdir" ]; then
    # Preserve full layout including hidden files
    cp -a "$BUILDDIR/." "$srcdir/" 2>/dev/null || true
  fi
}

build() {
  cd "$srcdir"

  # Build Python wheel
  python -m build --wheel --no-isolation
}

package() {
  cd "$srcdir"

  # Install Python wheel
  python -m installer --destdir="$pkgdir" dist/*.whl

  # Install fish completions
  if [ -f "$srcdir/completions/aura.fish" ]; then
    install -Dm644 "$srcdir/completions/aura.fish" "$pkgdir/usr/share/fish/vendor_completions.d/aura.fish"
  fi

  # Create target directory under /opt for additional files
  mkdir -p "$pkgdir/opt/$pkgname"

  # Copy bin directory
  if [ -d "$srcdir/bin" ]; then
    cp -a "$srcdir/bin" "$pkgdir/opt/$pkgname/"
  fi

  # Copy completions directory
  if [ -d "$srcdir/completions" ]; then
    cp -a "$srcdir/completions" "$pkgdir/opt/$pkgname/"
  fi

  # Copy top-level files if present
  for f in .envrc LICENSE README.md pyproject.toml default.nix flake.nix .gitignore; do
    if [ -f "$srcdir/$f" ]; then
      cp -a "$srcdir/$f" "$pkgdir/opt/$pkgname/"
    fi
  done

  # Set proper permissions for executables in bin/
  if [ -d "$pkgdir/opt/$pkgname/bin" ]; then
    find "$pkgdir/opt/$pkgname/bin" -type f -exec chmod 755 {} +
  fi
}
