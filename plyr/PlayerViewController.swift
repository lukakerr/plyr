//
//  PlayerViewController.swift
//  plyr
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
  
  // Player class
  let player = Player()
  
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
    
    player.playAll()
  }
  
  override func viewDidLoad() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.setSongDetails(notification:)),
      name: NSNotification.Name(rawValue: "setSongDetails"),
      object: nil
    )
  }
  
  // Set song details from given audio path
  @objc func setSongDetails(notification: Notification?) {
    if let assetPath = notification?.object as? URL {
      let asset = AVURLAsset(url: assetPath, options: nil)
      
      for item in asset.commonMetadata {
        if let key = item.commonKey {
          if key.rawValue == "artwork" {
            if let imageData = item.value as? NSData,
              let image = NSImage(data: imageData as Data) {
              self.view.layer?.contents = image
            }
          } else if key.rawValue == "artist" {
            if let artist = item.value as? String {
              artistName.stringValue = artist
            }
          } else if key.rawValue == "title" {
            if let title = item.value as? String {
              songName.stringValue = title
            }
          }
        }
      }
    }
  }
  
  func setButtons() {
    if (player.audioPlayer?.isPlaying)! {
      mainControlButton.image = NSImage(named: NSImage.Name(rawValue: "NSTouchBarPauseTemplate"))
    } else {
      mainControlButton.image = NSImage(named: NSImage.Name(rawValue: "NSTouchBarPlayTemplate"))
    }
  }
  
  @IBAction func onMainControlClick(_ sender: Any) {
    if (player.audioPlayer?.isPlaying)! {
      player.pause()
    } else {
      player.resume()
    }
    self.setButtons()
  }

  @IBAction func skipButtonClicked(_ sender: Any) {
    player.skip()
    self.setButtons()
  }
  
  @IBAction func rewindButtonClicked(_ sender: Any) {
    player.rewind()
    self.setButtons()
  }
  
  @IBAction func nextButtonClicked(_ sender: Any) {
    player.next()
    self.setButtons()
  }
  
  @IBAction func previousButtonClicked(_ sender: Any) {
    player.previous()
    self.setButtons()
  }

}
