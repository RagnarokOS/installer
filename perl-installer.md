# installer.pl

This is an experimental version written in perl. Not because there's
anything wrong with a simple shell script, but because I'm learning
Perl for the fun of it.

I have no idea if the perl version will ever become the official one,
but from a pragmatic point of view, there are a few benefits to it:

* The Config::General module offers a sane and secure way to parse
config files.

* The installer uses mmdebstrap, also written in Perl, which means that
at some point it might be worth it to port the needed mmdebstrap functionalities
to the installer itself, eliminating the need to use an external program.
That said, it might be smarter to modify mmdebstrap to turn it into a perl
module instead.

* Not to be overlooked: a perl version would be more portable across Debian
based distributions. Ragnarok's default interactive shell is OpenBSD's ksh,
and shell scripts (such as the installer) that require options not supported
by POSIX sh will use ksh. This means that installing Ragnarok from another
distro requires the installation of another shell.

On the other hand, perl is available on any Debian-based systems and the
only extra dependency would be the Config::General module.
