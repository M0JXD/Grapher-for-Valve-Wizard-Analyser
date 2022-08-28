# Grapher-for-Valve-Wizard-Analyser
A Processing based logger/grapher for ValveWizard's/Merlin Blencowe's Arduino Valve Analyser

This is a app made with the Processing environment for use with Valve Wizard's Arduino Valve Analyser.
The original can be seen here: https://www.valvewizard.co.uk/analyser.html

![Arduino Valve Analyser](https://user-images.githubusercontent.com/94254558/187069764-fba02bf1-de98-4141-84c8-5cf15ce4d42c.png)

It's by no means as nice or fancy, but it's functional enough to send the settings and plot graphs.
I sent it to Valve Wizard for trying out, however gathering from the update on the site it's quite possible this blew the thing up!

I've been a bit cheeky and borrowed ValveWizard's logo and used it as part of an icon for the app. I will remove it if requested.

I haven't made any hardware to test it properly with yet - included is some Arduino code used to emulate the hardware for testing, listed under "Faux Valve Analyser", so use this at your own risk. It's a bit rudimentry and I ~~wouldn't be suprised if there's~~ **am already aware of** a few bugs. The code is here for others to look at and modify.

## Running the code

To run this you will require:

 • Processing 4 Development Environment: https://processing.org/download

In Processing you will need to install:

 • G4P Toolkit and library
 
 • graphica library

Once these are installed, open "Valve_Analyser_Main.pde" and the other code should automatically be imported in to seperate tabs.
From there it's as simple as hitting "Run".

## User Guide

This application sends and receives data for the Arduino Valve analyser.

Firstly, select the COM port. Click "Click to Update" to refresh the COM list and select the correct COM port.

Secondly, select your settings - not all settings fields need to be filled  for Diode and Triode modes.
This is fairly self explanatory, the text fields can be "tabbed" between for speedy entry. Use "SHIFT-TAB" to move upwards.
Please see Valve Wizard's main project page for a better understanding of the fields.

Click "Submit to Arduino" to send the values. After a brief delay, the info pane should say "Values Submitted".

Click the "Run?" button to initialise the test. The button will remain highlighted as the test runs. This can take some time, the program allows 100ms per datapoint the arduino performs. A good approximation is to use the "No of datapoints per sweep" as the wait time in seconds.

If all goes well, the Info Pane should say "Done!" and the graph will plot to the right of the selection area.

Use the selection area's "Graph One/Two/Three" to look at different plots. The options are:

Diode Mode: 
 • Diode Side One Plot
 • Diode Side Two Plot
 • Both Diodes plotted

Triode Mode:
 • Triode Side One Plot
 • Triode Side Two Plot
 • Both Triode plotted - Triode two should have thinner lines

Tetrode/Pentode Mode:
 • Anode Currents Plot
 • Screen Currents Plot
 • Cathode Currents Plot

**Demo Mode:**

This is the same as Pentode mode but uses pre-programmed data to plot the graphs.
In this mode just press the run button (No need to enter values or submit data) to plot some sample graphs.

Press "Run?" again to Run a new test without submitting new parameters,
or start the process again for the next test. Bear in mind the graph may change as a new Test Mode is being selected. 

**Use with Faux Valve Analyser:**

To use with the "Faux Analyser" program these settings must be:

No of datapoints: 16
Bias Range: 20
Bias Step: 2

Otherwise the data will not be parsed correctly and the program crashes due to null pointers etc.

## Thoughts for the future

There are ideas for some features to add listed at the top of the source code, but in reality I want to rebuild this from scratch in a better environment.

A mistake made here was trying to ensure this would work without modifying the original Arduino code. As such, information is sent and received in a "Wait & Pray" manner. It would be much better to implement a proper protocol. If anything, this would be the reason why it doesn't work.

Processing itself is quite slow as well. Building in Java or Python would work much better, and allow for much better versatility. I don't think it will compile for MacOS at the moment, another reason to rebuild for platform independence. Processing was only chosen intitially as it's RS232 over USB library makes it easy to communicate with the Arduino.

I plan to build my own anayser based of this one - I'm hoping to make this parts even more generic with plans to remove the specialist op-amps.
If this goes ahead, I will make new software for both the Arduino and Grapher so they work together in harmony.
