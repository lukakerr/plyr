//
//  Extensions.swift
//  Plyr
//
//  Created by Luka Kerr on 1/3/18.
//  Copyright © 2018 Luka Kerr. All rights reserved.
//

import Cocoa
import Foundation

extension FileManager {
  internal func filteredMusicFileURLs(inDirectory directory: String) -> [Song] {
    guard let enumerator = enumerator(
      at: URL(fileURLWithPath: directory),
      includingPropertiesForKeys: nil,
      options: [],
      errorHandler: nil
    ) else {
      return []
    }

    var songs = [Song]()

    let enumeration: () -> Bool = {
      guard let fileURL = enumerator.nextObject() as? URL else {
        return false
      }

      if fileURL.isMusicFile {
        let song = Song(url: fileURL)
        songs.append(song)
      }

      return true
    }
    while enumeration() {}

    return songs
  }
}

extension URL {
  private enum MusicFileExtension: String {
    case mp3
    case m4a
    case m4p
    case aiff
  }

  internal var isMusicFile: Bool {
    return MusicFileExtension(rawValue: pathExtension) != nil
  }
}

extension NSImage {

  public func setSize() {
    self.size = NSSize(width: 36, height: 36)
  }

}
