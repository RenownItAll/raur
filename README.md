# raur

👋 welcome!

this repo is my personal collection of modified [AUR](https://aur.archlinux.org/)
packages. I edit the PKGBUILDs to my liking and pre-compile the binaries so I
don't have to sit around waiting on the AUR each time new updates are released.

## installation

to add this repo to your system, append the following block to your
`/etc/pacman.conf`:

> [!IMPORTANT]  
> these packages were built on my machine(s). while I use them every day,
> proceed with the usual caution when adding third-party repos to your
> `pacman.conf`.

```ini
[raur]
SigLevel = Optional TrustAll
Server = https://raw.githubusercontent.com/RenownItAll/raur/main/x86_64
```
