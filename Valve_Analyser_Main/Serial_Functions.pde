// intialiseReadyForSubmit()
// This is called in the Submit Button Event Handler prior to passing the values
public boolean intialiseReadyForSubmit() {

  // First, let's update the values needed for the run button
  // The Arduino does this with a for loop, never calculating the actual value
  DataFromArduino.noOfBiasSteps = (int)((UserSelection.settingBiasSet /  UserSelection.settingBiasStep) + 1);
  DataFromArduino.noOfDataPoints = (DataFromArduino.noOfBiasSteps * UserSelection.settingNoOfDataPointsPerSweep);

  printInfo("Attempting to connect");
  int attempts = 0;
  while (true) {
    if (submitWentWell == false) {
      arduinoPort = new Serial(this, UserSelection.comPort, 9600); // Start Serial Comms for the first time
    } else {
      // Initialisation has already been set up
      arduinoPort.stop(); // stop the port so I can reinitialise
      delay(100);
      {
        arduinoPort = null;
      } // really make sure the port is killed, added scope ensures GC will pick it up
      delay(100);
      arduinoPort = new Serial(this, UserSelection.comPort, 9600); //  Start comms again, this Resets the Arduino via the DTR line
      delay(100);
    }
    printInfo("Initialising the Arduino");
    arduinoPort.clear(); // Clear the buffer prior to the reset to clear any rubbish
    delay(3000); // Wait for the arduino to reset
    if (arduinoPort.available() > 0) {
      String temp = arduinoPort.readString();
      // Checks to see if the Arduino has sent the right initial message
      boolean goodRead = temp.equals("Select test mode:\r\n[Diode / double diode = 1;\r\nTriode / double triode = 2;\r\nTetrode / pentode = 3]\r\n");
      if (goodRead) {
        println(temp); // Shows it on the console
        return true; // Function returns true to tell us initialisation success
      }
      // I might be able to kill this code, as I get errors when serial won't initalise anyways, and it never reaches here
      else { // Something went wrong and we need to reinitialise
        printInfo("Error! Will try again"); // Visual warning
        println(temp); // Show me what it got that was wrong - helps to debug
        attempts++;
        if ( attempts == 3 ) {
          // Lets us know it didn't work every time and escapes the loop
          printInfo("Something went wrong with connecting to the Arduino");
          return false; // Function returns false to tell us initialisation fail
        } else { // try again (3 times)
          continue;
        }
      }
    }
  }
}

// submitValuesToArduino() //////////////////////////////////////////////////
// This is called in the Submit Button Event Handler after initialisation is done
public boolean submitValuesToArduino(Serial arduinoPort) {
  String temp; // Holds the read string
  String formatTemp; // Holds a formatted version of UserSelection's float atrributes for checks
  boolean goodRead; // Used to check if what was read was correct

  // Sending the mode information
  printInfo("Sending setting 1");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(UserSelection.settingTestType)); // Send the test type data
  delay(300); // Wait for the Arduino to comprehend and send the next request
  temp = arduinoPort.readString(); // Read the next part
  goodRead = temp.equals(str(UserSelection.settingTestType) + "\r\nSet heater to: [up to 24V]\r\n");

  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  }
  println(temp); // Print to the console so I can track
  temp = null;

  // Send the heater volts information
  printInfo("Sending setting 2");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(UserSelection.settingHeaterVolts)); // send the Heater Volts Information
  delay(300); // Wait for the Arduino to comprehend and send the next request
  formatTemp = String.format("%.2f", UserSelection.settingHeaterVolts); // Formats so the string is 2dp for the comparison
  temp = arduinoPort.readString(); // Read the next part
  goodRead = temp.equals(formatTemp + " V\r\nSweep anode(s) from 0V up to: [up to 500V]\r\n");
  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  }
  println(temp); // Print to the console so I can track
  temp = null;

  // Send the HT supply sweep information
  printInfo("Sending setting 3");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(UserSelection.settingMaxAnodeVolts)); // Send the Anode Volts Information
  delay(300); // Wait for the Arduino to comprehend and send the next request
  temp = arduinoPort.readString(); // Read the next part
  goodRead = temp.equals(str(UserSelection.settingMaxAnodeVolts) + " V\r\nNumber of datapoints per sweep: [not less than 2]\r\n");
  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  }
  println(temp); // Print to the console so I can track
  temp = null;

  // Send the number of dataPoints
  printInfo("Sending setting 4");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(UserSelection.settingNoOfDataPointsPerSweep)); // Send the data points Information
  delay(300); // Wait for the Arduino to comprehend and send the next request
  temp = arduinoPort.readString(); // Read the next part
  switch(UserSelection.settingTestType) { // Now the requirements change due to the test type
  case 1: // Diode mode, this is enough to run the test
    goodRead = temp.equals(str(UserSelection.settingNoOfDataPointsPerSweep) + "\r\nRun test? [y/n]\r\n");
    if (goodRead == false) {
      printInfo("Error!"); // Visual warning
      println(temp); // Show me what it got that was wrong - helps to debug
      return false;
    }
    println(temp); // Tell me so I can track
    return true; // That's it! Leave the function
  case 2: // Triode Mode
    goodRead = temp.equals(str(UserSelection.settingNoOfDataPointsPerSweep) + "\r\nStep primary grid(s) bias supply from 0V down to: [up to -60V]\r\n");
    break;
  case 3: // Tetrode/Pentode Mode
    goodRead = temp.equals(str(UserSelection.settingNoOfDataPointsPerSweep) + "\r\nStep primary grid(s) bias supply from 0V down to: [up to -60V]\r\n");
    break;
  default:
    println("Issue in the switch statement!");
  }
  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  }
  println(temp); // Print to the console so I can track
  temp = null;

  // Send Bias Supply Data
  printInfo("Sending setting 5");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(-(UserSelection.settingBiasSet))); // Send the Bias Supply Information (must be sent as a positive?)
  delay(300); // Wait for the Arduino to comprehend and send the next request
  formatTemp = String.format("%.2f", -(UserSelection.settingBiasSet)); // Formats so the string is 2dp for the comparison
  temp = arduinoPort.readString(); // Read the next part
  goodRead = temp.equals(formatTemp + " V\r\nStep size:\r\n");
  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  }
  println(temp); // Print to the console so I can track
  temp = null;

  // Send Bias Step Data
  printInfo("Sending setting 6");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(-(UserSelection.settingBiasStep))); // Send the Bias Step Information (must be sent as a positive?)
  delay(300); // Wait for the Arduino to comprehend and send the next request
  formatTemp = String.format("%.2f", -(UserSelection.settingBiasStep)); // Formats so the string is 2dp for the comparison
  temp = arduinoPort.readString(); // Read the next part
  switch(UserSelection.settingTestType) {
  case 2: // Triode Mode, this is enough to run the test
    goodRead = temp.equals(formatTemp + " V\r\nRun test? [y/n]\r\n");
    if (goodRead == false) {
      printInfo("Error!"); // Visual warning
      println(temp); // Show me what it got that was wrong - helps to debug
      return false;
    }
    println(temp); // Print to the console so I can track
    return true; // That's it! Leave the function
  case 3: // Tetrode/Pentode Mode
    goodRead = temp.equals(formatTemp + " V\r\nSet secondary high voltage supply to: [up to 500V]\r\n");
    break;
  default:
    println("Issue in the switch statement!");
  }
  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  }
  println(temp); // Print to the console so I can track
  temp = null;

  // Send Secondary HT Supply Data
  printInfo("Sending setting 7");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(UserSelection.settingScreenVolts)); // Send the Screen Volts Information
  delay(300); // Wait for the Arduino to comprehend and send the next request
  temp = arduinoPort.readString(); // Read the next part
  goodRead = temp.equals(str(UserSelection.settingScreenVolts) + " V\r\nUL percent: [0% = full pentode; 100% = full triode] \r\n");
  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  }
  println(temp); // Print to the console so I can track
  temp = null;

  // Send Ultra Linear Percentage Data
  printInfo("Sending setting 8");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(UserSelection.settingUlPercent)); // Send the Screen Volts Information
  delay(300); // Wait for the Arduino to comprehend and send the next request
  temp = arduinoPort.readString(); // Read the next part
  goodRead = temp.equals(str(UserSelection.settingUlPercent) + " %\r\nSet secondary grid bias supply to: [up to -60V]\r\n");
  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  }
  println(temp); // Print to the console so I can track
  temp = null;

  // Send Secondary Grid Bias
  printInfo("Sending setting 9");
  arduinoPort.clear(); // Clear the buffer
  arduinoPort.write(str(-(UserSelection.settingSecondaryGridBias))); // Send the Secondary Grid Bias Information
  delay(300); // Wait for the Arduino to comprehend and send the next request
  formatTemp = String.format("%.2f", -(UserSelection.settingSecondaryGridBias)); // Formats so the string is 2dp for the comparison
  temp = arduinoPort.readString(); // Read the next part
  goodRead = temp.equals(formatTemp + " V\r\nRun test? [y/n]\r\n");
  if (goodRead == false) {
    printInfo("Error!"); // Visual warning
    println(temp); // Show me what it got that was wrong - helps to debug
    return false;
  } else { // This is the last thing
    println(temp); // Print to the console so I can track
    return true; // That's it!
  }
}

// getData() ////////////////////////////////////////////////////////////////////////////////

DataFromArduino getData() {
  // Temporary Variables
  if (UserSelection.settingTestType == 4) {
    return createSampleData();
  }
  else {
  String temp;
  boolean goodRead;

  arduinoPort.clear(); // Clear the buffer, this should only say "Run Test [y/n]"
  printInfo("Requesting data from Arduino");
  printInfo("Requesting data from Arduino");
  printInfo("Requesting data from Arduino");
  arduinoPort.write("y"); // Tells the Arduino to run the test
  printInfo("Waiting on the Arduino...");
  printInfo("Waiting on the Arduino...");
  printInfo("Waiting on the Arduino...");
  delay(DataFromArduino.noOfDataPoints * 100); // Wait for Arduino to comprehend, run the test and send the data back
  temp = arduinoPort.readStringUntil(10); // Reads the first line (10 represents '\n' in ASCII)
  goodRead = temp.equals("Vb1(V), HV1(V), Ia1(mA), Vb2(V), HV2(V), Ia2(mA),\r\n"); // Does it match the header?
  if (goodRead == false) {
    printInfo("Error!");
    println(temp);
  } else {
    println(temp);
    printInfo("Data Received!");
  }

  // Create some arrays to hold this information

  float[] htVoltages = new float[DataFromArduino.noOfDataPoints];
  float[] anodeCurrents = new float[DataFromArduino.noOfDataPoints];
  float[] actualBiasGridOne = new float[DataFromArduino.noOfDataPoints];
  float[] actualBiasGridTwo = new float[DataFromArduino.noOfDataPoints];
  float[] screenVoltages = new float[DataFromArduino.noOfDataPoints];
  float[] screenCurrents = new float[DataFromArduino.noOfDataPoints];
  printInfo("Sorting the data...");
  for (int i = 0; i < DataFromArduino.noOfDataPoints; i++) {
    temp = arduinoPort.readStringUntil(int('-')); // Remove the initial dash at the start of every line
    temp = arduinoPort.readStringUntil(10); // read to the new line character
    println(temp);
    String[] splitValues = split(temp, ", "); // Splits the string whenever ", " occurs
    splitValues[5] = splitValues[5].substring(0, 4); //Removes the pesky comma!
    // Cast to the Strings to floats and store them
    actualBiasGridOne[i] = float(splitValues[0]);
    htVoltages[i] = float(splitValues[1]);
    anodeCurrents[i] = float(splitValues[2]);
    actualBiasGridTwo[i] = float(splitValues[3]);
    screenVoltages[i] = float(splitValues[4]);
    screenCurrents[i] = float(splitValues[5]);
  }
  // Create the object and return it
  DataFromArduino dataReceived = new DataFromArduino(htVoltages, anodeCurrents, actualBiasGridOne, actualBiasGridTwo, screenVoltages, screenCurrents);
  return dataReceived;
  }
}
