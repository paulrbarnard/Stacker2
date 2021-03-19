//
//  Preferences.swift
//  Stacker2
//
//  Created by pbarnard on 19/03/2021.
//  Copyright © 2021 Paul Barnard. All rights reserved.
//

import SwiftUI

struct PreferencesView: View {
	
	@ObservedObject var sharedAttributes: SharedAttributes
	
	var helper = Helper()
	
	let largestString = "Simultanious Key presses:"
	let largestButton = "Reset"
	@State var hundreds = "8888"
	@State var qSizeString = "-300"
	@State var wSizeString = "-3"
	@State var eSizeString = "-1"
	@State var rSizeString = "1"
	@State var tSizeString = "3"
	@State var ySizeString = "300"
	@State var instructionDelay = "2.0"
	@State var keyLen = "5"
	
	
	var body: some View {
		VStack {
			Text("Preferences")
			Section (header: Text("Step Size Adjustment")){
				HStack {
					helper.uncompressableText("Steps for <<<")
					helper.equalSizeUncompressableTextField("Steps for <<<", refText: $hundreds, text: $qSizeString).frame(width: 60, height: nil)
					helper.uncompressableText("Steps for <<")
					helper.equalSizeUncompressableTextField("Steps for <<", refText: $hundreds, text: $wSizeString).frame(width: 60, height: nil)
					helper.uncompressableText("Steps for <")
					helper.equalSizeUncompressableTextField("Steps for <", refText: $hundreds, text: $eSizeString).frame(width: 60, height: nil)
				}
				HStack {
					helper.uncompressableText("Steps for >>>")
					helper.equalSizeUncompressableTextField("Steps for >>>", refText: $hundreds, text: $ySizeString).frame(width: 60, height: nil)
					helper.uncompressableText("Steps for >>")
					helper.equalSizeUncompressableTextField("Steps for >>", refText: $hundreds, text: $tSizeString).frame(width: 60, height: nil)
					helper.uncompressableText("Steps for >")
					helper.equalSizeUncompressableTextField("Steps for >", refText: $hundreds, text: $rSizeString).frame(width: 60, height: nil)
				}
			}.padding()
			Section (){
				Section (header: Text("Instruction Delay")) {
					VStack {
						HStack{
							helper.equalSizeText("Instruction Delay:",refString: largestString)
							helper.equalSizeUncompressableTextField("Instruction Delay in Seconds", refText: $hundreds, text: $instructionDelay).frame(width: 60, height: nil)
							Text("seconds")
							Spacer()
						}
					}
					
				}.padding(.horizontal)
				Section (header: Text("Key Presses")) {
					VStack {
						HStack{
							helper.equalSizeText("Simultanious Key presses:",refString: largestString)
							helper.equalSizeUncompressableTextField("Instruction Delay in Seconds", refText: $hundreds, text: $keyLen).frame(width: 60, height: nil)
							Spacer()
						}
					}
					
				}.padding(.horizontal)
				Spacer()
				HStack{
					Button(action: {
						// Cancel
						print("Cancel")

						NSApplication.shared.keyWindow?.close()
					}){
						helper.equalSizeText("Cancel", refString: largestButton, alignment: .center)
					}
					Spacer()
					Button(action: {
						// Resets
						print("Reset")
						qSizeString = "-300"
						wSizeString = "-3"
						eSizeString = "-1"
						rSizeString = "1"
						tSizeString = "3"
						ySizeString = "300"
						instructionDelay = "2.0"
						keyLen = "5"
					}){
						helper.equalSizeText("Reset", refString: largestButton, alignment: .center)
					}
					Spacer()
					Button(action: {
						// Done
						sharedAttributes.qSize = Int(qSizeString) ?? -300
						sharedAttributes.wSize = Int(wSizeString) ?? -3
						sharedAttributes.eSize = Int(eSizeString) ?? -1
						sharedAttributes.rSize = Int(rSizeString) ?? 1
						sharedAttributes.tSize = Int(tSizeString) ?? 3
						sharedAttributes.ySize = Int(ySizeString) ?? 300
						sharedAttributes.instructionDelay = instructionDelay
						sharedAttributes.keyLen = Int(keyLen) ?? 5
						NSApplication.shared.keyWindow?.close()
					}){
						helper.equalSizeText("Save and Close", refString: largestButton, alignment: .center)
					}
				}.padding()
			}
		}.onAppear {
			qSizeString = String(sharedAttributes.qSize)
			wSizeString = String(sharedAttributes.wSize)
			eSizeString = String(sharedAttributes.eSize)
			rSizeString = String(sharedAttributes.rSize)
			tSizeString = String(sharedAttributes.tSize)
			ySizeString = String(sharedAttributes.ySize)
			instructionDelay = sharedAttributes.instructionDelay
			keyLen = String(sharedAttributes.keyLen)
		}
	}
	
	
}

struct Preferences_Previews: PreviewProvider {
	static var previews: some View {
		PreferencesView(sharedAttributes: SharedAttributes())
	}
}
