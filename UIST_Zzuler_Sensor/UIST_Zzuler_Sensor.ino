int flexVal = 0;
int rightPMVal = 0;
int leftPMVal = 0;
int lowheadPMVal = 0;
int inByte = 0; // incoming serial byte
int flexPin = A0; //flex sensor
int rightPM = A1; //potentialmeter
int leftPM = A2; //potentialmeter
int lowheadPM = A3; //potentialmeter

int rightMin = 90;
int leftMin = 5;
int leftMax = 95;
int lowHeadMin = 40;
int lowHeadMax = 140;

void setup()
{
  Serial.begin(9600);
  establishContact();
}
void loop()
{
  if (Serial.available() > 0) {

    inByte = Serial.read();

    flexVal = analogRead(flexPin);
    delay(10);
    rightPMVal = analogRead(rightPM);
    leftPMVal = analogRead(leftPM);
    lowheadPMVal = analogRead(lowheadPM);

    int flexmapvalue = map(flexVal, 0, 1023, 0, 255);
    //int rightmapvalue = map(right, 227, 625, 180, 90);
    //int leftmapvalue = map(left, 739, 341, 5, 95);
    //int lowheadmapvalue = map(lowhead, 0, 1023, 0, 180) + 25;

    int mappedVals[3] = {rightPMVal, leftPMVal, lowheadPMVal};
    valueMapping(mappedVals);
    Serial.write(flexmapvalue);
    Serial.write(mappedVals[0]);
    Serial.write(mappedVals[1]);
    Serial.write(mappedVals[2]);
  }
}

void establishContact() {
  while (Serial.available() <= 0) {
    Serial.print('A');
    delay(300);
  }
}

void valueMapping(int *mappedVals) {


  //int rightmapvalue = map(right, 227, 625, 180, 90);
  //int leftmapvalue = map(left, 739, 341, 5, 95);
  //int lowheadmapvalue = map(lowhead, 0, 1023, 0, 180) + 25;

  int rightMapVal = map(mappedVals[0], 227, 625, 180, 90);
  if (rightMapVal < rightMin) {
    mappedVals[0] = rightMin;
  } else {
    mappedVals[0] = rightMapVal;
  }

  int leftMapVal = map(mappedVals[1], 739, 341, 5, 95);
  if (leftMapVal < leftMin) {
    mappedVals[1] = leftMin;
  }
  else if (leftMapVal > leftMax) {
    mappedVals[1] = leftMax;
  } else {
    mappedVals[1] = leftMapVal;
  }
  
  int lowHeadMapVal = map(mappedVals[2], 0, 1023, 0, 180) + 20;
  if (lowHeadMapVal < lowHeadMin) {
    mappedVals[2] = lowHeadMin;
  }
  else if (lowHeadMapVal > lowHeadMax) {
    mappedVals[2] = lowHeadMax;
  } else {
    mappedVals[2] = lowHeadMapVal;
  }
}

