//
//  Player.swift
//  Plyr
//
//  Created by Luka Kerr on 1/3/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Foundation
import AVFoundation

final class Player: NSObject, AVAudioPlayerDelegate, NSUserNotificationCenterDelegate {

  static let shared = Player()
  
  /// Main audio player
  private var audioPlayer: AVAudioPlayer!
  
  /// Currently playing song
  private var currentSong: URL!
  
  /// Currently playing song index
  private var currentSongIndex: Int!
  
  /// All songs
  private var allSongs: [URL]!

  /// Whether the player is currently playing or paused
  public var playing: Bool {
    return self.audioPlayer.isPlaying
  }
  
  private override init() {
    super.init()

    allSongs = getAllSongs()
    currentSongIndex = preferences.currentSongIndex
    NSUserNotificationCenter.default.delegate = self
  }

  /// Plays all songs one by one
  public func playAll() {
    if allSongs.count > currentSongIndex {
      currentSong = allSongs[currentSongIndex]
      play(currentSong)
    } else {
      let notification = NSUserNotification()
      notification.title = "No music found"
      notification.informativeText = "No music could be found. Exiting"
      notification.soundName = NSUserNotificationDefaultSoundName
      NSUserNotificationCenter.default.deliver(notification)
      exit(0)
    }
  }

  // MARK: - Public methods to control the player

  public func pause() {
    audioPlayer.pause()
  }
  
  public func resume() {
    audioPlayer.prepareToPlay()
    audioPlayer.play()
  }
  
  public func skip() {
    audioPlayer.currentTime += 10.0
  }
  
  public func rewind() {
    audioPlayer.currentTime -= 10.0
  }
  
  public func next() {
    let newIndex = (currentSongIndex + 1) % allSongs.count

    currentSongIndex = newIndex
    preferences.currentSongIndex = newIndex

    playAll()
  }
  
  public func previous() {
    let newIndex = currentSongIndex <= 0 ? 0 : currentSongIndex - 1

    currentSongIndex = newIndex
    preferences.currentSongIndex = newIndex

    playAll()
  }
  
  public func play(_ song: URL) {
    audioPlayer = try? AVAudioPlayer(contentsOf: song)
    audioPlayer.numberOfLoops = 0
    audioPlayer.delegate = self
    audioPlayer.prepareToPlay()
    audioPlayer.play()
    
    NotificationCenter.default.post(
      name: NSNotification.Name(rawValue: "setSongDetails"),
      object: currentSong
    )
  }

  // MARK: - Private methods

  // Returns an array of URLs found under ~/Music
  private func getAllSongs() -> [URL] {
    let path = "\(FileManager.default.homeDirectoryForCurrentUser.path)/Music"
    let songs = FileManager.default.filteredMusicFileURLs(inDirectory: path)
    return songs
  }

  // MARK: - AVAudioPlayerDelegate methods

  // Called when a song playing the player ends
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    next()
  }

}

let player = Player.shared
