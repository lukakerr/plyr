//
//  Extensions.swift
//  plyr
//
//  Created by Luka Kerr on 1/3/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Foundation

extension FileManager {
  internal func filteredMusicFileURLs(inDirectory directory: String) -> [URL] {
    guard let enumerator = enumerator(at: URL(fileURLWithPath: directory), includingPropertiesForKeys: nil, options: [], errorHandler: nil) else {
      return []
    }
    
    var musicFiles = [URL]()
    let enumeration: () -> Bool = {
      guard let fileURL = enumerator.nextObject() as? URL else {
        return false
      }
      if fileURL.isMusicFile {
        musicFiles.append(fileURL)
      }
      return true
    }
    while enumeration() {}
    return musicFiles
  }
}

extension URL {
  private enum MusicFileExtension: String {
    case mp3 = "mp3"
    case m4a = "m4a"
    case m4p = "m4p"
  }
  
  internal var isMusicFile: Bool {
    return MusicFileExtension(rawValue: pathExtension) != nil
  }
}
