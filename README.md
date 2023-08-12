 # SwiftUI-SliderWithEdit

If you have used Apple's Logic or GarageBand DAWs, you're familiar with the audio faders and other controls for level and sends.

The controls consist of two parts: one is the fader or knob. The second is a text field that shows the numeric value of the fader position. The clever part is that when you move the fader, the text indicator updates, and when you type a value into the text field, the fader moves. In either case the DAW accepts the new level.

If you used the older Objective-C AppKit tools (where you laid out your controls with Interface Builder), you know that a "slider with text field" control didn't exist. You had to create a composite control from a NSSlider and an NSTextField, and bind the two to a single variable. If you moved that design from Objective-C to Swift, you probably noticed that this control existed there, either, so you did the same thing as you did in Objective-C. Now we have SwiftUI, and guess what? Still no control with a synchronized Slider and TextField.

I have an existing program written awhile ago in Swift and AppKit, and I decided that was a good project to port to SwiftUI as I started to learn the new tools. This program has a few synched sliders/text field controls. This demo project has a module that implements the SliderWithEditView control itself as well as a simple app that instantiates two of these controls.

The current demo just shows the controls moving and values changing. The values are implemented in the control View as `@State` variables. There's no mechanism for something outside the view to actually do anything with the data. You should probably create a class which inherits from `ObservableObject` and declare a bunch of `@Published` properties in that class, and then have the relevant things in the `SliderWithEditView` itself. This is an exercise left to the reader.

I make no claims of being an expert-level Swift or SwiftUI programmer. Surely the code here could be "Swiftier" and suggestions are welcome. Remember: I design hardware with FPGAs for a living, and I only dabble in host-computer application software programming when there's a need.

I leaned on Paul Hudson's [Hacking With Swift website](https://www.hackingwithswift.com) for help and tutorials. I even bought the [Hacking with macOS (SwiftUI edition)](https://www.hackingwithswift.com/store/hacking-with-macos) book. I also bought [SwiftUI for MasterMinds](https://books.apple.com/us/book/swiftui-for-masterminds-3rd-edition-2022/id6443368742) which is good but most of its material is for iOS, not macOS. [macOS by Tutorials](https://www.kodeco.com/books/macos-by-tutorials/v1.0) is also good. Finally, you should bookmark the Apple Developer site's [SwiftUI](https://developer.apple.com/documentation/swiftui/) section. 

## Description

The control itself is in the source `SliderWithEditView.swift`. The basic idea is that the slider can be moved in some range, and the user can enter a value for the slider. At the top of the structure definition, there are two `private var`s, `rangeMin` and `rangeMax`. These set the slider range, and hence the range of values we get from our control.

Next are two `@State` properties. These properties are bound to our two controls. The Slider updates and is updated by the `sliderValue` property, and the Text Field updates and is updated by the `textValue` property. This should be familiar if you've looked at any SwiftUI control stuff.

Two `@FocusState` properties follow. These are need to handle how the controls know when to update their associated properties. More in a bit about them below.

There are two initializers. One has no arguments, and it simply assigns the default values of `rangeMin` and `rangeMax` to the state properties. Since it's likely that your desired range is not -100.0 to +100.0, a second initializer takes `min` and `max` arguments and uses them to set the desired data range.

The `clamp` function is used to ensure that what the user enters into the TextField is clamped to the control range we just set.

The `body` property, where the work, is done follows. The control looks nice in the basic `VStack`. 

### TextField
First up is the `TextField`. The `value` argument is set to our `@State` property `textValue`, so when that changes the field gets updated and when something needs the value of the field, it gets it through that property. `.format` is used to configure the field as numeric only, with one fractional (decimal) place. We set a `.frame` of arbitrary size.

Next we add a `.focused()` modifier to the control's view. The `isTextFieldFocused` property goes true when the field gets focus and goes false when it doesn't. Why is this needed? Just a moment.

There are two instance methods for our TextField's view. At first I did not realize that I needed both.

`.onSubmit()` is invoked when the user wants to "submit" the contents of the TextField to whatever ultimately stores it. Until submission nothing knows about the data in the field. Submission occurs (only, as far as I know) when the user presses the <Return> or <Enter> keys. Upon submission, we want to update the slider position, so first we take the `textValue` property, which is set by the submission, and we clamp it if necessary, then we update the sliderValue with it. This assignment triggers the Slider's `.onChange()` method (see below).

`.onSubmit()` requires that the user press the <Return> key. But Logic's fader control doesn't require that. If you <Tab> away from the fader's edit box, or select something else with the mouse, the value you typed in is accepted and updates the fader. So we need another way to accept the value in the edit box.

This is where the `.onChange(of: isTextFieldFocused)` method comes in. This method is triggered when the TextField's focus changes. We don't care when the field gets focus (that just lets the user type in the box), but we want the value in the box to be accepted when the focus goes away. So we test for that, and if we've lost focus, then we take the value in the text field, clamp it, then again assign it to the `sliderValue`, and again this triggers the `.onChange()` method in the slider so it update the thumb location.

There it is: the TextField value is taken and used to update the Slider's position.

### Slider
Next we instantiate a `Slider`. The `value` argument is the `@State` property `sliderValue`. We set that property elsewhere (like in the TextField submission/change methods) to update the position of the thumb, and if anything needs the position it gets it from that property.
The range of the slider values is set by the `in:` argument to the range min and max.
We set the `step:` side of the slider motion to 0.5. It can be whatever you like.

Next we add the `.focused()` modifier to this view. This solved a perplexing issue I discovered with the Slider control. More on that in a moment.
The `.frame()` is obvious.
The `.onChange()` method is invoked when the `sliderValue` property changes. This property is changed by two things: when the TextField value is submitted or the field loses focus, and when the slider thumb is moved. But here is the perplexing issue I mentioned. For reasons I do not understand, if the Slider control does not have focus, when you move it, the assignment to `textValue` doesn't cause the TextField to update! I think this is because the TextField actually retains focus and perhaps ignores something else changing `textValue`. (This is speculation!) Thus we have to force the Slider to take focus by setting `isSliderFocused` true. Now when we move the slider thumb, `textValue` updates so the TextField display updates.

The next time we click on the TextField or <tab> to it, it gains focus. It is assumed that the `value` it displays is correct -- the only way it gets set is by user entry or a slider move -- so in the `.onChange()` we don't do anything when first getting focus.

## Summary
The control value interchange is somewhat circular. There are suggestions that only one `@State` property can be used, shared by both the Text Field and the Slider as their `value:`s, but I couldn't get that to work. (I think it _should_ work and any suggestions are welcome!) The next thing to do is to add a global `ObservableObject` class with a `@Published` property for the value the user enters with the control, and then update that property after the changes are made in the control.
