# Artimux
A clean dark transparent theme for tmux which respects your default terminal background, fork of [janoamaral/tokyo-night-tmux](https://github.com/janoamaral/tokyo-night-tmux). I just added some widgets and YouTube
Music integration.

## Installation

#### Using TPM (Tmux Plugin Manager):
Add the plugin to the list of TPM plugins in `.tmux.conf`:

```bash
set -g @plugin 'tribhuwan-kumar/artimux'
```
## TYM (Tmux YouTube Music)
A simple shell application for streaming YouTube Music in the terminal.

### Configuration of TYM:
### Depndencies:
- [`jq`](https://jqlang.github.io/jq/download/)
- [`mpv`](https://mpv.io/installation/)
- [`yt-dlp`](https://github.com/yt-dlp/yt-dlp/wiki/Installation)
- [`openbsd-netcat`](https://ftp.netbsd.org/pub/pkgsrc/current/pkgsrc/net/netcat-openbsd/index.html)
- [`atomicparsley`](https://github.com/wez/atomicparsley#install)

For Arch Linux:
```bash
pacman -S jq mpv yt-dlp openbsd-netcat atomicparsley
```
### Config:
Create a symbolic of `tym.sh` in your `$PATH` and make it executable.
```bash
sudo ln -s ~/.tmux/plugins/Artimux/src/tym.sh /usr/local/bin/tym
```

### Usage:
Just run `tym` along with the song name you want to play, It will search for that song in `~/Music/tym` directory, If the song is not found, then
it will search on YouTube and play it.
#### Flags:
- `-h | --help` for help.
- `-r | --repeat` for play the song in repeat mode.
- `-s | --shuffle` for shuffle all songs from directory.

#### Keybindings:
It uses the default keybindings of `mpv`, but you can customize it too
- `q` for quit.
- `m` for mute.
- `p` & `Space` for play/pause.
- `` & `` for seek backward and forward.
- `<` & `>` for playing next and previous song in shuffle mode.

## Widgets:
### Netspeed
```bash
set -g @Artimux_show_netspeed "true"
set -g @Artimux_netspeed_iface "wlan0" # your network interface, find with ip link
```

### Time
```bash
set -g @Artimux_show_time "true"
set -g @Artimux_time_format "12HR" # 12HR or 24HR
```

### Battery
```bash
set -g @Artimux_show_battery "true"
```
set variables values `"false"` to disable the widget, Remember to restart the tmux after changing values.
<br>
For status bar numbers customization [see](https://github.com/janoamaral/tokyo-night-tmux#the-styles)
### CMUS and Now Playing
- Enabled by default, dynamically shows the current playing song in cmus.

### TYM
- Same as CMUS widget, but for TYM.

### Git Branch and Status indicator
- Enabled by default
- Shows the current git branch and status of the repository. so you won't forget to commit, pull or push.

<hr>

###### Now enjoy YouTube Music & your local Music in terminal.

<hr>

#### Snaps:

<img src="https://github.com/tribhuwan-kumar/Artimux/assets/118052427/ec3a6901-232e-442c-81f9-1578bf489179" />

