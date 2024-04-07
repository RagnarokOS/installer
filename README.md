Ragnarok-installer
==================

The ragnarok installer infrastructure. WIP.

### installer.pl

This is an experimental version written in perl. Not because there's
anything wrong with a simple shell script, but because I'm learning
Perl for the fun of it.

From a pragmatic point of view, the Config::General module offers a
sane and secure way to parse config files. Plus, the installer uses
mmdebstrap, also written in Perl, which means that at some point it
might be worth it to port the needed mmdebstrap functionalities to
the installer itself, eliminating the need to use an external program.
