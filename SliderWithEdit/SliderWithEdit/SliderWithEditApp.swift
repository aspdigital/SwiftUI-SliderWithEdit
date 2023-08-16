//
//  SliderWithEditApp.swift
//  SliderWithEdit
//
//  Created by Andy Peters on 8/8/23.
//

import SwiftUI

@main
struct SliderWithEditApp: App {
    
    @StateObject private var slidervalue = SliderValue(sv: 0.0, tv: 0.0)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(slidervalue)
        }
    }
}
