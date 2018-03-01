//
//  AppDelegate.swift
//  plyr
//
//  Created by Luka Kerr on 28/2/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    if let window = NSApplication.shared.windows.first {
      window.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
      
      // Title bar properties
      window.titleVisibility = NSWindow.TitleVisibility.hidden
      window.titlebarAppearsTransparent = true
      window.styleMask.insert(.fullSizeContentView)
      window.isOpaque = false
    }
  }

  
  func applicationWillTerminate(_ aNotification: Notification) {
    
  }
  
}
