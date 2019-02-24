//
//  PlayerViewController.swift
//  Plyr
//
//  Created by Luka Kerr on 28/2/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

class PlayerViewController: NSViewController {

  private var searching: Bool = false
  private var searchWindowController = SearchWindowController()
  
  @IBOutlet weak var backgroundView: NSView!
  @IBOutlet weak var transparentView: NSVisualEffectView!
  @IBOutlet weak var mainControlButton: NSButton!
  @IBOutlet weak var artistName: NSTextField!
  @IBOutlet weak var songName: NSTextField!

  override func viewWillAppear() {
    super.viewWillAppear()
  
    view.wantsLayer = true
    view.layer?.cornerRadius = 10.0
    
    // NSVisualEffectView properties
    transparentView.blendingMode = .withinWindow
    transparentView.wantsLayer = true
    transparentView.layer?.cornerRadius = 7.0
    transparentView.state = .active
    transparentView.material = .light

    NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
      if self.keyDown(with: event) {
        return nil
      }

      return event
    }
    
    player.playAll()
  }
  
  override func viewDidLoad() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.setSongDetails),
      name: NSNotification.Name(rawValue: "setSongDetails"),
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.updateSearching),
      name: NSNotification.Name(rawValue: "searchWindowToggled"),
      object: nil
    )
  }

  func keyDown(with event: NSEvent) -> Bool {
    let modifierFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

    // Command + 'o'
    if modifierFlags == [.command] && event.keyCode == 31 {
      searching.toggle()
      searchWindowController.toggle()
      return true
    }

    // If searching, don't listen to any other keys
    if searching {
      return false
    }

    switch event.keyCode {
    case 49: // Spacebar
      onMainControlClick(nil)
      return true

    case 45: // 'n'
      nextButtonClicked(nil)
      return true

    case 35: // 'p'
      previousButtonClicked(nil)
      return true

    case 1: // 's'
      skipButtonClicked(nil)
      return true

    case 15: // 'r'
      rewindButtonClicked(nil)
      return true

    default:
      return false
    }
  }

  @objc func updateSearching(notification: Notification?) {
    guard let searchWindowVisible = notification?.object as? Bool else { return }

    searching = searchWindowVisible
  }
  
  // Set song details from given audio path
  @objc func setSongDetails(notification: Notification?) {
    guard
      let song = notification?.object as? Song,
      let artwork = song.artwork,
      let artist = song.artist,
      let name = song.name
    else { return }

    view.layer?.contents = artwork
    artistName.stringValue = artist
    songName.stringValue = name
  }
  
  func setButtons() {
    if player.playing {
      mainControlButton.image = NSImage(named: "NSTouchBarPauseTemplate")
    } else {
      mainControlButton.image = NSImage(named: "NSTouchBarPlayTemplate")
    }
  }

  // MARK: - Methods responding to button clicks

  @IBAction func onMainControlClick(_ sender: Any?) {
    player.playing ? player.pause() : player.resume()
    setButtons()
  }

  @IBAction func skipButtonClicked(_ sender: Any?) {
    player.skip()
    setButtons()
  }
  
  @IBAction func rewindButtonClicked(_ sender: Any?) {
    player.rewind()
    setButtons()
  }
  
  @IBAction func nextButtonClicked(_ sender: Any?) {
    player.next()
    setButtons()
  }
  
  @IBAction func previousButtonClicked(_ sender: Any?) {
    player.previous()
    setButtons()
  }

}
