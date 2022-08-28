// createSampleData() /////////////////////////////////////////////////////////////////////////
// Used to sort some sample data
public DataFromArduino createSampleData() {
  // These values are all taken from Merlin's Spreadsheet, I think they're EL84 values.

  float[] merlinsHTVoltages = { 0f, 6.63f, 16.87f, 28.31f, 39.76f, 51.81f, 66.27f, 81.93f, 98.8f, 118.07f, 141.57f, 168.07f, 200.6f,
    243.37f, 303.61f, 404.82f, 0f, 7.23f, 17.47f, 26.51f, 38.55f, 51.81f, 65.06f, 81.33f, 99.4f, 118.67f,
    139.76f, 167.47f, 201.81f, 243.37f, 303.01f, 404.22f, 0f, 7.23f, 16.27f, 26.51f, 39.16f, 51.81f, 66.87f,
    81.33f, 100f, 116.87f, 139.76f, 168.67f, 201.2f, 243.37f, 303.01f, 404.22f, 0f, 7.83f, 18.07f, 29.52f, 40.36f,
    53.61f, 67.47f, 81.93f, 99.4f, 118.07f, 142.17f, 168.07f, 201.2f, 243.98f, 303.01f, 404.22f, 0f, 6.63f, 17.47f,
    27.71f, 39.76f, 51.2f, 66.27f, 81.33f, 98.8f, 119.28f, 141.57f, 168.07f, 201.2f, 243.98f, 303.01f, 404.22f, 0f,
    6.63f, 16.27f, 27.71f, 39.76f, 52.41f, 65.66f, 82.53f, 100f, 118.07f, 141.57f, 167.47f, 201.2f, 243.37f, 303.61f,
    404.22f, 0f, 7.23f, 16.27f, 27.71f, 40.96f, 53.61f, 67.47f, 80.72f, 99.4f, 119.28f, 142.17f, 168.67f, 201.2f, 243.98f,
    303.01f, 404.22f, 0f, 6.02f, 17.47f, 29.52f, 40.96f, 54.22f, 68.07f, 83.13f, 100f, 119.88f, 142.17f, 168.67f, 202.41f,
    243.98f, 303.61f, 404.22f, 0f, 8.43f, 19.28f, 29.52f, 41.57f, 51.2f, 66.27f, 82.53f, 99.4f, 119.88f, 140.96f, 169.28f,
    200.6f, 243.98f, 303.61f, 404.22f, 0f, 7.83f, 18.07f, 28.92f, 40.96f, 54.82f, 68.07f, 82.53f, 100f, 118.67f, 140.36f,
    168.67f, 201.2f, 243.37f, 303.61f, 404.22f, 0f, 7.83f, 16.87f, 30.12f, 41.57f, 54.82f, 65.66f, 83.13f, 100f, 118.07f, 142.17f,
    168.07f, 202.41f, 243.37f, 303.61f, 404.22f }; // HT Voltages

  float[] merlinsAnodeCurrents = { 1.26f, 38.78f, 73.61f, 94.55f, 105.33f, 111.91f, 116.7f, 119.09f, 121.48f, 122.68f, 126.27f, 128.07f, 130.46f,
    133.45f, 136.45f, 141.83f, 0.78f, 41.71f, 63.44f, 73.61f, 81.39f, 86.18f, 90.37f, 92.16f, 94.55f, 96.35f, 98.14f,
    99.94f, 101.14f, 104.73f, 107.12f, 111.91f, 0.42f, 39.5f, 49.67f, 56.85f, 59.84f, 64.03f, 67.62f, 70.02f, 71.81f,
    73.61f, 74.81f, 77.2f, 77.8f, 80.19f, 81.99f, 85.58f, 0.6f, 31.36f, 37.46f, 41.29f, 43.27f, 45.6f, 48f, 49.55f,
    51.47f, 52.66f, 53.26f, 54.46f, 55.06f, 57.45f, 59.25f, 62.84f, 0.96f, 19.93f, 23.88f, 25.61f, 26.57f, 28.43f, 30.4f,
    32.2f, 33.27f, 34.29f, 35.01f, 35.79f, 36.8f, 38.3f, 39.8f, 42.49f, 1.08f, 12.21f, 13.64f, 14.6f, 15.08f, 15.74f,
    17.77f, 18.97f, 19.75f, 19.99f, 20.95f, 21.01f, 21.66f, 22.98f, 24.3f, 26.21f, 0.6f, 6.46f, 6.94f, 7.48f, 7.84f, 8.08f,
    8.5f, 9.04f, 9.87f, 10.05f, 10.35f, 10.83f, 11.19f, 12.03f, 12.93f, 14.3f, 0.18f, 2.75f, 2.81f, 3.17f, 3.29f, 3.35f,
    3.41f, 3.95f, 4.07f, 4.25f, 4.55f, 4.67f, 5.09f, 5.45f, 5.92f, 6.76f, 0.06f, 1.02f, 1.14f, 1.14f, 1.2f, 1.2f, 1.32f,
    1.44f, 1.5f, 1.74f, 1.68f, 1.97f, 1.97f, 2.21f, 2.51f, 2.99f, 0f, 0.3f, 0.3f, 0.42f, 0.42f, 0.36f, 0.42f, 0.48f, 0.48f,
    0.6f, 0.72f, 0.78f, 0.78f, 0.9f, 0.96f, 1.32f, 0f, 0f, 0f, 0f, 0.06f, 0.06f, 0.12f, 0.12f, 0.12f, 0.18f, 0.18f, 0.18f, 0.3f,
    0.36f, 0.42f, 0.6f }; //Anode Currents

  float[] merlinsBiasVoltages = { 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, 0f, -2f, -2f, -2f, -2f, -2f, -2f, -2f, -2f, -2f, -2f, -2f, -2f,
    -2f, -2f, -2f, -2f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f, -4.01f,
    -4.01f, -4.01f, -4.01f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f, -5.99f,
    -5.99f, -5.99f, -5.99f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -8f, -10f, -10f, -10f, -10f,
    -10f, -10f, -10f, -10f, -10f, -10f, -10f, -10f, -10f, -10f, -10f, -10f, -12f, -12f, -12f, -12f, -12f, -12f, -12f, -12f, -12f, -12f,
    -12f, -12f, -12f, -12f, -12f, -12f, -14.01f, -14.01f, -14.01f, -14.01f, -14.01f, -14.01f, -14.01f, -14.01f, -14.01f, -14.01f, -14.01f,
    -14.01f, -14.01f, -14.01f, -14.01f, -14.01f, -15.99f, -15.99f, -15.99f, -15.99f, -15.99f, -15.99f, -15.99f, -15.99f, -15.99f, -15.99f,
    -15.99f, -15.99f, -15.99f, -15.99f, -15.99f, -15.99f, -18f, -18f, -18f, -18f, -18f, -18f, -18f, -18f, -18f, -18f, -18f, -18f, -18f,
    -18f, -18f, -18f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f, -20f }; // Bias Voltages

  float[] merlinsSecondaryBiasVoltages = new float[176];
  for ( int i = 0; i < 176; i++) {
    merlinsSecondaryBiasVoltages[i] = 0f;
  }

  float[] merlinsScreenVoltages = { 248.19f, 249.4f, 249.4f, 250f, 251.2f, 250.6f, 251.2f, 251.81f, 251.2f, 251.81f, 251.2f, 250.6f, 251.2f, 253.01f, 253.01f,
    253.01f, 249.4f, 251.81f, 250.6f, 250.6f, 251.2f, 250.6f, 251.2f, 251.2f, 251.81f, 251.81f, 251.81f, 252.41f, 251.2f, 253.01f,
    253.61f, 253.01f, 250f, 253.61f, 253.01f, 251.81f, 251.81f, 251.2f, 251.2f, 251.81f, 253.01f, 253.01f, 252.41f, 253.01f, 252.41f,
    253.01f, 253.61f, 253.01f, 250.6f, 253.01f, 253.01f, 254.22f, 253.01f, 252.41f, 253.01f, 251.2f, 251.81f, 251.81f, 253.01f,
    252.41f, 251.81f, 253.61f, 253.01f, 253.61f, 251.2f, 251.2f, 251.2f, 251.81f, 251.2f, 250.6f, 253.01f, 252.41f, 252.41f, 252.41f,
    251.2f, 252.41f, 251.81f, 253.61f, 253.61f, 253.61f, 251.81f, 252.41f, 251.81f, 251.81f, 252.41f, 252.41f, 253.01f, 253.61f,
    254.22f, 252.41f, 253.01f, 252.41f, 252.41f, 253.61f, 253.61f, 253.61f, 251.81f, 251.81f, 251.81f, 252.41f, 253.01f, 253.01f,
    253.01f, 253.01f, 251.81f, 253.01f, 253.01f, 253.01f, 251.81f, 253.01f, 253.61f, 253.61f, 252.41f, 253.01f, 251.81f, 254.22f,
    253.01f, 253.61f, 253.61f, 253.01f, 253.01f, 251.81f, 252.41f, 253.01f, 253.61f, 253.61f, 253.61f, 253.61f, 252.41f, 254.22f,
    253.01f, 254.22f, 254.22f, 254.22f, 253.61f, 252.41f, 253.01f, 252.41f, 251.81f, 252.41f, 253.61f, 253.61f, 253.61f, 253.61f,
    252.41f, 252.41f, 253.01f, 253.61f, 254.82f, 254.22f, 254.82f, 254.22f, 254.22f, 252.41f, 253.61f, 251.81f, 251.81f, 253.61f,
    253.01f, 253.61f, 252.41f, 252.41f, 251.81f, 253.61f, 253.61f, 254.22f, 253.61f, 254.22f, 253.61f, 253.01f, 253.01f, 253.01f,
    253.01f, 253.61f, 253.61f, 253.61f }; // Screen Voltages

  float[] merlinsScreenCurrents = { 95.75f, 67.62f, 46.74f, 34.47f, 27.95f, 24.06f, 21.54f, 19.87f, 18.91f, 17.95f, 17.12f, 16.58f, 15.92f, 15.44f, 14.6f, 13.41f,
    73.61f, 44.58f, 32.08f, 25.91f, 21.96f, 19.21f, 16.94f, 15.74f, 14.6f, 13.88f, 13.41f, 12.69f, 12.33f, 11.91f, 11.37f, 10.47f,
    53.86f, 28.49f, 23.16f, 19.63f, 16.82f, 14.9f, 13.11f, 12.03f, 11.07f, 10.71f, 10.11f, 9.87f, 9.4f, 9.1f, 8.62f, 7.96f, 37.52f,
    18.37f, 15.86f, 14f, 12.63f, 11.37f, 9.69f, 8.56f, 7.9f, 7.6f, 7.12f, 6.76f, 6.58f, 6.46f, 6.16f, 5.69f, 24.3f, 11.73f, 9.75f, 9.22f,
    8.68f, 7.78f, 6.64f, 5.86f, 5.15f, 4.79f, 4.67f, 4.37f, 4.43f, 4.25f, 4.01f, 3.83f, 14.3f, 6.52f, 5.69f, 5.39f, 5.21f, 4.91f, 4.13f,
    3.59f, 3.17f, 2.75f, 2.69f, 2.57f, 2.57f, 2.45f, 2.39f, 2.33f, 7.48f, 3.17f, 2.75f, 2.57f, 2.75f, 2.45f, 2.09f, 1.74f, 1.56f, 1.38f,
    1.32f, 1.32f, 1.2f, 1.32f, 1.26f, 1.08f, 3.35f, 1.44f, 1.08f, 1.02f, 1.14f, 1.26f, 0.96f, 0.66f, 0.66f, 0.54f, 0.54f, 0.48f, 0.6f,
    0.6f, 0.48f, 0.54f, 1.2f, 0.54f, 0.42f, 0.54f, 0.36f, 0.36f, 0.36f, 0.42f, 0.24f, 0.18f, 0.3f, 0.18f, 0.24f, 0.3f, 0.3f, 0.24f,
    0.48f, 0.18f, 0.06f, 0.24f, 0.06f, 0f, 0.18f, 0f, 0.12f, 0f, 0.12f, 0.06f, 0f, 0f, 0.12f, 0.12f, 0.18f, 0.06f, 0f, 0.06f, 0.06f,
    0.06f, 0.06f, 0f, 0.12f, 0f, 0f, 0f, 0.06f, 0.06f, 0f, 0f }; // Screen Currents

  // Create the sample object
  merlinsSample = new DataFromArduino(merlinsHTVoltages, merlinsAnodeCurrents, merlinsBiasVoltages, merlinsSecondaryBiasVoltages, merlinsScreenVoltages, merlinsScreenCurrents);
  return merlinsSample;
}

/* Unassorted shite that might be useful

// Class I started early on but decided against - Test data should be an instance of the real data class
// Look at it there sitting all abandoned, aww.
public class tempTestData {
  temp = Float.toString(theBiasValues[i]);
  int tempDataSizeForMerlinsSampleData = 176; // currently populating with temp data taken from Merlin's spreadsheet
  float[] theBiasValues = {0f, -2f, -4.01f, -5.99f, -8f, -10f, -12f, 14.1f, -15.99f, -18f, -20f}; // taken from Merlin's data

  public void createDataArray() {
    float[] merlinsBiasValues = new float[tempDataSizeForMerlinsSampleData];
    for (int i = 0; i < 11; i++) {
      for (int y = 0; y < 16; y++) {
        merlinsBiasValues[16*i+y] = theBiasValues[i]; // Get the right Bias value in all 176 datapoints
      }
    }

    MeasuredValveData[] dataArray = new MeasuredValveData[tempDataSizeForMerlinsSampleData]; // Use UserSelection.settingNoOfDataPoints for real thing
    for (int i = 0; i < tempDataSizeForMerlinsSampleData; i++) {
      dataArray[i] = new MeasuredValveData(merlinsHTValuesArray[i], merlinsAnodeCurrentValuesArray[i], merlinsBiasValues[i],
        merlinsScreenVoltageValuesArray[i], merlinsScreenCurrentValuesArray[i]);
    }
  }
}
*/

/* Simple Slope Graph for testing grafica
 for (int i = 0; i < nPoints; i++) {
 points.add( i, (2*i + 1));
 }
 sideOneOrPentodeAnodePlot.setPoints(points); // Add the points
 */

/* Set of print statements (debugging)
 println(splitValues[0]);
 println(splitValues[1]);
 println(splitValues[2]);
 println(splitValues[3]);
 println(splitValues[4]);
 println(splitValues[5]);
 */
 
/* Some other colours I sorted
color[] darkerLineColours = {#800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080,
  #800000, #808000, #008000, #008080, #000080, #800080, #800000, #808000, #008000, #008080, #000080, #800080};
*/

/*
 //Easy User Settings - temporary measure to get sample data working
 UserSelection.settingNoOfDataPointsPerSweep = 16;
 UserSelection.settingBiasSet = -20.00f;
 UserSelection.settingBiasStep = -2.00f;
*/
