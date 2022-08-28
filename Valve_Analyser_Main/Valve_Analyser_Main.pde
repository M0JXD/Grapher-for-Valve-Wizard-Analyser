/* WORK TO DO

  For now, I'm calling this complete, however here are some thoughts below for potential future improvements:
  
 Thoughts?
 Add a way to export the Graphs/Data.
 Calculate the Valve Properties.
 Add Graph zooming and panning.
 Highlightable plot points - see the exact values
 Savable Test Setting Presets.
 Improve serial wait times.
 Sort out the info pane to update at suitable times - it's not really updating enough
 Put the graph in a seperate window for larger display area - G4P allows this
 Make the GUI prettier - John Poltra's Screenshots put this to shame!
*/

// Import/include Libraries //////////////////////////////////////////////////////////////////////
import g4p_controls.*; // GUI Interface
import processing.serial.*; // USB Serial Comms for Arduino
import grafica.*; // Graph Plotter

// Global Variables //////////////////////////////////////////////////////////////////////

// lots of colours! Just a repeating sequence (approx 88?)

color[] lineColours = {#2f4f4f, #a52a2a, #191970, #006400, #ff0000, #00ced1, #ffa500, #ffff00, #deb887, #00ff00, #0000ff, #ff00ff, #1e90ff, 
                       #dda0dd, #ff1493, #98fb98}; // Used a generator to make 16 nice distinct colours

boolean submitWentWell = false; // Used to make sure stuff in the loop only happens once,
boolean runBeenClicked = false;
byte graphOptionSelected = 1;
int[] graphProperties = new int[5];
String displayText = null;

// Global Objects /////////////////////////////////////////////////////////////////////

DataFromArduino merlinsSample; // Faux data for graph testing
Serial arduinoPort;

// Graph Objects - will get set up differently depending on Diode/Triode/Pentode tests
GPlot sideOneOrPentodeAnodePlot; // Graph object reference
GPlot sideTwoOrPentodeScreenPlot; //""
GPlot bothOrPentodeCathodePlot; //""

GPointsArray[] layersForPlot1; // Graph points reference
GPointsArray[] layersForPlot2; // ""
GPointsArray[] layersForPlot3; // ""

// Setup ///////////////////////////////////////////////////////////////////

public void setup() {
  size(800, 600, JAVA2D);
  PImage icon = loadImage("icon.png");
  surface.setIcon(icon); // These let me have a custom icon
  graphProperties[0] = 310; // X coordinate
  graphProperties[1] = 10; // Y coordinate
  graphProperties[2] = 480; // X dimension
  graphProperties[3] = 580; // Y dimension
  graphProperties[4] = 4; // Point Size

  background(150);

  // GUI Setup
  createGUI(); // Sets up all variables and handlers related to the GUI
  customGUI(); // Allows for GUI customisation
}

// Draw (Main loop) //////////////////////////////////////////////////////////////////////

public void draw() {
  background(150); // Set background shade, lettering can become fuzzy if it doesn't wipe away the old GUI from the previous loop
  // Credits
  fill(#130a73);
  textSize(14);
  text("                                           Credits:\n" +
  " Analyser Design: Merlin Blencowe (Valve Wizard)\n" + 
  "                Program Design: Jamie Drinkell\n" + 
  "                   Special thanks: John Polstra\n" +
  "                          Built with Processing."
  
  
  , 10, 450);
  if (displayText != null) {
    infoLabel.setText(displayText, GAlign.LEFT, GAlign.TOP);
  }
  // Draw the selected graph
  if (runBeenClicked == true) {
    switch(graphOptionSelected) {
    case 1:
      sideOneOrPentodeAnodePlot.defaultDraw(); //<>//
      sideOneOrPentodeAnodePlot.activateZooming();
      sideOneOrPentodeAnodePlot.beginDraw(); // beginDraw() sets the environment for calling individual drawing functions
      sideOneOrPentodeAnodePlot.drawGridLines(GPlot.BOTH); // Draw gridlines on both Axises
      sideOneOrPentodeAnodePlot.drawPoints();
      sideOneOrPentodeAnodePlot.drawLines();
      if (UserSelection.settingTestType > 1 && DataFromArduino.biasForEachLayerSide1String != null) {
        if( !DataFromArduino.biasForEachLayerSide1String[0].equals(DataFromArduino.biasForEachLayerSide1String[1]) ) {
      sideOneOrPentodeAnodePlot.drawLegend(DataFromArduino.biasForEachLayerSide1String, DataFromArduino.legendX, DataFromArduino.legendY); 
        }
      }
      sideOneOrPentodeAnodePlot.endDraw(); // endDraw() returns it to it's original state for doing the usual stuff (rect(), ellipse() etc.).
      break;

    case 2:
      sideTwoOrPentodeScreenPlot.defaultDraw();
      sideTwoOrPentodeScreenPlot.beginDraw(); // beginDraw() sets the environment for calling individual drawing functions
      sideTwoOrPentodeScreenPlot.drawGridLines(GPlot.BOTH); // Draw gridlines on both Axises
      sideTwoOrPentodeScreenPlot.drawPoints();
      sideTwoOrPentodeScreenPlot.drawLines();
      if (UserSelection.settingTestType > 1 && DataFromArduino.biasForEachLayerSide2String != null) {
        if( !DataFromArduino.biasForEachLayerSide2String[0].equals(DataFromArduino.biasForEachLayerSide2String[1]) ) { // Pentode mode can cause issues
          sideTwoOrPentodeScreenPlot.drawLegend(DataFromArduino.biasForEachLayerSide2String, DataFromArduino.legendX, DataFromArduino.legendY);
        }
      }
      sideTwoOrPentodeScreenPlot.endDraw(); // endDraw() returns it to it's original state for doing the usual stuff (rect(), ellipse() etc.).
      break;

    case 3:
      bothOrPentodeCathodePlot.defaultDraw();
      bothOrPentodeCathodePlot.beginDraw(); // beginDraw() sets the environment for calling individual drawing functions
      bothOrPentodeCathodePlot.drawGridLines(GPlot.BOTH); // Draw gridlines on both Axises
      bothOrPentodeCathodePlot.drawPoints();
      bothOrPentodeCathodePlot.drawLines();
      if (UserSelection.settingTestType > 1 && DataFromArduino.biasForEachLayerSide1String != null) {
        if( !DataFromArduino.biasForEachLayerSide2String[0].equals(DataFromArduino.biasForEachLayerSide2String[1]) ) {
          bothOrPentodeCathodePlot.drawLegend(DataFromArduino.biasForEachLayerSide1String, DataFromArduino.legendX, DataFromArduino.legendY);
        }
      }
      if (UserSelection.settingTestType == 1) {
        bothOrPentodeCathodePlot.drawLegend(new String[] {"Diode One", "Diode Two"},  new float[] {0.07, 0.3}, 
                                            new float[] {0.97, 0.97});
      }
      bothOrPentodeCathodePlot.endDraw(); // endDraw() returns it to it's original state for doing the usual stuff (rect(), ellipse() etc.).
      break;
    }
  }
  // Note that the G4P Library has it's own "invisible" function loop that executes after draw(), but before draw() loops again
}

// customGUI()
// Use this method to add additional statements to customise the GUI controls
public void customGUI() {
  GTabManager tabs = new GTabManager(); // Creates Tab Manager Object for tabbing between text fields
  tabs.addControls(heaterVoltsField, maxAnodeVoltsField, noOfDataPointsField, setBiasField,
    biasStepField, secondaryHTField, ulPercentField, secondaryGridSupplyField); // Add tab controls
}

// arrayMax()
// Used to calculate graph height
float arrayMax(float[] passedArray) {
  // Why the heck this isn't accesible as a standard templated "array.max()" IDK
  float currentMax = 0;
  for (int i = 0; i < passedArray.length; i++) {
    if ( passedArray[i] > currentMax ) {
      currentMax = passedArray[i];
    }
  }
  return currentMax;
}

// Makes my life easier
public void printInfo(String passedString) {
  displayText = passedString;
}
