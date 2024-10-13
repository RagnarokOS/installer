# Ragnarok Installer - TUI Version

The TUI version of Ragnarok's installer, using whiptail.

## Differences

This version differs, functionality-wise, from the plain text version
in a few ways:

* Instead of fetching the base tarball, it creates the system from
  scratch using mmdebstrap, with the same method used to create the
  release tarballs.

* Because it doesn't need to handle automatic installs, `install.conf`
  is not used. It works similarly to Debian's netinstall in that it
  asks for a config value, then applies it.

