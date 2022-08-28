/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */

public void comPortListEvent(GDropList source, GEvent event) { //_CODE_:comPortList:361226:
  println("comPortList - GDropList >> GEvent." + event + " @ " + millis());
  source.setItems(Serial.list(), source.getSelectedIndex()); // Updates the list with current serial ports available (0 sets initial selected index)
  source.addItem("Click to Update");
  UserSelection.comPort = source.getSelectedText(); // sets the comPort variable to the current selection
} //_CODE_:comPortList:361226:

public void testModeListEvent(GDropList source, GEvent event) { //_CODE_:testModeList:263853:
  println("testModeList - GDropList >> GEvent." + event + " @ " + millis());
  UserSelection.settingTestType = (source.getSelectedIndex()) + 1; // Sets the test type
  // These stop crashes due to the legend trying to draw without the right info after being run through different modes
  DataFromArduino.biasForEachLayerSide1String = null;
  DataFromArduino.biasForEachLayerSide1String = null;
  // Pre do the essential values in demo mode
  if (UserSelection.settingTestType == 4) {
    UserSelection.settingMaxAnodeVolts = 420;
    UserSelection.settingScreenVolts = 250;
    UserSelection.settingNoOfDataPointsPerSweep = 16;
    UserSelection.settingBiasSet = -20f;
    UserSelection.settingBiasStep = -2f;
    DataFromArduino.noOfBiasSteps = (int)((UserSelection.settingBiasSet /  UserSelection.settingBiasStep) + 1);
    DataFromArduino.noOfDataPoints = (DataFromArduino.noOfBiasSteps * UserSelection.settingNoOfDataPointsPerSweep);
  }
} //_CODE_:testModeList:263853:

public void heaterVoltsFieldChange(GTextField source, GEvent event) { //_CODE_:heaterVoltsField:333169:
  println("heaterVoltsField - GTextField >> GEvent." + event + " @ " + millis());
  source.setNumericType(G4P.DECIMAL); // Ensures that floats are entered
  source.setNumeric(0.0f, 24.0f, 0.0f); // Ensures the entered value is in the valid range
  UserSelection.settingHeaterVolts = source.getValueF(); // Transfers the entered value
} //_CODE_:heaterVoltsField:333169:

public void maxAnodeVoltsFieldChange(GTextField source, GEvent event) { //_CODE_:maxAnodeVoltsField:883697:
  println("maxAnodeVoltsField - GTextField >> GEvent." + event + " @ " + millis());
  source.setNumericType(G4P.INTEGER); // Ensures that integer values are entered
  source.setNumeric(0, 500, 0); // Ensures the entered value is in the valid range
  UserSelection.settingMaxAnodeVolts = source.getValueI(); // Transfers the entered value
} //_CODE_:maxAnodeVoltsField:883697:

public void noOfDataPointsFieldChange(GTextField source, GEvent event) { //_CODE_:noOfDataPointsField:363740:
  println("noOfDataPointsField - GTextField >> GEvent." + event + " @ " + millis());
  source.setNumericType(G4P.INTEGER); // Ensures that integer values are entered
  source.setNumeric(2, 1000, 2); // Ensures the entered value is in the valid range
  UserSelection.settingNoOfDataPointsPerSweep = source.getValueI(); // Transfers the entered value
} //_CODE_:noOfDataPointsField:363740:

public void setBiasFieldEvent(GTextField source, GEvent event) { //_CODE_:setBiasField:521314:
  println("setBiasField - GTextField >> GEvent." + event + " @ " + millis());
  source.setNumericType(G4P.DECIMAL); // Ensures that floats are entered
  source.setNumeric(0f, 60f, 0f); // Ensures the entered value is in the valid range
  UserSelection.settingBiasSet = -(source.getValueF()); // Transfers the entered value
} //_CODE_:setBiasField:521314:

public void biasStepFieldEvent(GTextField source, GEvent event) { //_CODE_:biasStepField:606004:
  println("biasStepField - GTextField >> GEvent." + event + " @ " + millis());
  source.setNumericType(G4P.DECIMAL); // Ensures that floats are entered
  source.setNumeric(0f, 60f, 0f); // Ensures the entered value is in the valid range
  UserSelection.settingBiasStep = -(source.getValueF()); // Transfers the entered value
} //_CODE_:biasStepField:606004:

public void ulPercentFieldEvent(GTextField source, GEvent event) { //_CODE_:ulPercentField:846212:
  println("ulPercentField - GTextField >> GEvent." + event + " @ " + millis());
  source.setNumericType(G4P.INTEGER); // Ensures that floats are entered
  source.setNumeric(0, 100, 0); // Ensures the entered value is in the valid range
  UserSelection.settingUlPercent = source.getValueI(); // Transfers the entered value
} //_CODE_:ulPercentField:846212:

public void secondaryHTFieldEvent(GTextField source, GEvent event) { //_CODE_:secondaryHTField:500355:
  println("secondaryHTLabel - GTextField >> GEvent." + event + " @ " + millis());
  source.setNumericType(G4P.INTEGER); // Ensures that floats are entered
  source.setNumeric(0, 500, 0); // Ensures the entered value is in the valid range
  UserSelection.settingScreenVolts = source.getValueI(); // Transfers the entered value
} //_CODE_:secondaryHTField:500355:

public void submitValuesButtonEvent(GButton source, GEvent event) { //_CODE_:submitValuesButton:543918:
  println("button1 - GButton >> GEvent." + event + " @ " + millis());
  if (UserSelection.settingTestType != 4) {
  boolean initialisationGood = intialiseReadyForSubmit();
  if( initialisationGood == true) { // if initialisation works, send the values.
    boolean submitGood = submitValuesToArduino(arduinoPort);
    if(submitGood == true) {
      printInfo("Values Submitted!");
      submitWentWell = true;
    }
    else { printInfo("Issue sending values"); }
  }
  else { printInfo("Bad Initialisation"); }
  }
} //_CODE_:submitValuesButton:543918:

public void runButtonEvent(GButton source, GEvent event) { //_CODE_:runButton:612561:
  println("runButton - GButton >> GEvent." + event + " @ " + millis());
  if(submitWentWell == false && UserSelection.settingTestType != 4) { printInfo("Please submit some values first!"); }
  else {
  printInfo("Getting data from Arduino");
  DataFromArduino dataReceived =  getData();
  printInfo("Plotting the graphs...");
  setGraphData(dataReceived); 
  setupGraph(dataReceived);
  printInfo("Done!");
  runBeenClicked = true;
  }
} //_CODE_:runButton:612561:

public void secondaryGridSupplyFieldEvent(GTextField source, GEvent event) { //_CODE_:secondaryGridSupplyField:534484:
  println("secondaryGridSupplyField - GTextField >> GEvent." + event + " @ " + millis());
  source.setNumericType(G4P.DECIMAL); // Ensures that floats are entered
  source.setNumeric(0f, 60f, 0f); // Ensures the entered value is in the valid range
  UserSelection.settingSecondaryGridBias = -(source.getValueF()); // Transfers the entered value
} //_CODE_:secondaryGridSupplyField:534484:

public void option1_clicked1(GOption source, GEvent event) { //_CODE_:graphOneOption:653734:
  println("option1 - GOption >> GEvent." + event + " @ " + millis());
  graphOptionSelected = 1;
} //_CODE_:graphOneOption:653734:

public void option1_clicked2(GOption source, GEvent event) { //_CODE_:graphTwoOption:899079:
  println("graphTwoOption - GOption >> GEvent." + event + " @ " + millis());
  graphOptionSelected = 2;
} //_CODE_:graphTwoOption:899079:

public void option1_clicked3(GOption source, GEvent event) { //_CODE_:graphThreeOption:820412:
  println("graphThreeOption - GOption >> GEvent." + event + " @ " + millis());
  graphOptionSelected = 3;
} //_CODE_:graphThreeOption:820412:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setMouseOverEnabled(false);
  GButton.useRoundCorners(false);
  surface.setTitle("Arduino Valve Analyser");
  ardComPort = new GLabel(this, 10, 10, 140, 20);
  ardComPort.setText("Arduino COM Port:");
  ardComPort.setOpaque(false);
  comPortList = new GDropList(this, 160, 10, 140, 80, 3, 10);
  comPortList.setItems(loadStrings("list_361226"), 0);
  comPortList.addEventHandler(this, "comPortListEvent");
  testMode = new GLabel(this, 10, 40, 140, 20);
  testMode.setText("Test Mode:");
  testMode.setOpaque(false);
  testModeList = new GDropList(this, 160, 40, 140, 80, 3, 10);
  testModeList.setItems(loadStrings("list_263853"), 0);
  testModeList.addEventHandler(this, "testModeListEvent");
  heaterVoltsLabel = new GLabel(this, 10, 70, 140, 20);
  heaterVoltsLabel.setText("Heater Voltage:");
  heaterVoltsLabel.setOpaque(false);
  heaterVoltsField = new GTextField(this, 160, 70, 140, 20, G4P.SCROLLBARS_NONE);
  heaterVoltsField.setPromptText("Set to 2dp.");
  heaterVoltsField.setOpaque(true);
  heaterVoltsField.addEventHandler(this, "heaterVoltsFieldChange");
  maxAnodeVoltsLabel = new GLabel(this, 10, 100, 140, 20);
  maxAnodeVoltsLabel.setText("Primary HT Supply:");
  maxAnodeVoltsLabel.setOpaque(false);
  maxAnodeVoltsField = new GTextField(this, 160, 100, 140, 20, G4P.SCROLLBARS_NONE);
  maxAnodeVoltsField.setPromptText("Max HT Voltage");
  maxAnodeVoltsField.setOpaque(true);
  maxAnodeVoltsField.addEventHandler(this, "maxAnodeVoltsFieldChange");
  noOfDataPointsLabel = new GLabel(this, 10, 130, 140, 20);
  noOfDataPointsLabel.setText("Number of data points:");
  noOfDataPointsLabel.setOpaque(false);
  noOfDataPointsField = new GTextField(this, 160, 130, 140, 20, G4P.SCROLLBARS_NONE);
  noOfDataPointsField.setPromptText("Two Minimum");
  noOfDataPointsField.setOpaque(true);
  noOfDataPointsField.addEventHandler(this, "noOfDataPointsFieldChange");
  setBiasLabel = new GLabel(this, 10, 160, 140, 20);
  setBiasLabel.setText("Bias Range:");
  setBiasLabel.setOpaque(false);
  setBiasField = new GTextField(this, 160, 160, 140, 20, G4P.SCROLLBARS_NONE);
  setBiasField.setPromptText("0 to 60V");
  setBiasField.setOpaque(true);
  setBiasField.addEventHandler(this, "setBiasFieldEvent");
  biasStepLabel = new GLabel(this, 10, 190, 140, 20);
  biasStepLabel.setText("Bias Step:");
  biasStepLabel.setOpaque(false);
  biasStepField = new GTextField(this, 160, 190, 140, 20, G4P.SCROLLBARS_NONE);
  biasStepField.setPromptText("Set Bias Step.");
  biasStepField.setOpaque(true);
  biasStepField.addEventHandler(this, "biasStepFieldEvent");
  ulPercentLabel = new GLabel(this, 10, 250, 140, 20);
  ulPercentLabel.setText("UL Percent:");
  ulPercentLabel.setOpaque(false);
  ulPercentField = new GTextField(this, 160, 250, 140, 20, G4P.SCROLLBARS_NONE);
  ulPercentField.setPromptText("0 (P) to 100 (T)");
  ulPercentField.setOpaque(true);
  ulPercentField.addEventHandler(this, "ulPercentFieldEvent");
  secondaryHTSupplyLabel = new GLabel(this, 10, 220, 140, 20);
  secondaryHTSupplyLabel.setText("Secondary HT Supply:");
  secondaryHTSupplyLabel.setOpaque(false);
  secondaryHTField = new GTextField(this, 160, 220, 140, 20, G4P.SCROLLBARS_NONE);
  secondaryHTField.setPromptText("Secondary HT");
  secondaryHTField.setOpaque(true);
  secondaryHTField.addEventHandler(this, "secondaryHTFieldEvent");
  submitValuesButton = new GButton(this, 10, 310, 140, 30);
  submitValuesButton.setText("Submit to Arduino");
  submitValuesButton.addEventHandler(this, "submitValuesButtonEvent");
  runButton = new GButton(this, 160, 310, 140, 30);
  runButton.setText("Run?");
  runButton.addEventHandler(this, "runButtonEvent");
  secondaryGridSupplyLabel = new GLabel(this, 10, 280, 140, 20);
  secondaryGridSupplyLabel.setText("Secondary Grid Supply:");
  secondaryGridSupplyLabel.setOpaque(false);
  secondaryGridSupplyField = new GTextField(this, 160, 280, 140, 20, G4P.SCROLLBARS_NONE);
  secondaryGridSupplyField.setPromptText("0 to 60V");
  secondaryGridSupplyField.setOpaque(true);
  secondaryGridSupplyField.addEventHandler(this, "secondaryGridSupplyFieldEvent");
  graphToggleGroup = new GToggleGroup();
  graphOneOption = new GOption(this, 10, 350, 90, 20);
  graphOneOption.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  graphOneOption.setText("Graph One");
  graphOneOption.setOpaque(false);
  graphOneOption.addEventHandler(this, "option1_clicked1");
  graphTwoOption = new GOption(this, 110, 350, 90, 20);
  graphTwoOption.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  graphTwoOption.setText("Graph Two");
  graphTwoOption.setOpaque(false);
  graphTwoOption.addEventHandler(this, "option1_clicked2");
  graphThreeOption = new GOption(this, 210, 350, 90, 20);
  graphThreeOption.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  graphThreeOption.setText("Graph Three");
  graphThreeOption.setOpaque(false);
  graphThreeOption.addEventHandler(this, "option1_clicked3");
  graphToggleGroup.addControl(graphOneOption);
  graphOneOption.setSelected(true);
  graphToggleGroup.addControl(graphTwoOption);
  graphToggleGroup.addControl(graphThreeOption);
  infoLabel = new GLabel(this, 10, 380, 290, 30);
  infoLabel.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  infoLabel.setText("Information Pane");
  infoLabel.setLocalColorScheme(GCScheme.RED_SCHEME);
  infoLabel.setOpaque(true);
}

// Variable declarations 
// autogenerated do not edit
GLabel ardComPort; 
GDropList comPortList; 
GLabel testMode; 
GDropList testModeList; 
GLabel heaterVoltsLabel; 
GTextField heaterVoltsField; 
GLabel maxAnodeVoltsLabel; 
GTextField maxAnodeVoltsField; 
GLabel noOfDataPointsLabel; 
GTextField noOfDataPointsField; 
GLabel setBiasLabel; 
GTextField setBiasField; 
GLabel biasStepLabel; 
GTextField biasStepField; 
GLabel ulPercentLabel; 
GTextField ulPercentField; 
GLabel secondaryHTSupplyLabel; 
GTextField secondaryHTField; 
GButton submitValuesButton; 
GButton runButton; 
GLabel secondaryGridSupplyLabel; 
GTextField secondaryGridSupplyField; 
GToggleGroup graphToggleGroup; 
GOption graphOneOption; 
GOption graphTwoOption; 
GOption graphThreeOption; 
GLabel infoLabel; 
