//
//  PlayerViewController.swift
//  Plyr
//
//  Created by Luka Kerr on 28/2/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa
import AVFoundation

class PlayerViewController: NSViewController {
  
  @IBOutlet weak var backgroundView: NSView!
  @IBOutlet weak var transparentView: NSVisualEffectView!
  @IBOutlet weak var mainControlButton: NSButton!
  @IBOutlet weak var artistName: NSTextField!
  @IBOutlet weak var songName: NSTextField!

  override func viewWillAppear() {
    super.viewWillAppear()
  
    self.view.wantsLayer = true
    self.view.layer?.cornerRadius = 10.0
    
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
  }

  func keyDown(with event: NSEvent) -> Bool {
    switch event.keyCode {
    case 49: // Spacebar
      self.onMainControlClick(nil)
      return true

    case 45: // 'n'
      self.nextButtonClicked(nil)
      return true

    case 35: // 'p'
      self.previousButtonClicked(nil)
      return true

    case 1: // 's'
      self.skipButtonClicked(nil)
      return true

    case 15: // 'r'
      self.rewindButtonClicked(nil)
      return true

    default:
      return false
    }
  }
  
  // Set song details from given audio path
  @objc func setSongDetails(notification: Notification?) {
    guard let assetPath = notification?.object as? URL else { return }
    let asset = AVURLAsset(url: assetPath, options: nil)

    for item in asset.commonMetadata {
      guard let key = item.commonKey else { continue }

      switch key {
      case .commonKeyArtwork:
        guard
          let imageData = item.value as? Data,
          let image = NSImage(data: imageData)
          else { return }
        self.view.layer?.contents = image
      case .commonKeyArtist:
        guard let artist = item.value as? String else { continue }
        artistName.stringValue = artist
      case .commonKeyTitle:
        guard let title = item.value as? String else { continue }
        songName.stringValue = title
      default:
        continue
      }
    }
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
    self.setButtons()
  }

  @IBAction func skipButtonClicked(_ sender: Any?) {
    player.skip()
    self.setButtons()
  }
  
  @IBAction func rewindButtonClicked(_ sender: Any?) {
    player.rewind()
    self.setButtons()
  }
  
  @IBAction func nextButtonClicked(_ sender: Any?) {
    player.next()
    self.setButtons()
  }
  
  @IBAction func previousButtonClicked(_ sender: Any?) {
    player.previous()
    self.setButtons()
  }

}
