// Classes ////////////////////////////////////////////////////////////////////// //<>//

// Measurements returned from the Arduino will be stored here
public static class DataFromArduino {
  float[] htVoltages;
  float[] anodeCurrents;
  float[] actualBiasGridOne;
  float[] actualBiasGridTwo;
  float[] screenVoltages;
  float[] screenCurrents;
  float[] biasForEachLayerSide1; // calculated value
  float[] biasForEachLayerSide2;

  // These are used with the graph
  static String[] biasForEachLayerSide1String;
  static String[] biasForEachLayerSide2String;
  static float[] legendX;
  static float[] legendY;

  static int noOfBiasSteps = 0; // not technically returned from the Arduino but useful for setting up things
  static int noOfDataPoints = 0; // ""

  // Constructer

  DataFromArduino(float[] htVoltages, float[] anodeCurrents, float[] actualBias, float[] actualBias2, float[] screenVoltages, float[] screenCurrents) {
    this.htVoltages = htVoltages;
    this.anodeCurrents = anodeCurrents;
    this.actualBiasGridOne = actualBias;
    this.actualBiasGridTwo = actualBias2;
    this.screenVoltages = screenVoltages;
    this.screenCurrents = screenCurrents;

    if (UserSelection.settingTestType > 1) { // Only for valves that have grids!
      this.biasForEachLayerSide1 = new float[DataFromArduino.noOfBiasSteps];
      this.biasForEachLayerSide2 = new float[DataFromArduino.noOfBiasSteps];
      biasForEachLayerSide1String = new String[DataFromArduino.noOfBiasSteps];
      biasForEachLayerSide2String = new String[DataFromArduino.noOfBiasSteps];
      legendX = new float[DataFromArduino.noOfBiasSteps];
      legendY = new float[DataFromArduino.noOfBiasSteps];

      for (int i = 0; i < DataFromArduino.noOfBiasSteps; i++) {
        this.biasForEachLayerSide1[i] = this.actualBiasGridOne[(i * UserSelection.settingNoOfDataPointsPerSweep) + 1];
      }

      if (UserSelection.settingTestType == 3 || UserSelection.settingTestType == 4) { // If we're in pentode mode
        this.biasForEachLayerSide2 = this.biasForEachLayerSide1;
      } else { // Triode or Diode Mode
        for (int i = 0; i < DataFromArduino.noOfBiasSteps; i++) {
          this.biasForEachLayerSide2[i] = this.actualBiasGridTwo[(i * UserSelection.settingNoOfDataPointsPerSweep) + 1];
        } // End for
      } // End else

      for (int i = 0, x = 0; i < DataFromArduino.noOfBiasSteps; i++) {
        DataFromArduino.biasForEachLayerSide1String[i] = str(this.biasForEachLayerSide1[i]);
        DataFromArduino.biasForEachLayerSide2String[i] = str(this.biasForEachLayerSide2[i]);
        if ( i < 6) {
          DataFromArduino.legendX[i] = 0.07f + ((float(i))/6);
          DataFromArduino.legendY[i] = 0.97f;
        } else {
          DataFromArduino.legendX[i] = 0.07f + ((float(x))/6);
          DataFromArduino.legendY[i] = 0.91f;
          x++;
        }
      } // End for
    } // End if
  } // End Constructer
} // End Class

// User Selection Data
static public class UserSelection {
  static String comPort = ""; // Arduino COM Port
  static int settingTestType = 1;
  static float settingHeaterVolts = 0; // User selected Heater Voltage
  static int settingMaxAnodeVolts = 0; // User selected Anode Voltage
  static int settingNoOfDataPointsPerSweep = 2; // User selected number of data points for the sweep
  static float settingBiasSet = -0f; // User selected bias range
  static float settingBiasStep = -0f; // User selected bias step
  static int settingScreenVolts = 0; // User selected secondary HT supply voltage
  static int settingUlPercent = 0; // User selected Triode strapping percentage
  static float settingSecondaryGridBias = -0f; // User selected secondary bias voltage
}
