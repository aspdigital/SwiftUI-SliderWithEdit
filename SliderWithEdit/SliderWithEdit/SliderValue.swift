//
//  SliderValue.swift
//  SliderWithEdit
//
//  Created by Andy Peters on 8/15/23.
//

import Foundation

class SliderValue: ObservableObject {
    @Published var sv : Double
    @Published var tv : Double
    
    init(sv: Double, tv: Double) {
        self.sv = sv
        self.tv = tv
    }
}
