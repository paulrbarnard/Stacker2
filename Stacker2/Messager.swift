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
let messageCountNotificationID = "com.toxic.messageCountNotificationID"

class Messager {
    
	@ObservedObject var sharedAttributes: SharedAttributes
	
    var keyStrokePeriod = 2.0
    var sending = false
    
    var messageQueue: [String] = []
    var async = true
    var silent = true
    
    @State var timer = Timer()
    
	init(sharedAttributes: SharedAttributes = SharedAttributes()) {
		self.sharedAttributes = sharedAttributes
	}
	
    func sendKeyPress (_ string: String, to: String = "System Events") -> Bool{
        var strings = [String]()
        var str = string
        var returnValue = false
		while str.count > sharedAttributes.keyLen {
            // split in to keyLen character chunks
			strings.append(String(str.prefix(sharedAttributes.keyLen)))
			str = String(str.dropFirst(sharedAttributes.keyLen))
        }
            strings.append(str)
        for value in strings {
            returnValue = runAppleScript(string: "tell application \"\(to)\" to keystroke \"\(value)\"")
        }
        return returnValue
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
            //printMessage("Buffered message \"\(string)\"")
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
            _ = activateStacker()
            _ = activateRemote()
            sendTheMessage(nextString)
            getKeys(nextString)
        } else if self.sending == true{
            printMessage("Buffer now empty")
            timer.invalidate()
            self.sending = false
            NotificationCenter.default.post(name: Notification.Name(rawValue: messageCompleteNotificationID), object: self)
            
        }
    }
    
    private func printMessage(_ string:String){
        if !silent {
            print(string)
        }
    }
    
    private func getKeys(_ str:String){
        if let range: Range<String.Index> = str.range(of: "keystroke") {
            let index: Int = str.distance(from: str.startIndex, to: range.upperBound)
            let keyString = String(str.dropFirst(index))
            let qCount = keyString.filter {$0 == "q"}.count
            let wCount = keyString.filter {$0 == "w"}.count
            let eCount = keyString.filter {$0 == "e"}.count
            let rCount = keyString.filter {$0 == "r"}.count
            let tCount = keyString.filter {$0 == "t"}.count
            let yCount = keyString.filter {$0 == "y"}.count
			let count = ((qCount * sharedAttributes.qSize) + (wCount * sharedAttributes.wSize) + (eCount * sharedAttributes.eSize) + (rCount * sharedAttributes.rSize) + (tCount * sharedAttributes.tSize) + (yCount * sharedAttributes.ySize))
			//print ("keyString:",keyString,"Count:",count)
           let countDict:[String: Int] = ["count": count]
            NotificationCenter.default.post(name: Notification.Name(rawValue: messageCountNotificationID), object: self, userInfo: countDict)
        }
    }
    
    
}



