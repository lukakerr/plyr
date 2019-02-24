//
//  Song.swift
//  plyr
//
//  Created by Luka Kerr on 24/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Foundation
import Cocoa
import AVFoundation

class Song {

  public var url: URL
  public var name: String?
  public var artist: String?
  public var artwork: NSImage?

  init(url: URL, name: String?, artist: String?, artwork: NSImage?) {
    self.url = url
    self.name = name
    self.artist = artist
    self.artwork = artwork
  }

  convenience init(url: URL) {
    self.init(url: url, name: nil, artist: nil, artwork: nil)
  }

  public func setMetadata() {
    let asset = AVURLAsset(url: url, options: nil)

    for item in asset.commonMetadata {
      guard let key = item.commonKey else { continue }

      switch key {
      case .commonKeyTitle:
        name = item.value as? String

      case .commonKeyArtist:
        artist = item.value as? String

      case .commonKeyArtwork:
        guard let imageData = item.value as? Data else { continue }

        artwork = NSImage(data: imageData)

      default:
        continue
      }
    }
  }

}
