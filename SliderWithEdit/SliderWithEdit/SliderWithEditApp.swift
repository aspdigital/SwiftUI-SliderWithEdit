//
//  SliderWithEditApp.swift
//  SliderWithEdit
//
//  Created by Andy Peters on 8/8/23.
//

import SwiftUI

@main
struct SliderWithEditApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(slidervalue_a: SliderValue(sv: 0.0, tv: 0.0), slidervalue_b: SliderValue(sv: 1.1, tv: 1.1))
        }
    }
}
