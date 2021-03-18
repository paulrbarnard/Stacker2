//
//  ContentView.swift
//  Stacker2
//
//  Created by Paul Barnard on 29/06/2020.
//  Copyright © 2020 Paul Barnard. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @State private var images = "10"
    @State private var instructionDelay = "3.0"
    @State private var homeBeforeStep = true
    let stepGranularitys = ["Fine (x1)", "Medium (x4)", "Course (x100)"]
    @State private var stepGranularity = 1
    @State private var stepSize = 5.0
    @State private var count = 0
    
    var messager = Messager()
    
    let largestString = "Step Granularity:"
    let largestButton = "Stop"
    @State var hundreds = "888"
    
    @State var running = false
    
    let didStart = NotificationCenter.default.publisher(for: NSNotification.Name("com.toxic.messageStartedNotificationID"))
    let didComplete = NotificationCenter.default.publisher(for: NSNotification.Name("com.toxic.messageCompleteNotificationID"))
    
     
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    uncompressableText("Images")
                    equalSizeUncompressableTextField("Number of images", refText: $hundreds, text: $images)
                    Spacer()
                    Toggle(isOn: $homeBeforeStep) {
                        uncompressableText("Minimum focus before stack")
                    }
                }
                
                Section (header: Text("Delay")) {
                    VStack {
                        HStack{
                            equalSizeText("Instruction Delay:",refString: largestString)
                            equalSizeUncompressableTextField("Instruction Delay in Seconds", refText: $hundreds, text: $instructionDelay)
                            Spacer()
                        }
                        .frame(width: nil)
                     }
                    
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
                }
                
                 HStack{
                    Button(action: {
                        // stop taking images
                        print("stopped taking images")
                        self.stopStack()
                    }){
                        equalSizeText("Stop", refString: largestButton, alignment: .center)
                    }.disabled(running == false)
                    Spacer()
                    Button(action: {
                        // start taking images
                        print("started taking",images, "images")
                        self.startStack()
                    }){
                        equalSizeText("Go", refString: largestButton, alignment: .center)
                    }.disabled(running == true)
                 }
            }.padding()
        }.onAppear(){
            loadPreferences()
        }.onDisappear(){
            savePreferences()
        }.onReceive(didStart){ (_) in
            running = true
        }.onReceive(didComplete){ (_) in
            running = false
        }
    }
    
    
// Stacker functions
    
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
        var loop = 40
        while loop > 0 {
            string += "q"
            loop -= 1
        }
        _ = messager.sendKeyPress(string)
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
        value = UserDefaults.standard.string(forKey: "stepGranularity") ?? "1"
        stepGranularity = Int(value)!
        value = UserDefaults.standard.string(forKey: "stepSize") ?? "5"
        stepSize = Double(value)!
    }
    
    func savePreferences(){
        UserDefaults.standard.set(images, forKey: "images")
        UserDefaults.standard.set(instructionDelay, forKey: "instructionDelay")
        UserDefaults.standard.set(String(homeBeforeStep), forKey: "homeBeforeStep")
        UserDefaults.standard.set(String(stepGranularity), forKey: "stepGranularity")
        UserDefaults.standard.set(String(stepSize), forKey: "stepSize")
    }
    
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
