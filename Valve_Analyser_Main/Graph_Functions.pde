// setGraphData() //////////////////////////////////////////////////////////////////////////////

public void setGraphData(DataFromArduino passedValveData) {
  
  // Graph One
  if (UserSelection.settingTestType == 1) { // Diode Mode
    layersForPlot1 = new GPointsArray[1]; // There's only one layer for diodes
    float[] htValuesForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // temporary float array to subset the info to the right places
    float[] anodeCurrentsForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // ""
    for (int x = 0; x < UserSelection.settingNoOfDataPointsPerSweep; x++) { // I think I can do this with subset() actually - whoops
      htValuesForThisBiasStep[x] = passedValveData.htVoltages[x];
      anodeCurrentsForThisBiasStep[x] = passedValveData.anodeCurrents[x];
    }
    layersForPlot1[0] = new GPointsArray(htValuesForThisBiasStep, anodeCurrentsForThisBiasStep); // We only have one layer for diodes
  } 
  
  else { // Triode or Pentode mode
    layersForPlot1  = new GPointsArray[DataFromArduino.noOfBiasSteps]; // Create the new array of layer points for plot1
    for (int i = 0, y = 0; i < (DataFromArduino.noOfBiasSteps); i++, y += UserSelection.settingNoOfDataPointsPerSweep) {
      float[] htValuesForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // temporary float array to subset the info to the right places
      float[] anodeCurrentsForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // ""
      for (int x = 0; x < UserSelection.settingNoOfDataPointsPerSweep; x++) { // I think I can do this with subset() actually - whoops
        htValuesForThisBiasStep[x] = passedValveData.htVoltages[x+y];
        anodeCurrentsForThisBiasStep[x] = passedValveData.anodeCurrents[x+y];
      }
      layersForPlot1[i] = new GPointsArray(htValuesForThisBiasStep, anodeCurrentsForThisBiasStep); // create the the points array for each graph layer
    }
  }

  // Graph Two
  switch(UserSelection.settingTestType) {
  case 1:
    { // Diode Mode
      layersForPlot2 = new GPointsArray[1]; // There's only one layer for diodes
      float[] htValuesForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // temporary float array to subset the info to the right places
      float[] anodeCurrentsForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // ""
      for (int x = 0; x < UserSelection.settingNoOfDataPointsPerSweep; x++) { // I think I can do this with subset() actually - whoops
        htValuesForThisBiasStep[x] = passedValveData.screenVoltages[x];
        anodeCurrentsForThisBiasStep[x] = passedValveData.screenCurrents[x]; // Yeah, bad naming, I know.
      }
      layersForPlot2[0] = new GPointsArray(htValuesForThisBiasStep, anodeCurrentsForThisBiasStep); // We only have one layer for diodes
    }
    break;
    // I had to add scope to ensure the float arrays are killed
  
  case 2:
    { // Triode Mode
      layersForPlot2  = new GPointsArray[DataFromArduino.noOfBiasSteps]; // Create the new array of layer points for plot2
      for (int i = 0, y = 0; i < (DataFromArduino.noOfBiasSteps); i++, y += UserSelection.settingNoOfDataPointsPerSweep) {
        float[] htValuesForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // temporary float array to subset the info to the right places
        float[] anodeCurrentsForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // ""
        for (int x = 0; x < UserSelection.settingNoOfDataPointsPerSweep; x++) { // I think I can do this with subset() actually - whoops
          htValuesForThisBiasStep[x] = passedValveData.screenVoltages[x+y];
          anodeCurrentsForThisBiasStep[x] = passedValveData.screenCurrents[x+y]; // Yeah, bad naming, I know.
        }
        layersForPlot2[i] = new GPointsArray(htValuesForThisBiasStep, anodeCurrentsForThisBiasStep); // create the the points array for each graph layer
      }
    }
    break;
    //I had to add scope to ensure the float arrays are killed
  
  case 3:
    { // Pentode Mode
      layersForPlot2  = new GPointsArray[DataFromArduino.noOfBiasSteps]; // Create the new array of layer points for plot2
      for (int i = 0, y = 0; i < (DataFromArduino.noOfBiasSteps); i++, y += UserSelection.settingNoOfDataPointsPerSweep) {
        float[] htValuesForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // temporary float array to subset the info to the right places
        float[] screenCurrentsForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // ""
        for (int x = 0; x < UserSelection.settingNoOfDataPointsPerSweep; x++) { // I think I can do this with subset() actually - whoops
          htValuesForThisBiasStep[x] = passedValveData.htVoltages[x+y];
          screenCurrentsForThisBiasStep[x] = passedValveData.screenCurrents[x+y]; // Hooray! the naming works!
        }
        layersForPlot2[i] = new GPointsArray(htValuesForThisBiasStep, screenCurrentsForThisBiasStep); // create the the points array for each graph layer
      }
    }
    break;
    //I had to add scope to ensure the float arrays are killed
    
  case 4:
    {  // Demo Mode (Pentode Mode)
      layersForPlot2  = new GPointsArray[DataFromArduino.noOfBiasSteps]; // Create the new array of layer points for plot2
      for (int i = 0, y = 0; i < (DataFromArduino.noOfBiasSteps); i++, y += UserSelection.settingNoOfDataPointsPerSweep) {
        float[] htValuesForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // temporary float array to subset the info to the right places
        float[] screenCurrentsForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // ""
        for (int x = 0; x < UserSelection.settingNoOfDataPointsPerSweep; x++) { // I think I can do this with subset() actually - whoops
          htValuesForThisBiasStep[x] = passedValveData.htVoltages[x+y];
          screenCurrentsForThisBiasStep[x] = passedValveData.screenCurrents[x+y]; // Hooray! the naming works!
        }
        layersForPlot2[i] = new GPointsArray(htValuesForThisBiasStep, screenCurrentsForThisBiasStep); // create the the points array for each graph layer
      }
   }
   break;
    
  default:
    println("Issue setting graph 2");
    break;
  }

  // Graph Three
  // I only need to make a third layer for pentode mode, as Diode and Triode graphs are easy to make using layersForPlot1 & layersForPlot2
  if (UserSelection.settingTestType == 3 || UserSelection.settingTestType == 4) {
    layersForPlot3 = new GPointsArray[DataFromArduino.noOfBiasSteps];
    for (int i = 0, y = 0; i < (DataFromArduino.noOfBiasSteps); i++, y += UserSelection.settingNoOfDataPointsPerSweep) {
      float[] htValuesForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // temporary float array to subset the info to the right places
      float[] cathodeCurrentsForThisBiasStep = new float[UserSelection.settingNoOfDataPointsPerSweep]; // ""
      for (int x = 0; x < UserSelection.settingNoOfDataPointsPerSweep; x++) { // I think I can do this with subset() actually - whoops
        htValuesForThisBiasStep[x] = passedValveData.htVoltages[x+y];
        cathodeCurrentsForThisBiasStep[x] = (passedValveData.screenCurrents[x + y] + passedValveData.anodeCurrents[x + y]);; //Need to add to get total cathode current
      }
        layersForPlot3[i] = new GPointsArray(htValuesForThisBiasStep, cathodeCurrentsForThisBiasStep); // create the the points array for each graph layer
    }
  }
}

// setupGraph() ///////////////////////////////////////////////////////////

public void setupGraph(DataFromArduino passedValveData) {

  //Plot 1
  switch ( UserSelection.settingTestType) {
  case 1: // Diode Mode
    sideOneOrPentodeAnodePlot = new GPlot(this);
    sideOneOrPentodeAnodePlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    sideOneOrPentodeAnodePlot.setTitleText("Diode Side One Characteristic Plot"); // Title
    sideOneOrPentodeAnodePlot.getXAxis().setAxisLabelText("Anode Voltage V"); // X Axis Label
    sideOneOrPentodeAnodePlot.getYAxis().setAxisLabelText("Anode Current mA"); // Y Axis Label
    sideOneOrPentodeAnodePlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    sideOneOrPentodeAnodePlot.setYLim( 0f, arrayMax(passedValveData.anodeCurrents) + 10f); // Set y limit
    sideOneOrPentodeAnodePlot.setFixedXLim(true);
    sideOneOrPentodeAnodePlot.setFixedYLim(true);
    sideOneOrPentodeAnodePlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    sideOneOrPentodeAnodePlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    sideOneOrPentodeAnodePlot.addPoints(layersForPlot1[0]);
    sideOneOrPentodeAnodePlot.setPointSize(float(graphProperties[4]));
    sideOneOrPentodeAnodePlot.setPointColor(#292929); // Nice Grey for the points
    
    // sideOneOrPentodeAnodePlot.setMar(sideOneOrPentodeAnodePlot.getMar()[0] + 0.5f, sideOneOrPentodeAnodePlot.getMar()[1], 
       //                              sideOneOrPentodeAnodePlot.getMar()[2], sideOneOrPentodeAnodePlot.getMar()[3]);
    // sideOneOrPentodeAnodePlot.setLineColor // I'll keep diode mode with black lines
    break;

  case 2: // Triode Mode
    sideOneOrPentodeAnodePlot = new GPlot(this);
    sideOneOrPentodeAnodePlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    sideOneOrPentodeAnodePlot.setTitleText("Triode Side One Characteristic Plot"); // Title
    sideOneOrPentodeAnodePlot.getXAxis().setAxisLabelText("Anode Voltage V"); // X Axis Label
    sideOneOrPentodeAnodePlot.getYAxis().setAxisLabelText("Anode Current mA"); // Y Axis Label
    sideOneOrPentodeAnodePlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    sideOneOrPentodeAnodePlot.setYLim( 0f, arrayMax(passedValveData.anodeCurrents) + 10f); // Set y limit
    sideOneOrPentodeAnodePlot.setFixedXLim(true);
    sideOneOrPentodeAnodePlot.setFixedYLim(true);
    sideOneOrPentodeAnodePlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    sideOneOrPentodeAnodePlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
  
    // This is needed to give the main layer some data, otherwise the legend looks wrong
    sideOneOrPentodeAnodePlot.addPoints(layersForPlot1[0]);
    sideOneOrPentodeAnodePlot.setPointSize(float(graphProperties[4]));
    sideOneOrPentodeAnodePlot.setPointColor(lineColours[0]);
    sideOneOrPentodeAnodePlot.setLineColor(lineColours[0]);
    // All other layers done with this for loop
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      // if ( i < (DataFromArduino.noOfBiasSteps - 1) {
        sideOneOrPentodeAnodePlot.addLayer(str(passedValveData.biasForEachLayerSide1[i]), layersForPlot1[i]); // Create Layers for each of the bias voltages
     // }
      sideOneOrPentodeAnodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setPointSize(float(graphProperties[4]));
      sideOneOrPentodeAnodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setPointColor(lineColours[i]);
      sideOneOrPentodeAnodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setLineColor(lineColours[i]);
    }
    break;

  case 3: // Pentode Mode
    sideOneOrPentodeAnodePlot = new GPlot(this);
    sideOneOrPentodeAnodePlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    sideOneOrPentodeAnodePlot.setTitleText("Pentode Characteristic Plot"); // Title
    sideOneOrPentodeAnodePlot.getXAxis().setAxisLabelText("Anode Voltage V"); // X Axis Label
    sideOneOrPentodeAnodePlot.getYAxis().setAxisLabelText("Anode Current mA");
    sideOneOrPentodeAnodePlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    sideOneOrPentodeAnodePlot.setYLim( 0f, arrayMax(passedValveData.anodeCurrents) + 30f); // Set y limit, the 30 allows for the legend at the top
    sideOneOrPentodeAnodePlot.setFixedXLim(true);
    sideOneOrPentodeAnodePlot.setFixedYLim(true);
    sideOneOrPentodeAnodePlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    sideOneOrPentodeAnodePlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)    
      
    // This is needed to give the main layer some data, otherwise the legend looks wrong
    sideOneOrPentodeAnodePlot.addPoints(layersForPlot1[0]);
    sideOneOrPentodeAnodePlot.setPointSize(float(graphProperties[4]));
    sideOneOrPentodeAnodePlot.setPointColor(lineColours[0]);
    sideOneOrPentodeAnodePlot.setLineColor(lineColours[0]);
    // All other layers done with this for loop
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      sideOneOrPentodeAnodePlot.addLayer(DataFromArduino.biasForEachLayerSide1String[i], layersForPlot1[i]); // Create Layers for each of the bias voltages
      sideOneOrPentodeAnodePlot.getLayer(DataFromArduino.biasForEachLayerSide1String[i]).setPointSize(float(graphProperties[4]));
      sideOneOrPentodeAnodePlot.getLayer(DataFromArduino.biasForEachLayerSide1String[i]).setPointColor(lineColours[i]);
      sideOneOrPentodeAnodePlot.getLayer(DataFromArduino.biasForEachLayerSide1String[i]).setLineColor(lineColours[i]);
    }
    break;
    
    case 4: // Demo Mode (Pentode Mode)
    sideOneOrPentodeAnodePlot = new GPlot(this); //<>//
    sideOneOrPentodeAnodePlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    sideOneOrPentodeAnodePlot.setTitleText("Pentode Characteristic Plot"); // Title
    sideOneOrPentodeAnodePlot.getXAxis().setAxisLabelText("Anode Voltage V"); // X Axis Label
    sideOneOrPentodeAnodePlot.getYAxis().setAxisLabelText("Anode Current mA");
    sideOneOrPentodeAnodePlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    sideOneOrPentodeAnodePlot.setYLim( 0f, arrayMax(passedValveData.anodeCurrents) + 30f); // Set y limit, the 30 allows for the legend at the top
    sideOneOrPentodeAnodePlot.setFixedXLim(true);
    sideOneOrPentodeAnodePlot.setFixedYLim(true);
    sideOneOrPentodeAnodePlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    sideOneOrPentodeAnodePlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)    
      
    // This is needed to give the main layer some data, otherwise the legend looks wrong
    sideOneOrPentodeAnodePlot.addPoints(layersForPlot1[0]);
    sideOneOrPentodeAnodePlot.setPointSize(float(graphProperties[4]));
    sideOneOrPentodeAnodePlot.setPointColor(lineColours[0]);
    sideOneOrPentodeAnodePlot.setLineColor(lineColours[0]);
    // All other layers done with this for loop
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      sideOneOrPentodeAnodePlot.addLayer(DataFromArduino.biasForEachLayerSide1String[i], layersForPlot1[i]); // Create Layers for each of the bias voltages
      sideOneOrPentodeAnodePlot.getLayer(DataFromArduino.biasForEachLayerSide1String[i]).setPointSize(float(graphProperties[4]));
      sideOneOrPentodeAnodePlot.getLayer(DataFromArduino.biasForEachLayerSide1String[i]).setPointColor(lineColours[i]);
      sideOneOrPentodeAnodePlot.getLayer(DataFromArduino.biasForEachLayerSide1String[i]).setLineColor(lineColours[i]);
    }
    break;  
  }
  
  
  
  
  // Plot 2
  switch (UserSelection.settingTestType) {

  case 1: // Diode Mode
    sideTwoOrPentodeScreenPlot = new GPlot(this);
    sideTwoOrPentodeScreenPlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    sideTwoOrPentodeScreenPlot.setTitleText("Diode Side Two Characteristic Plot"); // Title
    sideTwoOrPentodeScreenPlot.getXAxis().setAxisLabelText("HT Voltage V"); // X Axis Label
    sideTwoOrPentodeScreenPlot.getYAxis().setAxisLabelText("Anode Current mA"); // Y Axis Label
    sideTwoOrPentodeScreenPlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    sideTwoOrPentodeScreenPlot.setYLim( 0f, arrayMax(passedValveData.screenCurrents) + 10f); // Set y limit
    sideTwoOrPentodeScreenPlot.setFixedXLim(true);
    sideTwoOrPentodeScreenPlot.setFixedYLim(true);
    sideTwoOrPentodeScreenPlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    sideTwoOrPentodeScreenPlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    sideTwoOrPentodeScreenPlot.addPoints(layersForPlot1[0]);
    sideTwoOrPentodeScreenPlot.setPointSize(float(graphProperties[4]));
    sideTwoOrPentodeScreenPlot.setPointColor(#292929); // Nice Grey for the points
    // Colour?
    break;

  case 2: // Triode Mode
    sideTwoOrPentodeScreenPlot = new GPlot(this);
    sideTwoOrPentodeScreenPlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    sideTwoOrPentodeScreenPlot.setTitleText("Triode Side Two Characteristic Plot"); // Title
    sideTwoOrPentodeScreenPlot.getXAxis().setAxisLabelText("HT Voltage V"); // X Axis Label
    sideTwoOrPentodeScreenPlot.getYAxis().setAxisLabelText("Anode Current mA"); // Y Axis Label
    sideTwoOrPentodeScreenPlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    sideTwoOrPentodeScreenPlot.setYLim( 0f, arrayMax(passedValveData.screenCurrents) + 10f); // Set y limit
    sideTwoOrPentodeScreenPlot.setFixedXLim(true);
    sideTwoOrPentodeScreenPlot.setFixedYLim(true);
    sideTwoOrPentodeScreenPlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    sideTwoOrPentodeScreenPlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    
     // This is needed to give the main layer some data, otherwise the legend looks wrong
    sideTwoOrPentodeScreenPlot.addPoints(layersForPlot2[0]);
    sideTwoOrPentodeScreenPlot.setPointSize(float(graphProperties[4]));
    sideTwoOrPentodeScreenPlot.setPointColor(lineColours[0]);
    sideTwoOrPentodeScreenPlot.setLineColor(lineColours[0]);
    // All other layers done with this for loop
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      sideTwoOrPentodeScreenPlot.addLayer(str(passedValveData.biasForEachLayerSide2[i]), layersForPlot2[i]); // Create Layers for each of the bias voltages
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setPointSize(float(graphProperties[4]));
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setPointColor(lineColours[i]);
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setLineColor(lineColours[i]);
    }
    break;

  case 3: // Pentode Mode
    sideTwoOrPentodeScreenPlot = new GPlot(this);
    sideTwoOrPentodeScreenPlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    sideTwoOrPentodeScreenPlot.setTitleText("Screen Characteristic Plot"); // Title
    sideTwoOrPentodeScreenPlot.getXAxis().setAxisLabelText("Anode Voltage V"); // X Axis Label
    sideTwoOrPentodeScreenPlot.getYAxis().setAxisLabelText("Screen Current mA"); // Y Axis Label
    sideTwoOrPentodeScreenPlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    sideTwoOrPentodeScreenPlot.setYLim( 0f, arrayMax(passedValveData.screenCurrents) + 10f); // Set y limit
    sideTwoOrPentodeScreenPlot.setFixedXLim(true);
    sideTwoOrPentodeScreenPlot.setFixedYLim(true);
    sideTwoOrPentodeScreenPlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    sideTwoOrPentodeScreenPlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    
     // This is needed to give the main layer some data, otherwise the legend looks wrong
    sideTwoOrPentodeScreenPlot.addPoints(layersForPlot2[0]);
    sideTwoOrPentodeScreenPlot.setPointSize(float(graphProperties[4]));
    sideTwoOrPentodeScreenPlot.setPointColor(lineColours[0]);
    sideTwoOrPentodeScreenPlot.setLineColor(lineColours[0]);
    // All other layers done with this for loop
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      sideTwoOrPentodeScreenPlot.addLayer(str(passedValveData.biasForEachLayerSide2[i]), layersForPlot2[i]); // Create Layers for each of the bias voltages
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setPointSize(float(graphProperties[4]));
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setPointColor(lineColours[i]);
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setLineColor(lineColours[i]);
    }
    break;
    
    case 4: // Demo Mode (Pentode Mode)
    sideTwoOrPentodeScreenPlot = new GPlot(this);
    sideTwoOrPentodeScreenPlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    sideTwoOrPentodeScreenPlot.setTitleText("Screen Characteristic Plot"); // Title
    sideTwoOrPentodeScreenPlot.getXAxis().setAxisLabelText("Anode Voltage V"); // X Axis Label
    sideTwoOrPentodeScreenPlot.getYAxis().setAxisLabelText("Screen Current mA"); // Y Axis Label
    sideTwoOrPentodeScreenPlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    sideTwoOrPentodeScreenPlot.setYLim( 0f, arrayMax(passedValveData.screenCurrents) + 10f); // Set y limit
    sideTwoOrPentodeScreenPlot.setFixedXLim(true);
    sideTwoOrPentodeScreenPlot.setFixedYLim(true);
    sideTwoOrPentodeScreenPlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    sideTwoOrPentodeScreenPlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    
     // This is needed to give the main layer some data, otherwise the legend looks wrong
    sideTwoOrPentodeScreenPlot.addPoints(layersForPlot2[0]);
    sideTwoOrPentodeScreenPlot.setPointSize(float(graphProperties[4]));
    sideTwoOrPentodeScreenPlot.setPointColor(lineColours[0]);
    sideTwoOrPentodeScreenPlot.setLineColor(lineColours[0]);
    // All other layers done with this for loop
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      sideTwoOrPentodeScreenPlot.addLayer(str(passedValveData.biasForEachLayerSide2[i]), layersForPlot2[i]); // Create Layers for each of the bias voltages
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setPointSize(float(graphProperties[4]));
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setPointColor(lineColours[i]);
      sideTwoOrPentodeScreenPlot.getLayer(str(passedValveData.biasForEachLayerSide2[i])).setLineColor(lineColours[i]);
    }
    break; 
  }
  
  // Plot 3
  switch (UserSelection.settingTestType) {
  case 1: // Diode Mode
    bothOrPentodeCathodePlot = new GPlot(this);
    bothOrPentodeCathodePlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    bothOrPentodeCathodePlot.setTitleText("Diode Characteristic Plot (Both)"); // Title
    bothOrPentodeCathodePlot.getXAxis().setAxisLabelText("HT Voltage V"); // X Axis Label
    bothOrPentodeCathodePlot.getYAxis().setAxisLabelText("Anode Current mA"); // Y Axis Label
    bothOrPentodeCathodePlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    {
      float maxCurrent;
      if ( arrayMax(passedValveData.screenCurrents) < arrayMax(passedValveData.anodeCurrents) ) {
        maxCurrent = arrayMax(passedValveData.anodeCurrents);
      } else {
        maxCurrent = arrayMax(passedValveData.screenCurrents);
      }
      bothOrPentodeCathodePlot.setYLim( 0f, maxCurrent + 10f); // Set y limits
    }
    bothOrPentodeCathodePlot.setFixedXLim(true);
    bothOrPentodeCathodePlot.setFixedYLim(true);
    bothOrPentodeCathodePlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    bothOrPentodeCathodePlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    bothOrPentodeCathodePlot.addPoints(layersForPlot1[0]);
    bothOrPentodeCathodePlot.addLayer("Diode Two", layersForPlot2[0]);
    bothOrPentodeCathodePlot.setPointSize(float(graphProperties[4]));
    bothOrPentodeCathodePlot.setPointColor(lineColours[0]);
    bothOrPentodeCathodePlot.setLineColor(lineColours[0]);
    bothOrPentodeCathodePlot.getLayer("Diode Two").setPointColor(lineColours[1]);
    bothOrPentodeCathodePlot.getLayer("Diode Two").setLineColor(lineColours[1]);
    
    break;

  case 2: // Triode Mode
    bothOrPentodeCathodePlot = new GPlot(this);
    bothOrPentodeCathodePlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    bothOrPentodeCathodePlot.setTitleText("Characteristic Plot (Both)"); // Title
    bothOrPentodeCathodePlot.getXAxis().setAxisLabelText("HT Voltage V"); // X Axis Label
    bothOrPentodeCathodePlot.getYAxis().setAxisLabelText("Anode Current mA"); // Y Axis Label
    bothOrPentodeCathodePlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    {
      float maxCurrent;
      if ( arrayMax(passedValveData.screenCurrents) < arrayMax(passedValveData.anodeCurrents) ) {
        maxCurrent = arrayMax(passedValveData.anodeCurrents);
      } else {
        maxCurrent = arrayMax(passedValveData.screenCurrents);
      }
      bothOrPentodeCathodePlot.setYLim( 0f, maxCurrent + 10f); // Set y limits
    }
    bothOrPentodeCathodePlot.setFixedXLim(true);
    bothOrPentodeCathodePlot.setFixedYLim(true);
    bothOrPentodeCathodePlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    bothOrPentodeCathodePlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    
    bothOrPentodeCathodePlot.addPoints(layersForPlot1[0]);
    bothOrPentodeCathodePlot.setPointSize(float(graphProperties[4]));
    bothOrPentodeCathodePlot.setPointColor(lineColours[0]);
    bothOrPentodeCathodePlot.setLineColor(lineColours[0]);
    bothOrPentodeCathodePlot.setLineWidth(3f);
    
    bothOrPentodeCathodePlot.addLayer(passedValveData.biasForEachLayerSide2[0] + "Side Two", layersForPlot2[0]);
    bothOrPentodeCathodePlot.getLayer(passedValveData.biasForEachLayerSide2[0] + "Side Two").setPointSize(float(graphProperties[4]));
    bothOrPentodeCathodePlot.getLayer(passedValveData.biasForEachLayerSide2[0] + "Side Two").setPointColor(lineColours[0]);
    bothOrPentodeCathodePlot.getLayer(passedValveData.biasForEachLayerSide2[0] + "Side Two").setLineColor(lineColours[0]);
    bothOrPentodeCathodePlot.getLayer(passedValveData.biasForEachLayerSide2[0] + "Side Two").setLineWidth(2f);
    
    
    
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      bothOrPentodeCathodePlot.addLayer(str(passedValveData.biasForEachLayerSide1[i]), layersForPlot1[i]); // Create Layers for each of the bias voltages
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setPointSize(float(graphProperties[4]));
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setPointColor(lineColours[i]);
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setLineColor(lineColours[i]);
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setLineWidth(2f);
      
      String temp = str(passedValveData.biasForEachLayerSide2[i]) + "Side Two";
      bothOrPentodeCathodePlot.addLayer(temp, layersForPlot2[i]); // "Side Two" avoids duplicates for side 1's layers
      bothOrPentodeCathodePlot.addLayer(passedValveData.biasForEachLayerSide2[i] + "Side Two", layersForPlot2[i]);
      bothOrPentodeCathodePlot.getLayer(passedValveData.biasForEachLayerSide2[i] + "Side Two").setPointSize(float(graphProperties[4]));
      bothOrPentodeCathodePlot.getLayer(passedValveData.biasForEachLayerSide2[i] + "Side Two").setPointColor(lineColours[i]);
      bothOrPentodeCathodePlot.getLayer(passedValveData.biasForEachLayerSide2[i] + "Side Two").setLineColor(lineColours[i]);
      bothOrPentodeCathodePlot.getLayer(passedValveData.biasForEachLayerSide2[i] + "Side Two").setLineWidth(2f);
      
      // Change colours and thickness etc.
      
    }
    break;

  case 3: // Pentode Mode
    bothOrPentodeCathodePlot = new GPlot(this);
    bothOrPentodeCathodePlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    bothOrPentodeCathodePlot.setTitleText("Cathode Characteristic Plot"); // Title
    bothOrPentodeCathodePlot.getXAxis().setAxisLabelText("Anode Voltage V"); // X Axis Label
    bothOrPentodeCathodePlot.getYAxis().setAxisLabelText("Cathode Current mA"); // Y Axis Label
    bothOrPentodeCathodePlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    {
      float maxCurrent = arrayMax(passedValveData.anodeCurrents) + 20f;
      bothOrPentodeCathodePlot.setYLim( 0f, maxCurrent + 10f); // Set y limits
    }
    bothOrPentodeCathodePlot.setFixedXLim(true);
    bothOrPentodeCathodePlot.setFixedYLim(true);
    bothOrPentodeCathodePlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    bothOrPentodeCathodePlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    
    // This is needed to give the main layer some data, otherwise the legend looks wrong
    bothOrPentodeCathodePlot.addPoints(layersForPlot3[0]);
    bothOrPentodeCathodePlot.setPointSize(float(graphProperties[4]));
    bothOrPentodeCathodePlot.setPointColor(lineColours[0]);
    bothOrPentodeCathodePlot.setLineColor(lineColours[0]);
    // All other layers done with this for loop
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      bothOrPentodeCathodePlot.addLayer(str(passedValveData.biasForEachLayerSide1[i]), layersForPlot3[i]); // Create Layers for each of the bias voltages
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setPointSize(float(graphProperties[4]));
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setPointColor(lineColours[i]);
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setLineColor(lineColours[i]);
    }
    break;
    
    case 4: // Demo mode (Pentode Mode)
    bothOrPentodeCathodePlot = new GPlot(this);
    bothOrPentodeCathodePlot.setPos(float(graphProperties[0]), float(graphProperties[1])); // Set the screen XY position for the graph
    bothOrPentodeCathodePlot.setTitleText("Cathode Characteristic Plot"); // Title
    bothOrPentodeCathodePlot.getXAxis().setAxisLabelText("Anode Voltage V"); // X Axis Label
    bothOrPentodeCathodePlot.getYAxis().setAxisLabelText("Cathode Current mA"); // Y Axis Label
    bothOrPentodeCathodePlot.setXLim( 0f, float(UserSelection.settingMaxAnodeVolts)); // Set x limit to the max Anode value - float(UserSelection.settingMaxAnodeVolts)
    {
      float maxCurrent = arrayMax(passedValveData.anodeCurrents) + 20f;
      bothOrPentodeCathodePlot.setYLim( 0f, maxCurrent + 10f); // Set y limits
    }
    bothOrPentodeCathodePlot.setFixedXLim(true);
    bothOrPentodeCathodePlot.setFixedYLim(true);
    bothOrPentodeCathodePlot.getXAxis().setNTicks(10); // Number of guiding ticks on the X axis, one every 50 Volts
    bothOrPentodeCathodePlot.setOuterDim(float(graphProperties[2]), float(graphProperties[3])); // Set x,y graph dimensions (Size on the screen)
    
    // This is needed to give the main layer some data, otherwise the legend looks wrong
    bothOrPentodeCathodePlot.addPoints(layersForPlot3[0]);
    bothOrPentodeCathodePlot.setPointSize(float(graphProperties[4]));
    bothOrPentodeCathodePlot.setPointColor(lineColours[0]);
    bothOrPentodeCathodePlot.setLineColor(lineColours[0]);
    // All other layers done with this for loop
    for (int i = 1; i < DataFromArduino.noOfBiasSteps; i++) {
      bothOrPentodeCathodePlot.addLayer(str(passedValveData.biasForEachLayerSide1[i]), layersForPlot3[i]); // Create Layers for each of the bias voltages
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setPointSize(float(graphProperties[4]));
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setPointColor(lineColours[i]);
      bothOrPentodeCathodePlot.getLayer(str(passedValveData.biasForEachLayerSide1[i])).setLineColor(lineColours[i]);
    }
    break;
  }
}
