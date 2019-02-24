//
//  SearchWindowController.swift
//  Plyr
//
//  Created by Luka Kerr on 24/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

let SEARCH_AUTOSAVE_NAME = "PlyrSearchWindow"

class SearchWindowController: NSWindowController {

  convenience init() {
    let svc = SearchViewController()
    let window = SearchWindow(contentViewController: svc)

    self.init(window: window)

    window.titleVisibility = .hidden
    window.styleMask = .borderless
    window.backgroundColor = .clear
    window.isOpaque = false
    window.isMovableByWindowBackground = true
    window.setFrameAutosaveName(SEARCH_AUTOSAVE_NAME)
  }

  override func windowDidLoad() {
    super.windowDidLoad()
  }

  public func toggle() {
    guard let visible = window?.isVisible else { return }

    if visible {
      close()
    } else {
      window?.makeKeyAndOrderFront(self)
      showWindow(self)
    }

    NotificationCenter.default.post(
      name: NSNotification.Name(rawValue: "searchWindowToggled"),
      object: !visible
    )
  }

}
