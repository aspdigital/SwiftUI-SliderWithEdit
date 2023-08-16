//
//  SliderWithEditView.swift
//  SliderWithEdit
//
//  Created by Andy Peters on 8/8/23.
//

import SwiftUI

struct SliderWithEditView: View {
    
    @EnvironmentObject  var slidervalue : SliderValue

    var rangeMin : Double = -10.0
    var rangeMax : Double = 10.0
    
    @FocusState private var isTextFieldFocused : Bool
    @FocusState private var isSliderFocused : Bool

    /* Clamp text edit entry to our range. */
    func clamp() {
        if slidervalue.tv > rangeMax {
            slidervalue.tv = rangeMax
        } else if slidervalue.tv < rangeMin {
            slidervalue.tv = rangeMin
        }
    }

    var body: some View {
        VStack {
            
            TextField("Value:",
                      value: $slidervalue.tv,
                      format: .number.precision(.fractionLength(1)))
            .frame(width: 50, height: 50)
            .focused($isTextFieldFocused)
            /* onSubmit to handle user pressing the enter key to accept new value and thus updating
             * the slider. Normally the TextField would retain focus, but when the Slider notices
             * the value has changed, the Slider grabs focus. */
            .onSubmit {
                clamp()
                slidervalue.sv = slidervalue.tv
                print("Text field submitted, slider updated to \(slidervalue.sv)")
            }
            /* onChange looks for TextField focus change. If we lost focus, either user hit <tab>
             * or moved the mouse out of the field. The only place in the view that can take focus
             * is the slider.
             * In either case we should copy the text field value to the slider. */
            .onChange(of: isTextFieldFocused) { isTextFieldFocused in
                print("TextField focus changed. it is: isTextFieldFocused = \(isTextFieldFocused)")
                print("TextField value after focus change = \(slidervalue.tv)")
                /* Only update slider when we lose focus, that is, <tab> was hit or mouse clicked on the slider */
                if !isTextFieldFocused {
                    clamp()
                    slidervalue.sv = slidervalue.tv
                    print("TextField lost focus, so update new slider value from text entry: \(slidervalue.sv)")
                } else {
                    print("Focus changed to TextField, not updating slider.")
                }
            }
            .disableAutocorrection(true)

            Slider(value: $slidervalue.sv,
                   in: rangeMin...rangeMax,
                   step: 0.5)
            .focused($isSliderFocused)
            .frame(width: 200, height: 10)
            .onChange(of: slidervalue.sv) { value in
                /* slider value changed, so force focus back to the slider. Oddly,
                 * clicking the mouse on the slider or its thumb doesn't give it focus.
                 * slider must have focus otherwise the textValue update from value here
                 * doesn't cause the TextField display to update. */
                isSliderFocused = true
                slidervalue.tv = value
                print("Slider moved, copy slider value to new textValue = \(slidervalue.tv)")
            }
            .padding()
        }
    }
}

struct SliderWithEditView_Previews: PreviewProvider {
    static var previews: some View {
        SliderWithEditView()
            .environmentObject(SliderValue(sv: 0.0, tv: 0.0))
    }
}
