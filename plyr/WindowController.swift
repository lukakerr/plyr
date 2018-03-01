//
//  WindowController.swift
//  plyr
//
//  Created by Luka Kerr on 28/2/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

class WindowController: NSWindowController {
  
  override func windowDidLoad() {
    super.windowDidLoad()
    
    if let window = window {
      window.titleVisibility = NSWindow.TitleVisibility.hidden
      window.styleMask.insert(.fullSizeContentView)
      window.styleMask = .borderless
      window.backgroundColor = .clear
      window.isOpaque = false
      window.isMovableByWindowBackground = true
    }
    
  }

}
