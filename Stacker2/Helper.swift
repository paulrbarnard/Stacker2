//
//  Helper.swift
//  Stacker2
//
//  Created by Paul Barnard on 18/03/2021.
//  Copyright © 2021 Paul Barnard. All rights reserved.
//

import Foundation
import SwiftUI

class Helper {
    
    // text handling
    
    func uncompressableText(_ string: String) -> some View {
        return Text(string).fixedSize(horizontal: true, vertical: false)
    }
    
    func uncompressableTextField(_ string: String, text: Binding<String>) -> some View {
        return TextField(string, text: text).fixedSize(horizontal: true, vertical: false)
    }
    
    func equalSizeText(_ string: String, refString: String, alignment: Alignment = .leading) -> some View{
        return  ZStack (alignment: alignment) {
            Text(string)
            Text(refString).hidden()
        }
    }
    
    func equalSizeUncompressableTextField(_ string: String, refText: Binding<String>, text: Binding<String>, alignment: Alignment = .leading) -> some View{
        return  ZStack (alignment: alignment) {
            TextField(string, text: text)
            TextField(string, text: refText).hidden().fixedSize(horizontal: true, vertical: false)
        }
    }
    
}

extension String {
   func widthOfString(usingFont font: NSFont) -> CGFloat {
		let fontAttributes = [NSAttributedString.Key.font: font]
		let size = self.size(withAttributes: fontAttributes)
		return size.width
	}
}
