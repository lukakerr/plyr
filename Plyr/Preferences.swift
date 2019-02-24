//
//  Preferences.swift
//  plyr
//
//  Created by Luka Kerr on 24/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

enum PreferencesKeys {
  static let currentSongIndex = "currentSongIndex"
}

class Preferences {
  static let shared = Preferences()

  private init() {}

  public var currentSongIndex: Int {
    get {
      if exists(PreferencesKeys.currentSongIndex) {
        return defaults.integer(forKey: PreferencesKeys.currentSongIndex)
      }

      return 0
    }

    set {
      setDefaults(key: PreferencesKeys.currentSongIndex, newValue)
    }
  }

  fileprivate func setDefaults(key: String, _ val: Any) {
    defaults.setValue(val, forKey: key)
  }

  fileprivate func exists(_ key: String) -> Bool {
    return UserDefaults.standard.object(forKey: key) != nil
  }

}

let preferences = Preferences.shared
