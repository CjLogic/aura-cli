pkgname=aura-cli
pkgdesc='Aura CLI tool and dotfiles'
pkgver=1.0
pkgrel=1
arch=('x86_64')
url='https://github.com/CjLogic/aura-cli'
license=('GPL-3.0-only')
depends=('libnotify' 'swappy' 'grim' 'dart-sass' 'wl-clipboard' 'slurp' 'gpu-screen-recorder' 'glib2' 'cliphist' 'fuzzel')
optdepends=('app2unit: systemd user service manager')

prepare() {
  # Copy local files to srcdir (only if not already there)
  if [ "$BUILDDIR" != "$srcdir" ]; then
    # Copy the actual directories from aura-cli
    cp -r "$BUILDDIR/bin" "$srcdir/" 2>/dev/null || true
    cp -r "$BUILDDIR/completions" "$srcdir/" 2>/dev/null || true

    # Copy top-level files
    for f in .envrc LICENSE README.md pyproject.toml default.nix flake.nix .gitignore; do
      if [ -f "$BUILDDIR/$f" ]; then
        cp "$BUILDDIR/$f" "$srcdir/" 2>/dev/null || true
      fi
    done
  fi
}

package() {
  # Create target directory under /opt
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

  # Create symlink for main executable if present
  if [ -f "$pkgdir/opt/$pkgname/bin/aura" ]; then
    mkdir -p "$pkgdir/usr/bin"
    ln -sf "/opt/$pkgname/bin/aura" "$pkgdir/usr/bin/aura"
  fi

  # Set proper permissions for executables in bin/
  if [ -d "$pkgdir/opt/$pkgname/bin" ]; then
    find "$pkgdir/opt/$pkgname/bin" -type f -exec chmod 755 {} +
  fi
}
