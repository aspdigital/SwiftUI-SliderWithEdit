# SwiftUI-SliderWithEdit

If you have used Apple's Logic or GarageBand DAWs, you're familiar with the audio faders and other controls for level and sends.

The controls consist of two parts: one is the fader or knob. The second is a text field that shows the numeric value of the fader position. The clever part is that when you move the fader, the text indicator updates, and when you type a value into the text field, the fader moves. In either case the DAW accepts the new level.

If you used the older Objective-C AppKit tools (where you laid out your controls with Interface Builder), you know that a "slider with text field" control didn't exist. You had to create a composite control from a NSSlider and an NSTextField, and bind the two to a single variable. If you moved that design from Objective-C to Swift, you probably noticed that this control existed there, either, so you did the same thing as you did in Objective-C. Now we have SwiftUI, and guess what? Still no control with a synchronized Slider and TextField.

I have an existing program written awhile ago in Swift and AppKit, and I decided that was a good project to port to SwiftUI as I started to learn the new tools. This program has a few synched sliders/text field controls. This demo project has a module that implements the SliderWithEditView control itself as well as a simple app that instantiates two of these controls.

The current demo just shows the controls moving and values changing. The values are implemented in the control View as `@State` variables. There's no mechanism for something outside the view to actually do anything with the data. You should probably create a class which inherits from `ObservableObject` and declare a bunch of `@Published` properties in that class, and then have the relevant things in the `SliderWithEditView` itself. This is an exercise left to the reader.
