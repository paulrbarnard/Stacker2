//
//  FocusButtons.swift
//  Stacker2
//
//  Created by Paul Barnard on 18/03/2021.
//  Copyright © 2021 Paul Barnard. All rights reserved.
//

import SwiftUI


struct FocusButtonsView: View   {
    
    @ObservedObject var sharedAttributes: SharedAttributes
    
    
	var messager: Messager
	var helper = Helper()
    let largestString = "Step Granularity:"
    let largestButton = "Min Focus"
    @State var thousands = "8888"
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Button(action: {
                        _ = messager.sendKeyPress("q")
						sharedAttributes.currentIndex = adjustCurrentIndex(offset: sharedAttributes.qSize)
                    }){
                        helper.equalSizeText("<<<", refString: largestButton, alignment: .center)
                    }.disabled(sharedAttributes.running == true)
                    Spacer()
                    Button(action: {
                        _ = messager.sendKeyPress("w")
						sharedAttributes.currentIndex = adjustCurrentIndex(offset: sharedAttributes.wSize)
                    }){
                        helper.equalSizeText("<<", refString: largestButton, alignment: .center)
                    }.disabled(sharedAttributes.running == true)
                    Spacer()
                    Button(action: {
                        _ = messager.sendKeyPress("e")
						sharedAttributes.currentIndex = adjustCurrentIndex(offset: sharedAttributes.eSize)
                    }){
                        helper.equalSizeText("<", refString: largestButton, alignment: .center)
                    }.disabled(sharedAttributes.running == true)
                    Spacer()
                }
                VStack {
                    Spacer()
                    Button(action: {
                        _ = messager.sendKeyPress("qqqqqqqqqq")
                        sharedAttributes.currentIndex = "0"
                    }){
                        helper.equalSizeText("Min Focus", refString: largestButton, alignment: .center)
                    }.disabled(sharedAttributes.running == true)
                    Spacer()
                }
                VStack {
                    Spacer()
                    Button(action: {
                        _ = messager.sendKeyPress("y")
						sharedAttributes.currentIndex = adjustCurrentIndex(offset: sharedAttributes.ySize)
                    }){
                        helper.equalSizeText(">>>", refString: largestButton, alignment: .center)
                    }.disabled(sharedAttributes.running == true)
                    Spacer()
                    Button(action: {
                        _ = messager.sendKeyPress("t")
						sharedAttributes.currentIndex = adjustCurrentIndex(offset: sharedAttributes.tSize)
                    }){
                        helper.equalSizeText(">>", refString: largestButton, alignment: .center)
                    }.disabled(sharedAttributes.running == true)
                    Spacer()
                    Button(action: {
                        _ = messager.sendKeyPress("r")
						sharedAttributes.currentIndex = adjustCurrentIndex(offset: sharedAttributes.rSize)
                    }){
                        helper.equalSizeText(">", refString: largestButton, alignment: .center)
                    }.disabled(sharedAttributes.running == true)
                    Spacer()
                }
                Spacer()
            }
            HStack{
                Spacer()
                helper.uncompressableText("Current Index")
                helper.uncompressableTextField("Current Index", text: $sharedAttributes.currentIndex)
                Spacer()
            }
            HStack{
				Spacer()
                Button(action: {
                    sharedAttributes.nearIndex = sharedAttributes.currentIndex
                }){
                    helper.equalSizeText("Near Index", refString: "Near Index", alignment: .center)
                }.disabled(sharedAttributes.running == true)
                helper.equalSizeUncompressableTextField("Near Index", refText: $thousands, text: $sharedAttributes.nearIndex).frame(width: 60, height: nil)
                Spacer()
                Button(action: {
                    sharedAttributes.farIndex = sharedAttributes.currentIndex
                }){
                    helper.equalSizeText("Far Index", refString: "Near Index", alignment: .center)
                }.disabled(sharedAttributes.running == true)
                helper.equalSizeUncompressableTextField("Far Index", refText: $thousands, text: $sharedAttributes.farIndex).frame(width: 60, height: nil)
				Spacer()
			}.padding(.horizontal)
        }
        
    }
    
    
    func adjustCurrentIndex(offset: Int) -> String {
        if sharedAttributes.currentIndex == "Unknown" {
            return "Unknown"
        }
        var newIndex = Int(sharedAttributes.currentIndex)! + offset
        if newIndex < 0 {
            newIndex = 0
        }
        return String(newIndex)
    }
    
}


struct FocusButtons_Previews: PreviewProvider {
    static var previews: some View {
		FocusButtonsView(sharedAttributes: SharedAttributes(), messager: Messager())
    }
}

