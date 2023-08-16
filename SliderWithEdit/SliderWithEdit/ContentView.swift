//
//  ContentView.swift
//  SliderWithEdit
//
//  Created by Andy Peters on 8/8/23.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        VStack {
            GroupBox {
                SliderWithEditView(min: -95.5, max: 31.5)
            }
            GroupBox {
                SliderWithEditView(min: -10.0, max: 10.0)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
