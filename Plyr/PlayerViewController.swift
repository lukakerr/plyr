//
//  PlayerViewController.swift
//  Plyr
//
//  Created by Luka Kerr on 28/2/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

class PlayerViewController: NSViewController {

  private var player = Player()
  private var searching: Bool = false
  private var searchWindowController: OpenQuicklyWindowController!
  
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

    DispatchQueue.global(qos: .userInitiated).async {
      self.player.initialize()

      DispatchQueue.main.async {
        self.player.playAll()
      }
    }
  }

  override func viewDidLoad() {
    let openQuicklyOptions = OpenQuicklyOptions()
    openQuicklyOptions.width = 400
    openQuicklyOptions.rowHeight = 50
    openQuicklyOptions.delegate = self
    openQuicklyOptions.persistPosition = true
    openQuicklyOptions.placeholder = "Search for a song"

    self.searchWindowController = OpenQuicklyWindowController(options: openQuicklyOptions)

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.setSongDetails),
      name: NSNotification.Name(rawValue: "setSongDetails"),
      object: nil
    )
  }

  func keyDown(with event: NSEvent) -> Bool {
    let modifierFlags = event.modifierFlags.intersection(.deviceIndependentFlagsMask)

    // Command + 'o'
    if modifierFlags == [.command] && event.keyCode == KeyCode.o {
      searching.toggle()
      searchWindowController.toggle()
      return true
    }

    // If searching, don't listen to any other keys
    if searching {
      return false
    }

    switch event.keyCode {
    case KeyCode.space:
      onMainControlClick(nil)
      return true

    case KeyCode.n:
      nextButtonClicked(nil)
      return true

    case KeyCode.p:
      previousButtonClicked(nil)
      return true

    case KeyCode.s:
      skipButtonClicked(nil)
      return true

    case KeyCode.r:
      rewindButtonClicked(nil)
      return true

    default:
      return false
    }
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

extension PlayerViewController: OpenQuicklyDelegate {

  func openQuickly(item: Any) -> NSView? {
    guard
      let song = item as? Song,
      let artist = song.artist,
      let name = song.name
    else { return nil }

    let view = NSStackView()
    view.edgeInsets = NSEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)

    let title = NSTextField()

    title.isEditable = false
    title.isBezeled = false
    title.isSelectable = false
    title.focusRingType = .none
    title.drawsBackground = false
    title.font = NSFont.systemFont(ofSize: 14)
    title.stringValue = name

    let subtitle = NSTextField()

    subtitle.isEditable = false
    subtitle.isBezeled = false
    subtitle.isSelectable = false
    subtitle.focusRingType = .none
    subtitle.drawsBackground = false
    subtitle.stringValue = artist
    subtitle.font = NSFont.systemFont(ofSize: 12)

    let text = NSStackView()
    text.orientation = .vertical
    text.spacing = 2.0
    text.alignment = .left

    text.addArrangedSubview(title)
    text.addArrangedSubview(subtitle)

    if let artwork = song.artwork {
      view.addArrangedSubview(NSImageView(image: artwork))
    }

    view.addArrangedSubview(text)

    return view
  }

  func valueWasEntered(_ value: String) -> [Any] {
    return player.song(for: value)
  }

  func itemWasSelected(selected item: Any) {
    searching = false

    guard let song = item as? Song else { return }

    player.play(song)
  }

  func windowDidClose() {
    searching = false
  }

}
