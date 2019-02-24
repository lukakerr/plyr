//
//  WindowController.swift
//  Plyr
//
//  Created by Luka Kerr on 28/2/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {

  override func windowDidLoad() {
    super.windowDidLoad()

    window?.titleVisibility = .hidden
    window?.styleMask = .borderless
    window?.backgroundColor = .clear
    window?.isOpaque = false
    window?.isMovableByWindowBackground = true
  }

}
