# Plyr

[![Swift 5](https://img.shields.io/badge/swift-5-orange.svg?style=flat)](https://github.com/apple/swift)
[![Platform](http://img.shields.io/badge/platform-macOS-red.svg?style=flat)](https://developer.apple.com/macos/)
[![Github](http://img.shields.io/badge/github-lukakerr-green.svg?style=flat)](https://github.com/lukakerr)
![Github All Releases](https://img.shields.io/github/downloads/lukakerr/plyr/total.svg)

<p align="center">
  <img src="./Plyr/Assets.xcassets/AppIcon.appiconset/mac_appicon-512@1x.png" width="150">
</p>

Plyr is a hyperminimal, lightweight macOS music playback desktop application.

Audio files are looked for in the `~/Music` directory. If none are found, the app will notify you and terminate.

### Installing

#### Install via Homebrew Cask

```bash
$ brew tap lukakerr/things
$ brew cask install plyr
```

#### Manual Download

Visit the [releases page](https://github.com/lukakerr/plyr/releases) to download manually.

### Uninstalling

#### Download via Homebrew Cask

```bash
$ brew cask remove pine
```

#### Downloaded Manually

```bash
$ rm -r /Applications/Plyr.app ~/Library/Caches/io.github.lukakerr.plyr
```

### Features

- Pause or play
- Skip or rewind 10 seconds
- Skip to next or previous song
- Minimal UI

### Todo

- Add UI preferences
  - [ ] Window border radius
  - [ ] Show or hide traffic lights
  - [ ] Light or dark overlay

- Add functionality preferences
  - [ ] Duration to skip or rewind

- Add functionality
  - [x] Show quick open panel to search for and play songs
  - [x] Add keybindings for play, pause, skip, rewind, next and previous buttons

### Screenshots

<p align="center">
  <img src="https://i.imgur.com/BK2Ez7a.png" width="250">
  <img src="https://i.imgur.com/spTAg94.png" width="250">
  <img src="https://i.imgur.com/XACDb9A.png" width="250">
</p>
