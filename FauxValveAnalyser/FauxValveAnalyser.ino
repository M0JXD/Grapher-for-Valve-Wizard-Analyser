/************************************************************
 * DEFINES & MACRO
 ************************************************************/

#define DIODE_MODE 1
#define TRIODE_MODE 2
#define PENTODE_MODE 3
#define MIN_HV_INCREMENT 5 //Minimum increment between each high-voltage datapoint in a sweep, in volts

#include <math.h>
#include <avr/pgmspace.h> 
#include <Wire.h>   //Include the Wire library to talk I2C

#define MASTER 1            //For when hardware ID pin is high
#define SLAVE 0             //For when hardware ID pin is low

#define MASTER_ADDR 0x0A      //I2C Address of the MASTER Arduino
#define SLAVE_ADDR 0x0B       //I2C Address of the SLAVE Arduino
#define DAC1_ADDR 0x60  //I2C Address of one MCP4725, by default pin A0 is pulled to GND.
#define DAC2_ADDR 0x61   //I2C Address of other MCP4725; its pin A0 must be pulled HIGH to make address 0x61 (also remove pull-up resistors). Note that the breakout board uses the MCP4725A0.
//NB: I2C can send 32 ints per transmission.

#define HARDWARE_ID_PIN 12  //High for master, low for slave
#define VH_PIN A2           //Heater-voltage sense from buck regulator
#define IH_PIN A3           //Heater-current sense from buck regulator
#define PWM_PIN 6           //PWM drive signal to buck regulator MOSFET 
#define CHARGE1_PIN 8        //Drive to high-voltage charge MOSFET
#define DISCHARGE1_PIN 11     //Drive to high-voltage discharge MOSFET 
#define FIRE1_PIN 7          //Drive to 'apply high voltage' MOSFET 
#define VA1_PIN A6           //High voltage sense 1
#define VA2_PIN A7           //High voltage sense 2
#define IA1_HI_PIN A1        //Small anode-current sense (large sense resistance) 
#define IA1_LO_PIN A0        //Large anode-current sense (small sense resistance)
#define IA2_HI_PIN A3        //Small anode-current sense (large sense resistance) 
#define IA2_LO_PIN A2        //Large anode-current sense (small sense resistance)
#define DISCHARGE2_PIN 4
#define FIRE2_PIN 2
#define CHARGE2_PIN 3       
#define LV_DETECT_PIN 9  //Pin to detect if heater power supply is present


/************************************************************
 * GLOBAL VARIABLES
 ************************************************************/
#define ARRAY_LENGTH 10         
int targetValues[ARRAY_LENGTH];   //Array to hold target values (array lenth must be less than 32 ints or 16 unsigned ints owing to I2C limit)
int measuredValues[ARRAY_LENGTH]; //Array to hold measured values (array lenth must be less than 32 ints or 16 unsigned ints owing to I2C limit)

int testMode = 0;
float heaterVolts = 0;
int dataPoints = 2;
int maxAnodeVolts = dataPoints * MIN_HV_INCREMENT;
float maxGridVolts1 = 0;
float voltsPerStep = 0;
int screenVolts = 0;
int ulPercent = 0;
float maxGridVolts2 = 0;
int duty_cycle = 0;      //Duty cycle of buck converter
boolean hardware;         //Will be set to 1 if hardware ID pin is high (MASTER), else 0 (SLAVE).

const char selectTestMessage[] PROGMEM = {"Select test mode:"};
const char diodeMessage[] PROGMEM = {"[Diode / double diode = 1;"};
const char triodeMessage[] PROGMEM = {"Triode / double triode = 2;"};
const char pentodeMessage[] PROGMEM = {"Tetrode / pentode = 3]"};
const char heaterVoltsMessage[] PROGMEM = {"Set heater to: [up to 24V]"};
const char voltsSymbol[] PROGMEM = {" V"};
const char sweepHV1Message[] PROGMEM = {"Sweep anode(s) from 0V up to: [up to 500V]"};
const char dataPointsMessage[] PROGMEM = {"Number of datapoints per sweep: [not less than 2]"};
const char gridBias1Message[] PROGMEM = {"Step primary grid(s) bias supply from 0V down to: [up to -60V]"};
const char stepSizeMessage[] PROGMEM = {"Step size:"};
const char HV2Message[] PROGMEM = {"Set secondary high voltage supply to: [up to 500V]"};
const char ulMessage[] PROGMEM = {"UL percent: [0% = full pentode; 100% = full triode] "};
const char percentSymbol[] PROGMEM = {" %"};
const char gridBias2Message[] PROGMEM = {"Set secondary grid bias supply to: [up to -60V]"};
const char runMessage[] PROGMEM = {"Run test? [y/n]"};
const char errorMessage[] PROGMEM = {"Error: Parameter out of range?"};
const char columnLabels[] PROGMEM = {"Vb1(V), HV1(V), Ia1(mA), Vb2(V), HV2(V), Ia2(mA),"};



//INDICES FOR BOTH ARRAYS
#define VH       0   //Heater voltage  [example: 12.6V = adc391   6.3V = adc195] 
#define IH       1   //Heater current
#define VG1      2  //Grid voltage 1  [example: 1V = dac60, 10V=dac605, 20V=dac1210, 30V=dac1815, 40V=dac2420, 50V=dac3020]
#define HV1      3   //Anode voltage 1 [example: 600V=3.97V=adc992   300V=1.98V=adc496    200V=0.76V=330   100V=0.381V=V=adc165]
#define IA_HI_1  4   //Anode current hi 1
#define IA_LO_1  5  //Anode current lo 1
#define VG2      6   //Grid voltage 2
#define HV2      7   //Anode voltage 2
#define IA_HI_2  8   //Anode current hi 2
#define IA_LO_2  9   //Anode current lo 2


/************************************************************
 * SAMPLE DATA
 ************************************************************/
// These values are all taken from Merlin's Spreadsheet, I think they're EL84 values.
const float merlinsHTVoltages[] PROGMEM = { 0, 6.63, 16.87, 28.31, 39.76, 51.81, 66.27, 81.93, 98.8, 118.07, 141.57, 168.07, 200.6,
    243.37, 303.61, 404.82, 0, 7.23, 17.47, 26.51, 38.55, 51.81, 65.06, 81.33, 99.4, 118.67,
    139.76, 167.47, 201.81, 243.37, 303.01, 404.22, 0, 7.23, 16.27, 26.51, 39.16, 51.81, 66.87,
    81.33, 100, 116.87, 139.76, 168.67, 201.2, 243.37, 303.01, 404.22, 0, 7.83, 18.07, 29.52, 40.36,
    53.61, 67.47, 81.93, 99.4, 118.07, 142.17, 168.07, 201.2, 243.98, 303.01, 404.22, 0, 6.63, 17.47,
    27.71, 39.76, 51.2, 66.27, 81.33, 98.8, 119.28, 141.57, 168.07, 201.2, 243.98, 303.01, 404.22, 0,
    6.63, 16.27, 27.71, 39.76, 52.41, 65.66, 82.53, 100, 118.07, 141.57, 167.47, 201.2, 243.37, 303.61,
    404.22, 0, 7.23, 16.27, 27.71, 40.96, 53.61, 67.47, 80.72, 99.4, 119.28, 142.17, 168.67, 201.2, 243.98,
    303.01, 404.22, 0, 6.02, 17.47, 29.52, 40.96, 54.22, 68.07, 83.13, 100, 119.88, 142.17, 168.67, 202.41,
    243.98, 303.61, 404.22, 0, 8.43, 19.28, 29.52, 41.57, 51.2, 66.27, 82.53, 99.4, 119.88, 140.96, 169.28,
    200.6, 243.98, 303.61, 404.22, 0, 7.83, 18.07, 28.92, 40.96, 54.82, 68.07, 82.53, 100, 118.67, 140.36,
    168.67, 201.2, 243.37, 303.61, 404.22, 0, 7.83, 16.87, 30.12, 41.57, 54.82, 65.66, 83.13, 100, 118.07, 142.17,
    168.07, 202.41, 243.37, 303.61, 404.22 }; // HT Voltages

const float merlinsAnodeCurrents[] PROGMEM = { 1.26, 38.78, 73.61, 94.55, 105.33, 111.91, 116.7, 119.09, 121.48, 122.68, 126.27, 128.07, 130.46,
    133.45, 136.45, 141.83, 0.78, 41.71, 63.44, 73.61, 81.39, 86.18, 90.37, 92.16, 94.55, 96.35, 98.14,
    99.94, 101.14, 104.73, 107.12, 111.91, 0.42, 39.5, 49.67, 56.85, 59.84, 64.03, 67.62, 70.02, 71.81,
    73.61, 74.81, 77.2, 77.8, 80.19, 81.99, 85.58, 0.6, 31.36, 37.46, 41.29, 43.27, 45.6, 48, 49.55,
    51.47, 52.66, 53.26, 54.46, 55.06, 57.45, 59.25, 62.84, 0.96, 19.93, 23.88, 25.61, 26.57, 28.43, 30.4,
    32.2, 33.27, 34.29, 35.01, 35.79, 36.8, 38.3, 39.8, 42.49, 1.08, 12.21, 13.64, 14.6, 15.08, 15.74,
    17.77, 18.97, 19.75, 19.99, 20.95, 21.01, 21.66, 22.98, 24.3, 26.21, 0.6, 6.46, 6.94, 7.48, 7.84, 8.08,
    8.5, 9.04, 9.87, 10.05, 10.35, 10.83, 11.19, 12.03, 12.93, 14.3, 0.18, 2.75, 2.81, 3.17, 3.29, 3.35,
    3.41, 3.95, 4.07, 4.25, 4.55, 4.67, 5.09, 5.45, 5.92, 6.76, 0.06, 1.02, 1.14, 1.14, 1.2, 1.2, 1.32,
    1.44, 1.5, 1.74, 1.68, 1.97, 1.97, 2.21, 2.51, 2.99, 0, 0.3, 0.3, 0.42, 0.42, 0.36, 0.42, 0.48, 0.48,
    0.6, 0.72, 0.78, 0.78, 0.9, 0.96, 1.32, 0, 0, 0, 0, 0.06, 0.06, 0.12, 0.12, 0.12, 0.18, 0.18, 0.18, 0.3,
    0.36, 0.42, 0.6 }; //Anode Currents

const float merlinsBiasVoltages[] PROGMEM = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
    -2, -2, -2, -2, -4.01, -4.01, -4.01, -4.01, -4.01, -4.01, -4.01, -4.01, -4.01, -4.01, -4.01, -4.01, -4.01,
    -4.01, -4.01, -4.01, -5.99, -5.99, -5.99, -5.99, -5.99, -5.99, -5.99, -5.99, -5.99, -5.99, -5.99, -5.99, -5.99,
    -5.99, -5.99, -5.99, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -8, -10, -10, -10, -10,
    -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -10, -12, -12, -12, -12, -12, -12, -12, -12, -12, -12,
    -12, -12, -12, -12, -12, -12, -14.01, -14.01, -14.01, -14.01, -14.01, -14.01, -14.01, -14.01, -14.01, -14.01, -14.01,
    -14.01, -14.01, -14.01, -14.01, -14.01, -15.99, -15.99, -15.99, -15.99, -15.99, -15.99, -15.99, -15.99, -15.99, -15.99,
    -15.99, -15.99, -15.99, -15.99, -15.99, -15.99, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18, -18,
    -18, -18, -18, -20, -20, -20, -20, -20, -20, -20, -20, -20, -20, -20, -20, -20, -20, -20, -20 }; // Bias Voltages

const float merlinsScreenVoltages[] PROGMEM = { 248.19, 249.4, 249.4, 250, 251.2, 250.6, 251.2, 251.81, 251.2, 251.81, 251.2, 250.6, 251.2, 253.01, 253.01,
    253.01, 249.4, 251.81, 250.6, 250.6, 251.2, 250.6, 251.2, 251.2, 251.81, 251.81, 251.81, 252.41, 251.2, 253.01,
    253.61, 253.01, 250, 253.61, 253.01, 251.81, 251.81, 251.2, 251.2, 251.81, 253.01, 253.01, 252.41, 253.01, 252.41,
    253.01, 253.61, 253.01, 250.6, 253.01, 253.01, 254.22, 253.01, 252.41, 253.01, 251.2, 251.81, 251.81, 253.01,
    252.41, 251.81, 253.61, 253.01, 253.61, 251.2, 251.2, 251.2, 251.81, 251.2, 250.6, 253.01, 252.41, 252.41, 252.41,
    251.2, 252.41, 251.81, 253.61, 253.61, 253.61, 251.81, 252.41, 251.81, 251.81, 252.41, 252.41, 253.01, 253.61,
    254.22, 252.41, 253.01, 252.41, 252.41, 253.61, 253.61, 253.61, 251.81, 251.81, 251.81, 252.41, 253.01, 253.01,
    253.01, 253.01, 251.81, 253.01, 253.01, 253.01, 251.81, 253.01, 253.61, 253.61, 252.41, 253.01, 251.81, 254.22,
    253.01, 253.61, 253.61, 253.01, 253.01, 251.81, 252.41, 253.01, 253.61, 253.61, 253.61, 253.61, 252.41, 254.22,
    253.01, 254.22, 254.22, 254.22, 253.61, 252.41, 253.01, 252.41, 251.81, 252.41, 253.61, 253.61, 253.61, 253.61,
    252.41, 252.41, 253.01, 253.61, 254.82, 254.22, 254.82, 254.22, 254.22, 252.41, 253.61, 251.81, 251.81, 253.61,
    253.01, 253.61, 252.41, 252.41, 251.81, 253.61, 253.61, 254.22, 253.61, 254.22, 253.61, 253.01, 253.01, 253.01,
    253.01, 253.61, 253.61, 253.61 }; // Screen Voltages

const float merlinsScreenCurrents[] PROGMEM = { 95.75, 67.62, 46.74, 34.47, 27.95, 24.06, 21.54, 19.87, 18.91, 17.95, 17.12, 16.58, 15.92, 15.44, 14.6, 13.41,
    73.61, 44.58, 32.08, 25.91, 21.96, 19.21, 16.94, 15.74, 14.6, 13.88, 13.41, 12.69, 12.33, 11.91, 11.37, 10.47,
    53.86, 28.49, 23.16, 19.63, 16.82, 14.9, 13.11, 12.03, 11.07, 10.71, 10.11, 9.87, 9.4, 9.1, 8.62, 7.96, 37.52,
    18.37, 15.86, 14, 12.63, 11.37, 9.69, 8.56, 7.9, 7.6, 7.12, 6.76, 6.58, 6.46, 6.16, 5.69, 24.3, 11.73, 9.75, 9.22,
    8.68, 7.78, 6.64, 5.86, 5.15, 4.79, 4.67, 4.37, 4.43, 4.25, 4.01, 3.83, 14.3, 6.52, 5.69, 5.39, 5.21, 4.91, 4.13,
    3.59, 3.17, 2.75, 2.69, 2.57, 2.57, 2.45, 2.39, 2.33, 7.48, 3.17, 2.75, 2.57, 2.75, 2.45, 2.09, 1.74, 1.56, 1.38,
    1.32, 1.32, 1.2, 1.32, 1.26, 1.08, 3.35, 1.44, 1.08, 1.02, 1.14, 1.26, 0.96, 0.66, 0.66, 0.54, 0.54, 0.48, 0.6,
    0.6, 0.48, 0.54, 1.2, 0.54, 0.42, 0.54, 0.36, 0.36, 0.36, 0.42, 0.24, 0.18, 0.3, 0.18, 0.24, 0.3, 0.3, 0.24,
    0.48, 0.18, 0.06, 0.24, 0.06, 0, 0.18, 0, 0.12, 0, 0.12, 0.06, 0, 0, 0.12, 0.12, 0.18, 0.06, 0, 0.06, 0.06,
    0.06, 0.06, 0, 0.12, 0, 0, 0, 0.06, 0.06, 0, 0 }; // Screen Currents

/************************************************************   
*FUNCTION PROTOTYPES
************************************************************/
void setHeaterVolts();
void setGridVolts();
void chargeHighVoltages();
void print_arrays();
void send_to_slave();
void masterReceiveData(int howMany);
void request_from_slave();
void slaveReceiveData(int howMany);
void slaveAnswerRequest();
void printMeasuredValues(void);
void setTargetValue(int index, float volts);
void calculateSweepValues(int sweepArray1[], int sweepArray2[]);
int checkForUserErrors(void); //returns 1 if the user has entered valid test parameters, else 0
void doMeasurement(void);
void dischargeHighVoltages(void);
void getUserParameters(void);
void printMessage(const char *messageptr);
int getUserInstruction(void);//returns 1 if user request to run test, else 0

void parseSampleData(void); // Used to Parse the Sample data into measuredValues[] 



/************************************************************
 * SETUP
 ************************************************************/
void setup() {
  Serial.begin(9600); //Setup serial interface
  
  /* code I used to debug pgm issue
   for(int i = 0; i < 25; i++) {
    // turns out a pgm directive is needed to read right
    // otherwise stuff gets real confused with ovf and nan!
    float temp = pgm_read_float_near(merlinsHTVoltages + i); // simple pointer stuff
    Serial.println(temp);
  }
  */
  
  pinMode(HARDWARE_ID_PIN, INPUT);
  //I2C SDA is on Arduino Nano pin A4 as standard
  //I2C SCL is on Arduino Nano pin A5 as standard. These pins need no further setup.
  //By default, analog input pins also need no setup
                                        
  analogReference(EXTERNAL);                //Use external voltage reference for ADC
  TCCR0B = (TCCR0B & 0b11111000) | 0x01;    //Configure Timer0 for internal clock, no prescaling (bottom 3 bits of TCCR0B)
                                            //Makes Arduino run 6.3 times faster than normal. NB: This affects Arduino delay() function!
  
  analogWrite(PWM_PIN, 0);                  //Make sure PWM output is zero on startup
  pinMode(LED_BUILTIN, OUTPUT);             //Arduino built-in LED for debugging
  
  hardware = digitalRead(HARDWARE_ID_PIN); //Identify if this is MASTER (1) or SLAVE (0) Arduino
  hardware = 1;
 // if(hardware == MASTER){
      pinMode(CHARGE1_PIN, OUTPUT);  
      pinMode(DISCHARGE1_PIN, OUTPUT);
      pinMode(FIRE1_PIN, OUTPUT);
      pinMode(CHARGE2_PIN, OUTPUT);
      pinMode(DISCHARGE2_PIN, OUTPUT);
      pinMode(FIRE2_PIN, OUTPUT); 
      digitalWrite(FIRE1_PIN, LOW); 
      digitalWrite(FIRE2_PIN, LOW);       
      digitalWrite(CHARGE1_PIN, LOW);
      digitalWrite(CHARGE2_PIN, LOW);
      digitalWrite(DISCHARGE1_PIN, HIGH); //make sure capacitor banks are discharged ready for first sweep
      digitalWrite(DISCHARGE2_PIN, HIGH);
     // Wire.begin(MASTER_ADDR);            //Register I2C address
     // Wire.onReceive(masterReceiveData);  //Interrupt when I2C data is being received

 // }
 /* else{ //else this is SLAVE hardware
      pinMode(LV_DETECT_PIN, INPUT);
      analogWrite(PWM_PIN, 0);            //Set heater to 0V at start-up
      Wire.begin(SLAVE_ADDR);             //Register I2C address
      Wire.onReceive(slaveReceiveData);   //Interrupt when I2C data is being received
      Wire.onRequest(slaveAnswerRequest); //Interrupt when master demands a response
//  }
*/
}

/************************************************************
 * MAIN LOOP
 ************************************************************/
void loop() {

              
  //  if(hardware == MASTER){  for testing, our hardware is always "MASTER"   
    
      static int runTest = 0;
      
      while(!runTest){
          getUserParameters();  //Ask for user input, returns 1 when ready
          runTest = checkForUserErrors(); //Returns 1 if no errors found
      }

      float sweepTable1[dataPoints];//Stores HV1 voltages to be used during a sweep
      float sweepTable2[dataPoints];//Stores HV2 voltages to be used during a sweep
      calculateSweepValues(sweepTable1, sweepTable2); //Populate the sweep values
      
      runTest = getUserInstruction(); //user must press 'y' to run test
      
               
   
      
    if(runTest){ //commence test
      /*  No external hardware for our Faux Analyser
           setTargetValue(VH, heaterVolts); //send again in case anything has changed
          send_to_slave();
      */
          printMessage(columnLabels);
          int sampleIterate = 0;
          for(float j = 0; j <= maxGridVolts1; j += voltsPerStep, sampleIterate++){
              // setTargetValue(VG1, j); No external hardware for our Faux Analyser
              if(testMode == TRIODE_MODE){//if testing a triode
                // targetValues[VG2] = targetValues[VG1];//make VG2 supply the same as VG1 supply
              }
              else{ //else make it constant
               // setTargetValue(VG2, maxGridVolts2);
              }

              if(maxGridVolts1 == 0){//if user requested only 0V curve
                j++;//stop the test from repeating
              }
              if(testMode == DIODE_MODE){//if testing a diode
                j = maxGridVolts1 + 1;//stop the test from repeating
              }
              
              // setGridVolts(); No external hardware for our Faux Analyser
              for(int i = 0; i < dataPoints; i++){
                  float nextHV1 = sweepTable1[i];//get next datapoint for HV1 sweep
                  float nextHV2 = sweepTable2[i];//get next datapoint for HV2 sweep
                  // No external hardware for our Faux Analyser
                  // setTargetValue(HV1, nextHV1);
                  // setTargetValue(HV2, nextHV2);
                  // chargeHighVoltages();
                  // doMeasurement();
                  // request_from_slave(); 
                  setSampleValues(i, sampleIterate);
                  printMeasuredValues();  
              }
             // dischargeHighVoltages(); //sweep is complete
          }
   }
 
         digitalWrite(LED_BUILTIN, LOW); //for debugging
    }
/*  Again, for testing we're always using "MASTER"
     else{ //Else this is SLAVE hardware
            setHeaterVolts();
    }
}
*/ 
//End of main program loop


/************************************************************
 * FUNCTION DEFINITIONS
 ************************************************************/

/************************************************************
 * Sorts out the sample data into the measuredValues[]
 ************************************************************/

void setSampleValues(int i, int x) {
  // x is for the outer loop while i is the inner
  // pgm directives are needed to read properly from flash
  // (Learnt that the hard way!)
  // that means it becomes pointer arithmetic, I thought Arduino was meant to make stuff EASY!
  
  measuredValues[VG1] = int((pgm_read_float_near(merlinsBiasVoltages + (i + (x * dataPoints)))) * 60.4); // 60.4 converts "back" to a DAC value
  measuredValues[HV1] = int((pgm_read_float_near(merlinsHTVoltages + (i + (x * dataPoints)))) * 1.66); // 1.66 converts "back" to dac values
  
  // The "LO & HI" is to do with hardware that's optimised for measuring low and high currents...
  measuredValues[IA_HI_1] = int((pgm_read_float_near(merlinsAnodeCurrents + (i + (x * dataPoints)))) * 16.71); // ""
  measuredValues[IA_LO_1] = int((pgm_read_float_near(merlinsAnodeCurrents + (i + (x * dataPoints)))) * 1.671); // ""
  
  measuredValues[VG2] = 0; // The sample data is for a Pentode 
  
  measuredValues[HV2] = int((pgm_read_float_near(merlinsScreenVoltages + (i + (x * dataPoints)))) * 1.66); 
  
  // ...the Arduino decides which to use in the print function
  measuredValues[IA_HI_2] = int((pgm_read_float_near(merlinsScreenCurrents + (i + (x * dataPoints)))) * 16.71);
  measuredValues[IA_LO_2] = int((pgm_read_float_near(merlinsScreenCurrents + (i + (x * dataPoints)))) * 1.671);
}



/************************************************************
 * Controls the heater buck regulator
 ************************************************************/
void setHeaterVolts(){ //Manages the heater buck-converter
    int Vh_adc = analogRead(VH_PIN);           
    int Ih_adc = analogRead(IH_PIN);
    Vh_adc = Vh_adc - (Ih_adc / 8);   //Divide Ih_adc value by 8 and subtract from Vh_adc value to get corrected voltage across heater  
    measuredValues[VH] = Vh_adc;        //Update the array with new heater voltage
    measuredValues[IH] = Ih_adc;        //Update the array with new heater current
    if(duty_cycle > 0){                 //Duty cycle is always trying to decrement as a fail-safe measure
       duty_cycle --;                   //but don't let it drop below zero (wrap around)
    }
    
    if(Ih_adc < 110){                                 //If heater current is less than 2 amps it is safe to proceed. 
        measuredValues[VH] = Vh_adc;                  //Update the array with new heater voltage
        measuredValues[IH] = Ih_adc;                  //Update the array with new heater current
        if(measuredValues[VH] < targetValues[VH]) {   //If heater voltage is too low, increment duty cycle
            if(duty_cycle < 254){                     //But don't let duty cycle exceed 255 (wrap around)
              duty_cycle += 2; 
            }
        }
    }
    
   if(!digitalRead(LV_DETECT_PIN)){
       duty_cycle = 0;                                //Disable buck converter if heater power supply is off
   }
    analogWrite(PWM_PIN, duty_cycle);                 //Update buck converter with new duty cycle
    
    /*For debugging*/
    if(measuredValues[VH] == targetValues[VH]) {//If heater voltage is just right
      digitalWrite(LED_BUILTIN, HIGH); //light LED
    }
    else{
      digitalWrite(LED_BUILTIN, LOW);
    }
}

/****************************************************************************
*Updates the bias DACs with target values
****************************************************************************/
void setGridVolts(){
      if(measuredValues[VG1] != targetValues[VG1]){     //If target grid voltage has changed since last time,
          Wire.beginTransmission(DAC1_ADDR);
          Wire.write(64);                               //Command to update the DAC
          Wire.write(targetValues[VG1] >> 4);           //8 most significant bits
          Wire.write((targetValues[VG1] & 15) << 4);    //4 least significant bits
          if(Wire.endTransmission() == 0){              //If I2C tramission was a success
              measuredValues[VG1] = targetValues[VG1];  //Store the new grid voltage
          }
        }
                        
      if(measuredValues[VG2] != targetValues[VG2]){   //If target grid voltage has changed since last time,
          Wire.beginTransmission(DAC2_ADDR);
          Wire.write(64);                             //Command to update the DAC
          Wire.write(targetValues[VG2] >> 4);         //8 most significant bits
          Wire.write((targetValues[VG2] & 15) << 4);  //4 least significant bits
          if(Wire.endTransmission() == 0){            //If I2C tramission was a success
              measuredValues[VG2] = targetValues[VG2];//Store the new grid voltage
          }
        }
}

/****************************************************************************
* Charges up the high-voltage capacitor banks to the target values
****************************************************************************/
void chargeHighVoltages(){ //Manages the HV supply
    digitalWrite(FIRE1_PIN, LOW);                       //Turn off MOSFETs (fail-safe measure)
    digitalWrite(FIRE2_PIN, LOW);
    digitalWrite(CHARGE1_PIN, LOW);
    digitalWrite(CHARGE2_PIN, LOW);
    digitalWrite(DISCHARGE1_PIN, LOW);
    digitalWrite(DISCHARGE2_PIN, LOW); 
    measuredValues[HV1] = analogRead(VA1_PIN);         //Measure the high voltage and store the value
    measuredValues[HV2] = analogRead(VA2_PIN);         //Measure the high voltage and store the value
    //While either storage cap is not charged to the correct voltage, alternately charge each cap
    //NB: Both cannot be charged simultaneously or one may hold down the supply to the other.
    while((measuredValues[HV1] != targetValues[HV1]) || (measuredValues[HV2] != targetValues[HV2])){   
        while(measuredValues[HV1] < (targetValues[HV1]-0)) {//If voltage is too low, charge capacitor
              digitalWrite(CHARGE1_PIN, HIGH); 
              measuredValues[HV1] = analogRead(VA1_PIN);    //Keep checking the voltage
        }
        digitalWrite(CHARGE1_PIN, LOW); //Done, isolate this storage capacitance. It will begin to discharge slowly.
        
        measuredValues[HV2] = analogRead(VA2_PIN);          //Measure the high voltage and store the value
        while(measuredValues[HV2] < (targetValues[HV2]-0)) {//If voltage is too low, charge capacitor
              digitalWrite(CHARGE2_PIN, HIGH);
              measuredValues[HV2] = analogRead(VA2_PIN);    //Keep checking the voltage
        }
        digitalWrite(CHARGE2_PIN, LOW); //Done, isolate this storage capacitance. It will begin to discharge slowly.
        measuredValues[HV1] = analogRead(VA1_PIN);//Check first capacitor bank again
    }
}


/****************************************************************************
* Prints contents of arrays to serial monitor, for debugging
****************************************************************************/
void print_arrays(){  
    Serial.println("Target....Measured");
    for(int i=0; i<ARRAY_LENGTH; i++){
      Serial.print(targetValues[i]);
      Serial.print("       ");
      Serial.println(measuredValues[i]);
    }
    Serial.println(" ");
}

/****************************************************************************
* Send target heater value to slave
****************************************************************************/
void send_to_slave(){
    byte byte1;
    byte byte2;
    Wire.beginTransmission(SLAVE_ADDR);
        byte1 = highByte(targetValues[VH]); //Arduino function breaks word into bytes
        byte2 = lowByte(targetValues[VH]);
        Wire.write(byte1);
        Wire.write(byte2);
    Wire.endTransmission();
}

/****************************************************************************
* Upon receiving data, populate the measured values array
****************************************************************************/
void masterReceiveData(int howMany){ //called by ISR when I2C data arrives
    byte byte1;
    byte byte2;
    for(int i=0; i<(howMany >> 1); i++){ //receive bytes in pairs
      byte1 = Wire.read();
      byte2 = Wire.read();
      measuredValues[i] = word(byte1, byte2); //Arduino function concatenates bytes into word
    }
    while(Wire.available() > 0){ //Ignore any garbage
          Wire.read();
    }
}

/****************************************************************************
* Request measured heater values from slave
****************************************************************************/
void request_from_slave(){
      byte byte1;
      byte byte2;
      Wire.requestFrom(SLAVE_ADDR, 4); //Request four bytes
      for(int i=0; i<2; i++){
        byte1 = Wire.read();
        byte2 = Wire.read();
        measuredValues[i] = word(byte1, byte2); //Arduino function concatenates bytes into word
      }
}


/****************************************************************************
* Upon receiving data, populate the target values array
****************************************************************************/
void slaveReceiveData(int howMany){       //called by ISR when I2C data arrives
    for(int i=0; i<(howMany >> 1); i++){ //receive bytes in pairs
        byte byte1 = Wire.read();
        byte byte2 = Wire.read();
        targetValues[i] = word(byte1, byte2); //Arduino function concatenates bytes into word
    }
     while(Wire.available() > 0){ //Discard any garbage
          Wire.read();
    }
}

/****************************************************************************
* Upon request, send measured heater values to the master
****************************************************************************/
void slaveAnswerRequest(){
    byte byte1;
    byte byte2;
    for(int i=0; i<2; i++){//Send only the first two words in array
      byte1 = highByte(measuredValues[i]); //Arduino function breaks word into bytes
      byte2 = lowByte(measuredValues[i]);
      Wire.write(byte1);
      Wire.write(byte2);
    }
}

/****************************************************************************
* Print the contents of the measured-values array to the serial window
****************************************************************************/
void printMeasuredValues(void){
    float temp;
    Serial.print("-"); // Puts a dash at the start of every line
    temp = (measuredValues[VG1] / 60.4); //Convert DAC number in human units
    Serial.print(temp);
    Serial.print(", "); 
    temp = (measuredValues[HV1] / 1.66); //Convert DAC number in human units
    Serial.print(temp);
    Serial.print(", "); 
    if(measuredValues[IA_HI_1] < 835){//only print the most accurate current reading
      temp = (measuredValues[IA_HI_1] / 16.71); //Convert ADC number in human units
    }
    else{    
      temp = (measuredValues[IA_LO_1] / 1.671); //Convert ADC number in human units
    }
    Serial.print(temp);
    Serial.print(", -"); 
    temp = (measuredValues[VG2] / 60.4); //Convert DAC number in human units
    Serial.print(temp);
    Serial.print(", "); 
    temp = (measuredValues[HV2] / 1.66); //Convert DAC number in human units
    Serial.print(temp);
    Serial.print(", "); 
    if(measuredValues[IA_HI_2] < 835){//only print the most accurate current reading
      temp = (measuredValues[IA_HI_2] / 16.71); //Convert ADC number in human units
    }
    else{    
      temp = (measuredValues[IA_LO_2] / 1.671); //Convert ADC number in human units
    } 
    Serial.print(temp);
    Serial.println(",");
}

/****************************************************************************
* Fills the target array with the user-chosen target voltage, converted into suitable format
****************************************************************************/
void setTargetValue(int index, float volts){
  float temp;
    switch(index){
      case VH: temp = volts * 33.1; break;//Convert voltage into ADC-compatible number 
      case VG1: temp = round(volts * 60.4); break;//Convert voltage into DAC-compatible number
      case VG2: temp = round(volts * 60.4); break;//Convert voltage into DAC-compatible number
      case HV1: temp = volts * 1.66; break;//Convert voltage into ADC-compatible number 
      case HV2: temp = volts * 1.66; break;//Convert voltage into ADC-compatible number 
      default: break;
    }

    if(index == VG1 || index == VG2){
      if(temp < 4096){//Ignore any out-of-range values
        targetValues[index] = word(temp); //Populate target value
      }
    }
    else{
      if(temp < 1028){//Ignore any out-of-range values
        targetValues[index] = word(temp); //Populate target value
      }
    }  
}

/****************************************************************************
* Calculates a logarithmic array of voltages to be used for each sweep
****************************************************************************/
void calculateSweepValues(float sweepArray1[], float sweepArray2[]){
  sweepArray1[0] = 0; //Start sweep at 1V to avoid waiting for full capacitor disharge
 
  for(int i = 1; i < dataPoints; i++){
    float temp = log10(i); //Use logarithimc spacing to improve resolution at low voltages
    float temp2 = log10(dataPoints);
    temp = temp / temp2;
    temp = (1 - temp);
    temp = temp * maxAnodeVolts;
    sweepArray1[dataPoints - i] = temp;
  }

    for(int i = 0; i < dataPoints; i++){
      if(sweepArray1[i] < i*MIN_HV_INCREMENT){//Don't allow voltage increments to be smaller than MIN_HV_INCREMENT or to be duplicated 
        sweepArray1[i] = i*MIN_HV_INCREMENT;
      }
      sweepArray2[i] = sweepArray1[i];//Coppy HV1 sweep array into HV2 sweep array
      if(testMode == PENTODE_MODE){//if testing a tetrode or pentode
        float temp = screenVolts;
        temp += (sweepArray1[i]*ulPercent/100); //Add a fraction of the instantaneous anode voltage
        temp -= (screenVolts*ulPercent/100); //Subtract a fraction of the average screen voltage
        sweepArray2[i] = temp;
      }
    }
}

/****************************************************************************
* Check the test parameters are valid.
* Returns 0 if there is a problem, otherwise 1.
****************************************************************************/
int checkForUserErrors(void){
  int okToProceed = 1;
 
  if((heaterVolts < 0) || (heaterVolts > 24)){
    okToProceed = 0;
  }
  if((maxAnodeVolts < (dataPoints*MIN_HV_INCREMENT)) || (maxAnodeVolts > 500)){
    okToProceed = 0;
  }
  if((dataPoints < 2) || (dataPoints > (maxAnodeVolts/MIN_HV_INCREMENT))){
    okToProceed = 0;
  }
  if((maxGridVolts1 < 0) || (maxGridVolts1 > 60)){
    okToProceed = 0;
  }
  if(voltsPerStep > maxGridVolts1){
    okToProceed = 0;
  }
  if((screenVolts < 0) || (screenVolts > 500)){
     okToProceed = 0;
  }
  if((maxGridVolts2 < 0) || (maxGridVolts2 > 60)){
     okToProceed = 0;
  }
  if((ulPercent < 0) || (ulPercent > 100)){
      okToProceed = 0;
  }

  if(!okToProceed){
      printMessage(errorMessage);   
  }
  return okToProceed;
}

/****************************************************************************
* Assuming voltages are all set up and ready, takes a measurement
* and puts the results in the measuredValues[] array
****************************************************************************/
void doMeasurement(void){
            int volts1;                                                                 
            int amps1_hi;
            int amps1_lo;
            int volts2;                                                                 
            int amps2_hi;
            int amps2_lo;
            digitalWrite(FIRE1_PIN, HIGH);    //Apply high voltage to the DUT
            digitalWrite(FIRE2_PIN, HIGH);

               volts1 = analogRead(VA1_PIN);  //Read ADC twice to introduce some delay and avoid glitches
               volts1 = analogRead(VA1_PIN);
               amps2_hi = analogRead(IA2_HI_PIN);
               amps2_hi = analogRead(IA2_HI_PIN);
               amps2_lo = analogRead(IA2_LO_PIN);
               amps2_lo = analogRead(IA2_LO_PIN);
               amps1_lo = analogRead(IA1_LO_PIN);
               amps1_lo = analogRead(IA1_LO_PIN);
               amps1_hi = analogRead(IA1_HI_PIN);
               amps1_hi = analogRead(IA1_HI_PIN);
               volts2 = analogRead(VA2_PIN);
               volts2 = analogRead(VA2_PIN);

        
            digitalWrite(FIRE1_PIN, LOW);      //Remove high voltage from the DUT
            digitalWrite(FIRE2_PIN, LOW);    
            measuredValues[HV1] = volts1; 
            measuredValues[IA_HI_1] = amps1_hi;
            measuredValues[IA_LO_1] = amps1_lo;
            measuredValues[HV2] = volts2; 
            measuredValues[IA_HI_2] = amps2_hi;
            measuredValues[IA_LO_2] = amps2_lo;
}

/****************************************************************************
* Discharges the capacitor banks
****************************************************************************/
void dischargeHighVoltages(void){
     digitalWrite(LED_BUILTIN, HIGH); //for debugging
     digitalWrite(FIRE1_PIN, LOW);
     digitalWrite(FIRE2_PIN, LOW); 
     digitalWrite(CHARGE1_PIN, LOW);
     digitalWrite(CHARGE2_PIN, LOW);
     digitalWrite(DISCHARGE1_PIN, HIGH);                        
     digitalWrite(DISCHARGE2_PIN, HIGH);  
     while(analogRead(IA1_HI_PIN)){//wait until no discharge current is detected
     }
     while(analogRead(IA2_HI_PIN)){//wait until no discharge current is detected
     }
     digitalWrite(LED_BUILTIN, LOW); //for debugging
}

/****************************************************************************
* Ask user for test parameters. Returns 1 if OK to proceed, otherwise 0
****************************************************************************/
void getUserParameters(void){
    testMode = 0;//reset all parameters to defaults
    heaterVolts = 0;
    dataPoints = 2;
    maxAnodeVolts = dataPoints * MIN_HV_INCREMENT;
    maxGridVolts1 = 0;
    voltsPerStep = 0;
    screenVolts = 0;
    ulPercent = 0;
    maxGridVolts2 = 0;
    printMessage(selectTestMessage);
    printMessage(diodeMessage);
    printMessage(triodeMessage);
    printMessage(pentodeMessage);

      while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
      while(Serial.available() < 1); //wait for input
      testMode = Serial.parseInt();
      Serial.println(testMode);
      printMessage(heaterVoltsMessage);
      while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
      while(Serial.available() < 1); //wait for input
      heaterVolts = Serial.parseFloat(); 
      Serial.print(heaterVolts); printMessage(voltsSymbol);
            if(checkForUserErrors()){//returns 1 if no error found
              // setTargetValue(VH, heaterVolts); //Turn on heater so it can warm up while user carries on
              // send_to_slave();
            }       
      printMessage(sweepHV1Message);
      while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
      while(Serial.available() < 1); //wait for input
      maxAnodeVolts = Serial.parseInt();
      Serial.print(maxAnodeVolts); printMessage(voltsSymbol);
      printMessage(dataPointsMessage);
      while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
      while(Serial.available() < 1); //wait for input
      dataPoints = Serial.parseInt();
      Serial.println(dataPoints);
      checkForUserErrors();//Print error message if user selects too many data points
    
      if(testMode > DIODE_MODE){//if test mode is triode or pentode
          printMessage(gridBias1Message);
          while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
          while(Serial.available() < 1); //wait for input
          maxGridVolts1 = Serial.parseFloat();
          Serial.print(maxGridVolts1); printMessage(voltsSymbol);
          printMessage(stepSizeMessage);
          while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
          while(Serial.available() < 1); //wait for input
          voltsPerStep = Serial.parseFloat();
          Serial.print(voltsPerStep);  printMessage(voltsSymbol);
      }
      
      if(testMode > TRIODE_MODE){ //if test mode is pentode
              printMessage(HV2Message);
              while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
              while(Serial.available() < 1); //wait for input
              screenVolts = Serial.parseInt();
              Serial.print(screenVolts);  printMessage(voltsSymbol);
              printMessage(ulMessage);
              while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
              while(Serial.available() < 1); //wait for input
              ulPercent = Serial.parseInt();
              Serial.print(ulPercent);  printMessage(percentSymbol);
              printMessage(gridBias2Message);
              while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
              while(Serial.available() < 1); //wait for input
              maxGridVolts2 = Serial.parseFloat();
              Serial.print(maxGridVolts2); printMessage(voltsSymbol);
      }
}

/************************************************************
 * Print a message asking to run test
 ************************************************************/
int getUserInstruction(void){
  int okToProceed = 0;
      printMessage(runMessage);
      while(Serial.available() > 0){char garbage = Serial.read();} //flush input buffer 
      while(Serial.available() < 1); //wait for input
      if(Serial.read() == 'y'){
        okToProceed = 1;
      }
      return okToProceed;
}


/************************************************************
 * Print a message (not more than 250 characters)
 ************************************************************/
void printMessage(const char *messageptr) {
    char temp;
    for(int i = 0; i < strlen_P(messageptr); i++){
      temp = pgm_read_word_near(messageptr + i);
      Serial.print(temp);
    }
    Serial.println();
}
