//
//  ContentView.swift
//  Stacker2
//
//  Created by Paul Barnard on 29/06/2020.
//  Copyright © 2020 Paul Barnard. All rights reserved.
//

import SwiftUI

struct ContentView: View {
	
	@ObservedObject var sharedAttributes: SharedAttributes
	
	@State private var images = "10"
	@State private var instructionDelay = "3.0"
	@State private var homeBeforeStep = false
	let stepGranularitys = ["Fine >", "Medium >>", "Course >>>"]
	@State private var stepGranularity = 1
	@State private var stepSize = 5.0
	@State private var count = 0
	
	var helper = Helper()
	@State var messager: Messager
	
	let largestString = "Step Granularity:"
	let largestButton = "Stop"
	@State var hundreds = "888"
	
	@State var useRange = false
	
	let didStart = NotificationCenter.default.publisher(for: NSNotification.Name("com.toxic.messageStartedNotificationID"))
	let didComplete = NotificationCenter.default.publisher(for: NSNotification.Name("com.toxic.messageCompleteNotificationID"))
	let didCount = NotificationCenter.default.publisher(for: NSNotification.Name("com.toxic.messageCountNotificationID"))
	
	@State private var selection: String? = nil
	
	
	var body: some View {
		VStack{
			HStack{
				Spacer()
			Text("Stacker 2")
				Spacer()
				Button(action: {
					NSApp.sendAction(#selector(AppDelegate.openPreferencesWindow), to: nil, from:nil)
				}) {
					Image(systemName: "gear")
				}
			}
			VStack{
					HStack{
						helper.uncompressableText("Images")
						helper.equalSizeUncompressableTextField("Number of images", refText: $hundreds, text: $images).frame(width: 60, height: nil)
						Spacer()
					}
					HStack{
						Toggle(isOn: $homeBeforeStep) {
							helper.uncompressableText("Minimum focus before stack")
						}.disabled(useRange == true)
						Spacer()
					}
					HStack{
						Toggle(isOn: $useRange) {
							helper.uncompressableText("Use Range Settings")
						}
						Spacer()
					}
			}
			
			Section( header: Text("Range Settings")){
				FocusButtonsView(sharedAttributes: sharedAttributes, messager: messager)
					.disabled(useRange == false)
			}
			Section (header: Text("Step Control")){
				HStack {
					Picker(selection: $stepGranularity, label: Text("Step Granularity")) {
						ForEach(0 ..< stepGranularitys.count){
							Text(self.stepGranularitys[$0])
						}
					}
					Spacer()
				}
				HStack {
					Text("Step Size")
					Slider(value: $stepSize, in:1...100, step:1)
					Text("\(stepSize, specifier: "%3.0f")")
				}
			}.disabled(useRange == true)
			// action buttons
			HStack{
				Button(action: {
					// stop taking images
					print("stopped taking images")
					self.stopStack()
				}){
					helper.equalSizeText("Stop", refString: largestButton, alignment: .center)
				}.disabled(sharedAttributes.running == false)
				Spacer()
				Button(action: {
					// start taking images using simple steps
					if useRange == false {
						print("started taking",images, "images using Step Control")
						self.startStack()
					} else {
						// start taking images using Range Control
						print("started taking", images,"images using Range Control")
						self.startRange()
					}
				}){
					helper.equalSizeText("Go", refString: largestButton, alignment: .center)
				}.disabled(sharedAttributes.running == true)
			}
		}.padding()
		
		.onAppear(){
			self.messager = Messager(sharedAttributes: sharedAttributes)
			loadPreferences()
		}.onDisappear(){
			savePreferences()
		}.onReceive(didStart){ (_) in
			sharedAttributes.running = true
		}.onReceive(didComplete){ (_) in
			sharedAttributes.running = false
		}.onReceive(didCount){ (output) in
			let value = output.userInfo?["count"]
			var currentCount:Int = Int(sharedAttributes.currentIndex) ?? 0
			currentCount += value as! Int
			if currentCount < 0 {
				currentCount = 0
			}
			sharedAttributes.currentIndex = String(currentCount)
		}
		
		
	}
	
	
	
	// Stacker functions
	
	func startRange(){
		messager.keyStrokePeriod = Double(instructionDelay) ?? 1.0
		
		let theFarIndex = Int(sharedAttributes.farIndex) ?? 100
		let theNearIndex = Int(sharedAttributes.nearIndex) ?? 0
		let theImages = Int(images) ?? 10
		// move to closest focus
		nearFocus()
		// move to nearIndex
		var theCurrentIndex = 0
		var string = ""
		while ((theCurrentIndex + sharedAttributes.ySize) <= theNearIndex){
			theCurrentIndex += sharedAttributes.ySize
			//_ = messager.sendKeyPress("y")
			string = string + "y"
		}
		if string != "" {
			_ = messager.sendKeyPress(string)
		}
		string = ""
		while ((theCurrentIndex + sharedAttributes.tSize) <= theNearIndex){
			theCurrentIndex += sharedAttributes.tSize
			//_ = messager.sendKeyPress("t")
			string = string + "t"
		}
		if string != "" {
			_ = messager.sendKeyPress(string)
		}
		string = ""
		while ((theCurrentIndex + sharedAttributes.rSize) <= theNearIndex){
			theCurrentIndex += sharedAttributes.rSize
			//_ = messager.sendKeyPress("r")
			string = string + "r"
		}
		if string != "" {
			_ = messager.sendKeyPress(string)
		}
		// take the first image
		fireShutter()
		// step through the images
		count = 1
		
		var theStepSize: Int
		
		
		
		while count < theImages {
			theStepSize = (theFarIndex - theCurrentIndex) / (theImages - count)
			string = ""
			let theCurrentMove = theCurrentIndex + theStepSize
			
			while ((theCurrentIndex + sharedAttributes.ySize) <= theCurrentMove){
				theCurrentIndex += sharedAttributes.ySize
				//_ = messager.sendKeyPress("y")
				string = string + "y"
				
			}
			if string != "" {
				_ = messager.sendKeyPress(string)
			}
			string = ""
			while ((theCurrentIndex + sharedAttributes.tSize) <= theCurrentMove){
				theCurrentIndex += sharedAttributes.tSize
				//_ = messager.sendKeyPress("t")
				string = string + "t"
			}
			if string != "" {
				_ = messager.sendKeyPress(string)
			}
			string = ""
			while ((theCurrentIndex + sharedAttributes.rSize) <= theCurrentMove){
				theCurrentIndex += sharedAttributes.rSize
				//_ = messager.sendKeyPress("r")
				string = string + "r"
			}
			if string != "" {
				_ = messager.sendKeyPress(string)
			}
			fireShutter()
			count += 1
		}
	}
	
	func updateCurrentIndex(step: Int){
		sharedAttributes.currentIndex = String((Int(sharedAttributes.currentIndex) ?? 0 ) + step)
	}
	
	func startStack(){
		messager.keyStrokePeriod = Double(instructionDelay) ?? 1.0
		count = 1
		
		// connected to the Remote app so do the stack
		if homeBeforeStep {
			nearFocus()
		}
		fireShutter()
		while count < Int(images) ?? 0 {
			self.stepFocus()
			fireShutter()
			count += 1
		}
	}
	
	func stopStack(){
		messager.messageQueue.removeAll()
	}
	
	func nearFocus(){
		// use the course focus command to move focal point to minimum focus
		var string = ""
		var loop = 10
		while loop > 0 {
			string += "q"
			loop -= 1
		}
		_ = messager.sendKeyPress(string)
		sharedAttributes.currentIndex = "0"
	}
	
	func stepFocus(){
		// start the focus delay (permits the camera to move the focus)
		var string = ""
		var loop = Int(self.stepSize)
		while loop > 0 {
			switch self.stepGranularity {
			case 0:
				string += "r"
			case 1:
				string += "t"
			default:
				string += "y"
			}
			loop -= 1
		}
		_ = messager.sendKeyPress(string)
		
	}
	
	
	func fireShutter(){
		_ =  messager.sendKeyPress("1")
	}
	
	// Preferences
	
	func loadPreferences(){
		images = UserDefaults.standard.string(forKey: "images") ?? "10"
		instructionDelay = UserDefaults.standard.string(forKey: "instructionDelay") ?? "2"
		var value = UserDefaults.standard.string(forKey: "homeBeforeStep") ?? "true"
		homeBeforeStep = Bool(value)!
		value = UserDefaults.standard.string(forKey: "useRange") ?? "false"
		useRange = Bool(value)!
		value = UserDefaults.standard.string(forKey: "stepGranularity") ?? "1"
		stepGranularity = Int(value)!
		value = UserDefaults.standard.string(forKey: "stepSize") ?? "5"
		stepSize = Double(value)!
		sharedAttributes.nearIndex = UserDefaults.standard.string(forKey: "nearIndex") ?? "0"
		sharedAttributes.farIndex = UserDefaults.standard.string(forKey: "farIndex") ?? "100"
		value = UserDefaults.standard.string(forKey: "qSize") ?? "-300"
		sharedAttributes.qSize = Int(value)!
		value = UserDefaults.standard.string(forKey: "wSize") ?? "-3"
		sharedAttributes.wSize = Int(value)!
		value = UserDefaults.standard.string(forKey: "eSize") ?? "-1"
		sharedAttributes.eSize = Int(value)!
		value = UserDefaults.standard.string(forKey: "rSize") ?? "1"
		sharedAttributes.rSize = Int(value)!
		value = UserDefaults.standard.string(forKey: "tSize") ?? "3"
		sharedAttributes.tSize = Int(value)!
		value = UserDefaults.standard.string(forKey: "ySize") ?? "300"
		sharedAttributes.ySize = Int(value)!
		value = UserDefaults.standard.string(forKey: "keyLen") ?? "4"
		sharedAttributes.keyLen = Int(value)!
	}
	
	func savePreferences(){
		UserDefaults.standard.set(images, forKey: "images")
		UserDefaults.standard.set(instructionDelay, forKey: "instructionDelay")
		UserDefaults.standard.set(String(homeBeforeStep), forKey: "homeBeforeStep")
		UserDefaults.standard.set(String(useRange), forKey: "useRange")
		UserDefaults.standard.set(String(stepGranularity), forKey: "stepGranularity")
		UserDefaults.standard.set(String(stepSize), forKey: "stepSize")
		UserDefaults.standard.set(sharedAttributes.nearIndex, forKey: "nearIndex")
		UserDefaults.standard.set(sharedAttributes.farIndex, forKey: "farIndex")
		UserDefaults.standard.set(String(sharedAttributes.keyLen), forKey: "keyLen")
	}
	
	
}




struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(sharedAttributes: SharedAttributes(), messager: Messager())
	}
}
