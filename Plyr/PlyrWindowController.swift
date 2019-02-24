//
//  WindowController.swift
//  Plyr
//
//  Created by Luka Kerr on 28/2/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

let PLYR_AUTOSAVE_NAME = "PlyrWindow"

class PlyrWindowController: NSWindowController {

  override func windowDidLoad() {
    super.windowDidLoad()

    window?.isOpaque = false
    window?.styleMask = .borderless
    window?.backgroundColor = .clear
    window?.titleVisibility = .hidden
    window?.isMovableByWindowBackground = true
    window?.setFrameAutosaveName(PLYR_AUTOSAVE_NAME)
  }

}
