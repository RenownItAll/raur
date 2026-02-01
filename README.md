# raur

👋 welcome!

this is my personal binary repo for Arch Linux. it contains
pre-built versions of the stuff I use daily.

## installation

to add this repo to your system, append the following block to your
`/etc/pacman.conf`:

```ini
[raur]
SigLevel = Optional TrustAll
Server = [https://raw.githubusercontent.com/YOUR_USERNAME/raur/main/x86_64](https://raw.githubusercontent.com/YOUR_USERNAME/raur/main/x86_64)
```
