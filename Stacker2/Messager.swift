//
//  Messager.swift
//  Stacker2
//
//  Created by Paul Barnard on 01/07/2020.
//  Copyright © 2020 Paul Barnard. All rights reserved.
//
// class to send messages to System Events on a background thread.
// sends key presses out on a timer
//

import Foundation
import SwiftUI

let messageStartedNotificationID = "com.toxic.messageStartedNotificationID"
let messageCompleteNotificationID = "com.toxic.messageCompleteNotificationID"

class Messager {
    
    
    var keyStrokePeriod = 1.0
    var sending = false
    
    var messageQueue: [String] = []
    var async = true
    var silent = false
    
    @State var timer = Timer()
    
    
     

    func sendKeyPress (_ string: String, to: String = "System Events") -> Bool{
        return runAppleScript(string: "tell application \"\(to)\" to keystroke \"\(string)\"")
    }


    
    func runAppleScript (string script: String)-> Bool {
        actionAppleScript(string: script)
        return true
    }
     
    
    func activateRemote() -> Bool{
        sendTheMessage("activate application \"Remote\"")
        return true
    }
    
    func activateStacker() -> Bool{
        sendTheMessage("activate application \"Stacker2\"")
        return true
    }

    private func actionAppleScript (string: String){
        if async == true {
            // asyncronus mode so buffer the message
            messageQueue.append(string)  // add the message to the queue
            printMessage("Buffered message \"\(string)\"")
            if sending == false {
                // not currently sending and asyncronous mode so start the send timer
                NotificationCenter.default.post(name: Notification.Name(rawValue: messageStartedNotificationID), object: self)
                printMessage("Starting the timer")
                timer.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: keyStrokePeriod, repeats: true){ (_) in
                    self.processTimer()
                }
                sending = true
            }
        } else {
            sendTheMessage(string)
        }
    }
    
    private func sendTheMessage(_ string:String){
        if let scriptObject = NSAppleScript(source: string) {
            var error: NSDictionary?
            let _: NSAppleEventDescriptor = scriptObject.executeAndReturnError(&error)
            if (error == nil) {
                printMessage("Sent message \"\(string)")
            } else {
                printMessage("Failed message \"\(string)\" error \(String(describing: error!))")
            }
        }

    }
    
    private func processTimer() {
        // send the message
        if self.messageQueue.count > 0 {
            // there are messages in the queue
            let nextString = self.messageQueue.remove(at: 0)
            _ = activateRemote()
            sendTheMessage(nextString)
            _ = activateStacker()
        } else if self.sending == true{
            printMessage("Buffer now empty")
            self.sending = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: messageCompleteNotificationID), object: self)        }
    }
    
    private func printMessage(_ string:String){
        if !silent {
            print(string)
        }
    }
    
    
    
    
}
