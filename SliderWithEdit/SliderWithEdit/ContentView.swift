//
//  ContentView.swift
//  SliderWithEdit
//
//  Created by Andy Peters on 8/8/23.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var slidervalue_a: SliderValue
    @StateObject var slidervalue_b: SliderValue

    var body: some View {
        
        VStack {
            GroupBox {
                SliderWithEditView(slidervalue: slidervalue_a, rangeMin: -95.5, rangeMax: 31.5, step: 0.5)
            }.padding()
            GroupBox {
                SliderWithEditView(slidervalue: slidervalue_b, rangeMin: -10.0, rangeMax: 10.0, step: 1.0)
            }.padding()
            Text("Slider A: \(slidervalue_a.sv)")
                .padding()
            Text("Slider B: \(slidervalue_b.sv)")
                .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(slidervalue_a: SliderValue(sv: 0.0, tv: 0.0), slidervalue_b: SliderValue(sv: 1.1, tv: 1.1))
    }
}
