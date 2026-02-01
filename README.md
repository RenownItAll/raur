# raur

👋 welcome!

this is my personal repo for Arch Linux packages. it contains pre-compiled
binaries of the stuff I use daily.

## installation

to add this repo to your system, append the following block to your
`/etc/pacman.conf`:

> [!IMPORTANT]  
> these were built on my machine(s). while I use them every day,
> proceed with the usual caution when adding third-party repos to your
> `pacman.conf`.

```ini
[raur]
SigLevel = Optional TrustAll
Server = [https://raw.githubusercontent.com/RenownItAll/raur/main/x86_64](https://raw.githubusercontent.com/RenownItAll/raur/main/x86_64)
```
