//
//  SearchViewController.swift
//  Plyr
//
//  Created by Luka Kerr on 24/2/19.
//  Copyright © 2019 Luka Kerr. All rights reserved.
//

import Cocoa

let WIDTH = 300
let HEIGHT = 44

let ROW_HEIGHT = 20
let MAX_MATCHES_SHOWN = 6

class SearchViewController: NSViewController, NSTextFieldDelegate {

  private var windowYPos: CGFloat?

  private var songs: [Song]!
  private var matches: [Song]!
  private var clipView: NSClipView!
  private var stackView: NSStackView!
  private var scrollView: NSScrollView!
  private var searchField: NSTextField!
  private var matchesList: NSOutlineView!
  private var transparentView: NSVisualEffectView!

  private var searchWindowController: SearchWindowController? {
    return view.window?.windowController as? SearchWindowController
  }

  override func loadView() {
    let frame = NSRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)

    view = NSView(frame: frame)
    view.wantsLayer = true
    view.layer?.cornerRadius = 10.0
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    matches = []
    songs = player.songs

    setupSearchField()
    setupTransparentView()
    setupMatchesListView()
    setupScrollView()
    setupStackView()

    stackView.addArrangedSubview(searchField)
    stackView.addArrangedSubview(scrollView)
    transparentView.addSubview(stackView)
    view.addSubview(transparentView)

    setupConstraints()

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(windowChangedNotification),
      name: NSWindow.didMoveNotification,
      object: nil
    )
  }

  override func viewWillAppear() {
    searchField.stringValue = ""
    matches = []
    view.window?.makeFirstResponder(searchField)
  }

  override func viewDidAppear() {
    windowYPos = view.window?.frame.origin.y
  }

  override var acceptsFirstResponder: Bool {
    return true
  }

  override func keyUp(with event: NSEvent) {
    matches = []

    let value = searchField.stringValue

    if value.count > 1 {
      songs.forEach {
        if let path = $0.url.lastPathComponent.removingPercentEncoding {
          let pathLower = path.lowercased()
          let valueLower = value.lowercased()

          if pathLower.contains(valueLower) {
            matches.append($0)
          }
        }
      }
    }

    matchesList.reloadData()
    updateViewSize()
  }

  private func updateViewSize() {
    let numMatches = matches.count > MAX_MATCHES_SHOWN
      ? MAX_MATCHES_SHOWN
      : matches.count

    let rowHeight = numMatches * ROW_HEIGHT
    let newHeight = HEIGHT + rowHeight

    let newSize = NSSize(width: WIDTH, height: newHeight)

    guard
      let y = windowYPos,
      var frame = view.window?.frame
    else { return }

    frame.size.height = CGFloat(newHeight)

    if newHeight == HEIGHT {
      frame.origin.y = y
    } else {
      frame.origin.y = y - CGFloat(rowHeight)
    }

    view.setFrameSize(newSize)
    transparentView.setFrameSize(newSize)
    view.window?.setFrame(frame, display: true)
    stackView.spacing = matches.count > 0 ? 5.0 : 0.0
  }

  @objc func windowChangedNotification(_ notification: Notification) {
    windowYPos = view.window?.frame.origin.y
  }

  // MARK: - UI setup

  private func setupSearchField() {
    searchField = NSTextField()
    searchField.delegate = self
    searchField.alignment = .left
    searchField.isEditable = true
    searchField.isBezeled = false
    searchField.isSelectable = true
    searchField.focusRingType = .none
    searchField.drawsBackground = false
    searchField.placeholderString = "Search"
    searchField.font = NSFont.systemFont(ofSize: 20, weight: .light)
  }

  private func setupTransparentView() {
    let frame = NSRect(x: 0, y: 0, width: WIDTH, height: HEIGHT)

    transparentView = NSVisualEffectView(frame: frame)
    transparentView.state = .active
    transparentView.material = .light
    transparentView.wantsLayer = true
    transparentView.layer?.cornerRadius = 7.0
    transparentView.blendingMode = .behindWindow
  }

  private func setupMatchesListView() {
    matchesList = NSOutlineView()
    matchesList.delegate = self
    matchesList.headerView = nil
    matchesList.wantsLayer = true
    matchesList.dataSource = self
    matchesList.selectionHighlightStyle = .sourceList

    let column = NSTableColumn()
    matchesList.addTableColumn(column)
  }

  private func setupScrollView() {
    scrollView = NSScrollView()
    scrollView.borderType = .noBorder
    scrollView.drawsBackground = false
    scrollView.autohidesScrollers = true
    scrollView.hasVerticalScroller = true
    scrollView.documentView = matchesList
    scrollView.translatesAutoresizingMaskIntoConstraints = true
  }

  private func setupStackView() {
    stackView = NSStackView()
    stackView.spacing = 0.0
    stackView.orientation = .vertical
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.edgeInsets = NSEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
  }

  private func setupConstraints() {
    let stackViewConstraints = [
      stackView.topAnchor.constraint(equalTo: transparentView.topAnchor),
      stackView.bottomAnchor.constraint(equalTo: transparentView.bottomAnchor),
      stackView.leadingAnchor.constraint(equalTo: transparentView.leadingAnchor),
      stackView.trailingAnchor.constraint(equalTo: transparentView.trailingAnchor)
    ]

    NSLayoutConstraint.activate(stackViewConstraints)
  }

}

extension SearchViewController: NSOutlineViewDataSource {

  // Number of items in the sidebar
  func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
    return matches.count
  }

  // Items to be added to sidebar
  func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
    return matches[index]
  }

  // Whether rows are expandable by an arrow
  func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
    return false
  }

  // Height of each row
  func outlineView(_ outlineView: NSOutlineView, heightOfRowByItem item: Any) -> CGFloat {
    return CGFloat(ROW_HEIGHT)
  }

  // When a row is clicked on should it be selected
  func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
    return true
  }

  // When a row is selected
  func outlineViewSelectionDidChange(_ notification: Notification) {
    guard
      let selected = matchesList.item(atRow: matchesList.selectedRow) as? Song
    else { return }

    player.play(selected)
    searchWindowController?.toggle()
  }

}

extension SearchViewController: NSOutlineViewDelegate {

  func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
    guard let song = item as? Song else { return nil }

    var view = outlineView.makeView(
      withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SongCell"),
      owner: self
    ) as? NSTextField

    if view == nil {
      view = NSTextField()
      view?.identifier = NSUserInterfaceItemIdentifier(rawValue: "SongCell")
    }

    song.setMetadata()

    guard let name = song.name else { return nil }

    view?.isEditable = false
    view?.isBezeled = false
    view?.isSelectable = false
    view?.focusRingType = .none
    view?.drawsBackground = false
    view?.stringValue = name

    return view
  }

}

