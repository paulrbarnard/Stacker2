//
//  SharedAttributes.swift
//  Stacker2
//
//  Created by Paul Barnard on 18/03/2021.
//  Copyright © 2021 Paul Barnard. All rights reserved.
//

import Foundation
import SwiftUI

class SharedAttributes: ObservableObject {
	@Published var running:Bool
	@Published var nearIndex:String
	@Published var farIndex:String
	@Published var currentIndex:String
	
	@Published var qSize:Int
	@Published var wSize:Int
	@Published var eSize:Int
	@Published var rSize:Int
	@Published var tSize:Int
	@Published var ySize:Int
	@Published var keyLen:Int
	@Published var instructionDelay:String


	init(running: Bool = false, nearIndex: String = "0", farIndex: String = "100", currentIndex: String = "Unkown", qSize: Int = -300, wSize: Int = -3, eSize: Int = -1, rSize: Int = 1, tSize: Int = 3, ySize: Int = 300, keyLen: Int = 5, instructionDelay: String = "2.0"){
        self.running = running
        self.nearIndex = nearIndex
        self.farIndex = farIndex
        self.currentIndex = currentIndex
		self.qSize = qSize
		self.wSize = wSize
		self.eSize = eSize
		self.rSize = rSize
		self.tSize = tSize
		self.ySize = ySize
		self.keyLen = keyLen
		self.instructionDelay = instructionDelay
    }
    
}
