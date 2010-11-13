/*
* Arduino code for SN754410 H-bridge
* motor driver control.
* copyleft Feb. 2010, Fabian Winkler
*
*/

#include <VirtualWire.h>  // you must download and install the VirtualWire.h to your hardware/libraries folder
#undef int
#undef abs
#undef double
#undef float
#undef round

int leftEnable = 5;
int left1A = 6;
int left2A = 7;
int leftSpeedValue;

int rightEnable = 2;
int right3A = 3;
int right4A = 4;
int rightSpeedValue;

int key = 0;

void setup() {  
  // set digital i/o pins as outputs:
  pinMode(leftEnable, OUTPUT);
  pinMode(left1A, OUTPUT);
  pinMode(left2A, OUTPUT);

  pinMode(rightEnable, OUTPUT);
  pinMode(right3A, OUTPUT);
  pinMode(right4A, OUTPUT);
  
  // Initialise the IO and ISR
  vw_set_ptt_inverted(true);  // Required for RX Link Module
  vw_setup(2000);             // Bits per sec
  vw_set_rx_pin(8);           // We will be receiving on pin 23 (Mega) ie the RX pin from the module connects to this pin. 
  vw_rx_start();              // Start the receiver
  
  Serial.begin(9600);  
}

void loop() {
   
  setSpeed(177);

  
  uint8_t buf[VW_MAX_MESSAGE_LEN];
  uint8_t buflen = VW_MAX_MESSAGE_LEN;

  if (vw_get_message(buf, &buflen)) { // check to see if anything has been received
    int i;
   
    char cenas[buflen+1];
    for (i = 0; i < buflen; i++) {
      cenas[i] = (char) buf[i];  
    }
    cenas[i] = '\0';
 
    if (strncmp(cenas, "LMR-I", 4) == 0) {      
      key = cenas[5];
      move(key); 
    }
  }
}


void move(int key) {
  switch (key) {
    case 119: case 87: goForward(); break; // w/W
    case 115: case 83: goBackwards(); break; // s/S
    case 97: case 65: goLeft(); break; // a/A
    case 100: case 68: goRight(); break; // d/D    
    default: stopRobot(); break;
  }
}

void setSpeed(int value) {
  analogWrite(leftEnable, value); // output speed as PWM value
  analogWrite(rightEnable, value); // output speed as PWM value  
}

void stopRobot() {
  digitalWrite(left1A, LOW);
  digitalWrite(left2A, LOW);
  
  digitalWrite(right3A, LOW);
  digitalWrite(right4A, LOW);
  
  //delay(25);
}

void goBackwards() { 
  //just invert the above values for reverse motion,
  // i.e. motor1APin = HIGH and motor2APin = LOW
  digitalWrite(left1A, HIGH); // set leg 1 of the H-bridge high
  digitalWrite(left2A, LOW); // set leg 2 of the H-bridge low
  
  digitalWrite(right3A, HIGH);
  digitalWrite(right4A, LOW);
  
}

void goForward() {
  digitalWrite(left1A, LOW);
  digitalWrite(left2A, HIGH);
  
  digitalWrite(right3A, LOW);
  digitalWrite(right4A, HIGH);
}

void goRight() {
  digitalWrite(left1A, HIGH);
  digitalWrite(left2A, LOW);
  
  digitalWrite(right3A, LOW);
  digitalWrite(right4A, HIGH);
}

void goLeft() {
  digitalWrite(left1A, LOW);
  digitalWrite(left2A, HIGH);
  
  digitalWrite(right3A, HIGH);
  digitalWrite(right4A, LOW);
}


