//
//  ContentView.swift
//  SliderWithEdit
//
//  Created by Andy Peters on 8/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var slidervalue: SliderValue

    var body: some View {
        
        VStack {
            GroupBox {
                SliderWithEditView(rangeMin: -95.5, rangeMax: 31.5)
            }
            Text("Slider A: \(slidervalue.sv)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SliderValue(sv: 0.0, tv: 0.0))
    }
}
