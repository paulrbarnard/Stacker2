//
//  AppDelegate.swift
//  Stacker2
//
//  Created by Paul Barnard on 29/06/2020.
//  Copyright © 2020 Paul Barnard. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var window: NSWindow!
	@ObservedObject var sharedAttributes = SharedAttributes()
	var preferencesWindow: NSWindow!    // << here

	@objc func openPreferencesWindow() {
		if nil == preferencesWindow {      // create once !!
			let preferencesView = PreferencesView(sharedAttributes: sharedAttributes)
			// Create the preferences window and set content
			preferencesWindow = NSWindow(
				contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
				styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
				backing: .buffered,
				defer: false)
			preferencesWindow.center()
			preferencesWindow.setFrameAutosaveName("Preferences")
			preferencesWindow.isReleasedWhenClosed = false
			preferencesWindow.contentView = NSHostingView(rootView: preferencesView)
		}
		preferencesWindow.makeKeyAndOrderFront(nil)
	}

    func applicationDidFinishLaunching(_ aNotification: Notification) {
		let messager = Messager(sharedAttributes: sharedAttributes)
        // Create the SwiftUI view that provides the window contents.
		let contentView = ContentView(sharedAttributes: sharedAttributes, messager: messager)
        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 150, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
        var activity: NSObjectProtocol?
        activity = ProcessInfo.processInfo.beginActivity(options: .userInitiatedAllowingIdleSystemSleep, reason: "Timer delay")
   }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    
}

