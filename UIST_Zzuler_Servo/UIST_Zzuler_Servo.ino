#include <Servo.h>

Servo right; 
Servo left;
Servo nose;
Servo lowhead;

int rightPin = 5;
int leftPin = 6;
int nosePin = 7;
int lowheadPin = 4;

int serialInArray[] = {0, 90, 90, 90};
int serialCount = 0;

void setup()
{
  Serial.begin(9600);
  right.attach(rightPin);
  left.attach(leftPin);
  nose.attach(nosePin);
  lowhead.attach(lowheadPin);

  pinMode(12, OUTPUT);

}

void loop()
{
  if (serialInArray[0] == 246 || serialInArray[0] == 247 || serialInArray[0] == 248) {
    nose.write (90);
  }
  else if (serialInArray[0] > 249) {
    nose.write (180);
  }
  else if (serialInArray[0] < 246) {
    nose.write (0);
  }
  right.write (serialInArray[1]);
  left.write (serialInArray[2]);
  lowhead.write (serialInArray[3]);

//  digitalWrite(12, HIGH);   // turn the LED on (HIGH is the voltage level)
//  delay(100);              // wait for a second
//  digitalWrite(12, LOW);    // turn the LED off by making the voltage LOW
//  delay(100);              // wait for a second
}

void serialEvent() {
  int inByte = Serial.read();
  serialInArray[serialCount] = inByte;
  serialCount++;
  if (serialCount > 3 ) {
    serialCount = 0;
  }
}
