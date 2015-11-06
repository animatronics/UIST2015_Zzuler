import processing.sound.*;
import controlP5.*;
import processing.serial.*;
import java.util.*;


ControlP5 cp5;
SoundFile file;

boolean loading = false;
boolean mirroring = false;

int myColor = color(255);
int c1, c2;
int w=1357; //full screen width
int h=767;
float n, n1;
PImage elephant_img;
int button_num=0; //for selecting input

Serial myPort; //sensor port
Serial myPort2; //servo port
int[] serialInArray = new int[4]; 
int serialCount=0;
boolean firstContact = false;

int nose, right, left, head;

//kdpark variable
int getValueFromSensor = 0;
boolean nowRecording = false;
boolean nowPlaying = false;
int selectSensor = 0; // 1 - nose, 2 - right, 3 - left, 4 - head
boolean selectNose = false;
boolean selectRight = false;
boolean selectLeft = false;
boolean selecthead = false;

Toggle toggleNose;
Toggle toggleRight;
Toggle toggleLeft;
Toggle togglehead;
Toggle toggleMirror;


Textlabel msgLabel;
Textlabel sensorLabel;

Slider slider;
int slideValue = 0;


// Block UI
RecordedBlock leftRecorded;

List<RecordedBlock> block_array = new ArrayList<RecordedBlock>(); 
boolean nowMoving = false;

// Block in TimeLine UI
boolean dragOnTimeline = true;

// Mouse event
int clickhold = 0;
int dist = 0; // distance between mouseX and xPos of Timeblock

// TimeLine UI
TimeLine leftLine;
TimeLine rightLine;
TimeLine headLine;
TimeLine noseLine;

// TimeLine line rect
int timeline_startX = 0;
int timeline_startY = 0;

// TimeLine Block moving
boolean nowClick = false;

// section UI variable
int sec2X, sec2Y, sec2Margin, sec3X, sec3Y, sec3Margin;
boolean sec2Received, sec3Received;

List<Integer> list_sensor = new ArrayList<Integer>();

List<Integer> head_sensor = new ArrayList<Integer>();
List<Integer> right_sensor = new ArrayList<Integer>();
List<Integer> left_sensor = new ArrayList<Integer>();
List<Integer> nose_sensor = new ArrayList<Integer>();

List<Integer> input_array = new ArrayList<Integer>();
List<Integer> output_array = new ArrayList<Integer>();

int lowTEST = 0;
int lowStart = 0;

void setup() {
  loading = true;
  //fullScreen();
  size(1357, 767);
  //smooth();
  // surface.setResizable(true); //changing screen size
  noStroke();
  cp5=new ControlP5(this);
  println(Serial.list());
  String portName = Serial.list()[3];
  myPort = new Serial(this, portName, 9600);
  String portName2 = Serial.list()[4];
  myPort2 = new Serial(this, portName2, 9600);


  //----------------section 1--------------------------------------

  //slider for trimming
  slider = cp5.addSlider("")
    .setRange(0, 255)
    .setValue(0)
    .setPosition(w/23*4.2, h/13*5)
    .setSize(w/23*5, h/(13*2))
    .setLabelVisible(false);
  ;

  //recording button in 1section
  cp5.addButton("record")
    .setValue(0)
    .setPosition(w/23*1.4, h/13*5)
    .setSize(w/23, h/(13*2))
    ;

  //recording stop button in 1section
  cp5.addButton("recordStop")
    .setValue(0)
    .setPosition(w/23*2.8, h/13*5)
    .setSize(w/23, h/(13*2))
    .setCaptionLabel("STOP");


  //trim button in 1section
  cp5.addButton("send")
    .setValue(0)
    .setPosition(w/23*9.6, h/13*5)
    .setSize(w/23, h/(13*2));

  elephant_img = loadImage("elephant.png"); //elephant image


  /// toggle !!
  toggleRight = cp5.addToggle("selectRight")
    .setPosition(w/23*2.9, h/13*3.5)
    .setSize(w/23, h/(13*2))
    .setCaptionLabel("Right arm")
    .setColorBackground(color(60, 179, 113, 100))
    .setColorForeground(color(60, 179, 113, 170))
    .setColorActive(color(60, 179, 113, 255))
    ;

  toggleLeft = cp5.addToggle("selectLeft")
    .setPosition(w/23*8.5, h/13*3.5)
    .setSize(w/23, h/(13*2))
    .setCaptionLabel("Left ARM")
    .setColorBackground(color(255, 255, 0, 100))
    .setColorForeground(color(255, 255, 0, 170))
    .setColorActive(color(255, 255, 0, 255))
    ;

  togglehead = cp5.addToggle("selecthead")
    .setPosition(w/23*5, h/13*1.5)
    .setSize(w/23, h/(13*2))
    .setCaptionLabel("Head")
    .setColorBackground(color(12, 23, 200, 100))
    .setColorForeground(color(12, 23, 200, 170))
    .setColorActive(color(12, 23, 200, 255))
    ;

  toggleNose = cp5.addToggle("selectNose")
    .setPosition(w/23*8.5, h/13*2.6)
    .setSize(w/23, h/(13*2))
    .setCaptionLabel("Nose")
    .setColorBackground(color(255, 255, 0, 100))
    .setColorForeground(color(255, 255, 0, 170))
    .setColorActive(color(255, 255, 0, 255))
    .setVisible(false)
    ;

  toggleMirror = cp5.addToggle("selectMirror")
    .setPosition(w/23*1.4, h/13*1.1)
    .setSize(w/23, h/(13*2))
    .setCaptionLabel("Mirroring")
    ;

  // text label


  msgLabel = cp5.addTextlabel("msg")
    .setText("")
    .setPosition(100, 370)
    .setColorValue(0x00000000)
    .setFont(createFont("Arial", 15))
    ;

  sensorLabel = cp5.addTextlabel("sensormsg")
    .setText("")
    .setPosition(100, 350)
    .setColorValue(0x00000000)
    .setFont(createFont("Arial", 15))
    ;



  //---------------section 2----------------------------------------------
  sec2X = w/23*12;
  sec2Y = h/13;
  sec2Margin  =20;
  sec2Received = false;


  //---------------section 3----------------------------------------------

  cp5.addButton("act_play")
    .setValue(0)
    .setPosition(w/23*1.5, h/13*11)
    .setSize(w/23, h/(13*2))
    .setCaptionLabel("Play");

  cp5.addButton("act_stop")
    .setValue(0)
    .setPosition(w/23*3.5, h/13*11)
    .setSize(w/23, h/(13*2))
    .setCaptionLabel("Stop");

  // timeline
  sec3X = w/23;
  sec3Y = h/13*7;
  sec3Margin  =20;
  sec3Received = false;

  int origin_timeline_x = sec3X+sec3Margin;
  int origin_timeline_y = sec3Y+sec3Margin;
  int timeline_length = w - ((sec3Margin+sec3X)*2);

  noseLine = new TimeLine( origin_timeline_x, origin_timeline_y, timeline_length, 1) ;
  rightLine = new TimeLine( origin_timeline_x, origin_timeline_y+50, timeline_length, 2) ;
  leftLine = new TimeLine( origin_timeline_x, origin_timeline_y+100, timeline_length, 3) ;
  headLine = new TimeLine( origin_timeline_x, origin_timeline_y+150, timeline_length, 4) ;

  file = new SoundFile(this, "selfie10.mp3");

  loading=false;
}

////////////////////
// DRAWING!!!  /////
////////////////////

void draw() {
  background(255, 255, 255);
  //1section_left rectangle   
  fill(120, 120, 120);
  rect(w/23, h/13, w/23*10, h/13*5);

  //2section_right rectangle
  fill(120, 120, 120);
  rect(w/23*12, h/13, w/23*10, h/13*5);

  //3section_bottom rectangle
  fill(120, 120, 120);
  rect(w/23, h/13*7, w/23*21, h/13*5);

  image(elephant_img, w/23*1.7, h/13*2, w/23*8, h/13*3);





  /// TIMELINE Display

  noseLine.Display(0, 255, 255, 100);
  // nose is MUSIC
  // Text wraps within text boxtext((id+1)+" : "+outputText, xPos, y, 40, 40);  // Text wraps within text box

  rightLine.Display(60, 179, 113, 100);
  leftLine.Display(255, 215, 0, 100);  
  headLine.Display(12, 23, 200, 100);






  // now recording, slide adjust
  if (nowRecording == true) {
    slider.setLabelVisible(false);

    //switch (selectSensor) {
    //case 1: 
    //  slider.setValue(left);
    //  break;
    //case 2: 
    //  slider.setValue(right); 
    //  break;
    //case 3: 
    //  slider.setValue(head); 
    //  break;
    //case 4: 
    //  slider.setValue(nose); 
    //  break;
    //}

    slider.setValue(slideValue%255);
    slideValue+=3;
  }





  ////////Display Recorded Block
  for (int i=0; i < block_array.size(); i++)
  {
    block_array.get(i).Display(); 

    // caption & drag event
    // kdpark
    if (mousePressed) {
      block_array.get(i).isClicked(mouseX, mouseY);
      if (block_array.get(i).output) {

        nowMoving = true;
        dragOnTimeline = false;
        // if in noseline area, checking mouseX, mouseY+20 emphasize the noseline.
        if (mouseX>sec3X+sec3Margin && mouseX<sec3X+sec3Margin+w-((sec3Margin+sec3X)*2)
          && mouseY+20>sec3Y+sec3Margin && mouseY+20<sec3Y+sec3Margin+40
          && block_array.get(i).type==1) { //sec3X+sec3Margin, sec3Y+sec3Margin, sec3LineLength
          noseLine.Display(0, 255, 255, 250);
          dragOnTimeline = true;
        }
        // if in rightline area,
        if (mouseX>sec3X+sec3Margin && mouseX<sec3X+sec3Margin+w-((sec3Margin+sec3X)*2)
          && mouseY+20>sec3Y+sec3Margin+50 && mouseY+20<sec3Y+sec3Margin+40+50
          && block_array.get(i).type==2) { //sec3X+sec3Margin, sec3Y+sec3Margin, sec3LineLength
          rightLine.Display(60, 179, 113, 250);
          dragOnTimeline = true;
        }
        // if left
        if (mouseX>sec3X+sec3Margin && mouseX<sec3X+sec3Margin+w-((sec3Margin+sec3X)*2)
          && mouseY+20>sec3Y+sec3Margin+100 && mouseY+20<sec3Y+sec3Margin+140
          && block_array.get(i).type==3) { //sec3X+sec3Margin, sec3Y+sec3Margin, sec3LineLength
          leftLine.Display(255, 215, 0, 250);
          dragOnTimeline = true;
        }
        // if head
        if (mouseX>sec3X+sec3Margin && mouseX<sec3X+sec3Margin+w-((sec3Margin+sec3X)*2)
          && mouseY+20>sec3Y+sec3Margin+150 && mouseY+20<sec3Y+sec3Margin+190
          && block_array.get(i).type==4) { //sec3X+sec3Margin, sec3Y+sec3Margin, sec3LineLength
          headLine.Display(12, 23, 200, 250);
          dragOnTimeline = true;
        }

        switch(block_array.get(i).type) {
        case 1: 
          strokeWeight(2);
          stroke(0, 0, 0);
          fill(0, 255, 255, 220);
          break;
        case 2: 
          strokeWeight(2);
          stroke(0, 0, 0);
          fill(60, 179, 113, 220);
          break;
        case 3: 
          strokeWeight(2);
          stroke(0, 0, 0);
          fill(255, 215, 0, 220);
          break;
        case 4: 
          strokeWeight(2);
          stroke(0, 0, 0);
          fill(12, 23, 200, 220);
          break;
        }

        // now drawing moving block
        rect(mouseX, mouseY, 40, 40);
        noStroke();
      }
    } else {
      if (block_array.get(i).output) {
        block_array.get(i).output = false;

        if (nowMoving == true) {
          // only once exec.
          // now check where is mouse point now
          // mouseX, mouseY
          if (dragOnTimeline) {
            //println("i" + i);

            // if in nose, if right place, make TimeBlock
            println("DRAG ON!" + i + "th block");
            println("event (1n 2r 3l 4h) : "+block_array.get(i).type);
            println("mouseX:"+ mouseX);

            List<Integer> newData = new ArrayList<Integer>();
            newData.addAll(block_array.get(i).Data);

            TimeBlock tb = new TimeBlock(mouseX, newData, block_array.get(i).type, i);

            switch(block_array.get(i).type) {
            case 1:
              noseLine.AddBlock(tb);
              break;
            case 2:
              rightLine.AddBlock(tb);
              break;
            case 3:
              leftLine.AddBlock(tb);
              break;
            case 4:
              headLine.AddBlock(tb);
              break;
            }
          }

          nowMoving = false;
        }
      }
    }
  }


  ////////////// TIMELINE drawing
  if (nowPlaying == true) {

    fill(0, 0, 0, 200);
    rect(timeline_startX+15, 433, 3, 192);
    timeline_startX+=2;
  } else { // value init
    timeline_startX = 79;
  }


  //////////// Time Block Moving & rightclick ////

  if (mousePressed) {
    // for checking continuous click event
    clickhold ++;


    // if click position is the one of the Time block
    for (int i=0; i<rightLine.block_array.size(); i++) {

      if ( rightLine.block_array.get(i).isTimeBlock(mouseX, mouseY)) {

        if (mouseButton == LEFT) {
          //println(i+" st block in right Line");
          //println(rightLine.block_array.get(i).type);

          if (clickhold == 1) { // get dist
            dist = mouseX - rightLine.block_array.get(i).xPos;
          }
          if (clickhold > 1) { // moving considering dist
            rightLine.block_array.get(i).movingBlock(mouseX-dist);
          }         

          // not continuous click
          if (clickhold == 1) {
            if (rightLine.block_array.get(i).getOnFocus()) {
              rightLine.block_array.get(i).setOffFocus();
            } else {
              rightLine.block_array.get(i).setOnFocus();
            }
          }
        } else { // Mouse RIGHT CLICK
          // call right menu
        }
      }
    }

    // if click position is the one of the Time block
    for (int i=0; i<leftLine.block_array.size(); i++) {

      if ( leftLine.block_array.get(i).isTimeBlock(mouseX, mouseY)) {

        if (mouseButton == LEFT) {
          //println(i+" st block in left Line");
          //println(leftLine.block_array.get(i).type);

          if (clickhold == 1) { // get dist
            dist = mouseX - leftLine.block_array.get(i).xPos;
          }
          if (clickhold > 1) { // moving considering dist
            leftLine.block_array.get(i).movingBlock(mouseX-dist);
          }         

          // not continuous click
          if (clickhold == 1) {
            if (leftLine.block_array.get(i).getOnFocus()) {
              leftLine.block_array.get(i).setOffFocus();
            } else {
              leftLine.block_array.get(i).setOnFocus();
            }
          }
        } else { // Mouse left CLICK
          // call left menu
        }
      }
    }


    // if click position is the one of the Time block
    for (int i=0; i<headLine.block_array.size(); i++) {

      if ( headLine.block_array.get(i).isTimeBlock(mouseX, mouseY)) {

        if (mouseButton == LEFT) {
          //println(i+" st block in head Line");
          //println(headLine.block_array.get(i).type);

          if (clickhold == 1) { // get dist
            dist = mouseX - headLine.block_array.get(i).xPos;
          }
          if (clickhold > 1) { // moving considering dist
            headLine.block_array.get(i).movingBlock(mouseX-dist);
          }         

          // not continuous click
          if (clickhold == 1) {
            if (headLine.block_array.get(i).getOnFocus()) {
              headLine.block_array.get(i).setOffFocus();
            } else {
              headLine.block_array.get(i).setOnFocus();
            }
          }
        } else { // Mouse head CLICK
          // call head menu
        }
      }
    }


    // if click position is the one of the Time block
    for (int i=0; i<noseLine.block_array.size(); i++) {

      if ( noseLine.block_array.get(i).isTimeBlock(mouseX, mouseY)) {

        if (mouseButton == LEFT) {
          //println(i+" st block in nose Line");
          //println(noseLine.block_array.get(i).type);

          if (clickhold == 1) { // get dist
            dist = mouseX - noseLine.block_array.get(i).xPos;
          }
          if (clickhold > 1) { // moving considering dist
            noseLine.block_array.get(i).movingBlock(mouseX-dist);
          }         

          // not continuous click
          if (clickhold == 1) {
            if (rightLine.block_array.get(i).getOnFocus()) {
              noseLine.block_array.get(i).setOffFocus();
            } else {
              noseLine.block_array.get(i).setOnFocus();
            }
          }
        } else { // Mouse nose CLICK
          // call nose menu
        }
      }
    }
    //    get TimeBlock ID
    //
  } else { // if not click
    clickhold = 0;
  }
}

void keyPressed() {
  /////// DELETE TIME BLOCK !!
  
  for (int i=0; i<rightLine.block_array.size(); i++) {
    if ( rightLine.block_array.get(i).getOnFocus()) { // if block get focus
      // delete
      if (key == BACKSPACE) {
        rightLine.block_array.remove(i);
      } else if (keyCode==LEFT) {
        rightLine.block_array.get(i).moveToLeft();
      } else if (keyCode==RIGHT) {
        rightLine.block_array.get(i).moveToRight();
      } else if (keyCode==UP) {
        rightLine.block_array.get(i).scaleUp();
      } else if (keyCode==DOWN) {
        rightLine.block_array.get(i).scaleDown();
      }
    }
  }

  //
  for (int i=0; i<leftLine.block_array.size(); i++) {
    if ( leftLine.block_array.get(i).getOnFocus()) { // if block get focus
      // delete
      if (key == BACKSPACE) {
        leftLine.block_array.remove(i);
      } else if (keyCode==LEFT) {
        leftLine.block_array.get(i).moveToLeft();
      } else if (keyCode==RIGHT) {
        leftLine.block_array.get(i).moveToRight();
      } else if (keyCode==UP) {
        leftLine.block_array.get(i).scaleUp();
      } else if (keyCode==DOWN) {
        leftLine.block_array.get(i).scaleDown();
      }
    }
  }

  //
  for (int i=0; i<headLine.block_array.size(); i++) {
    if ( headLine.block_array.get(i).getOnFocus()) { // if block get focus
      // delete
      if (key == BACKSPACE) {
        headLine.block_array.remove(i);
      } else if (keyCode==LEFT) {
        headLine.block_array.get(i).moveToLeft();
      } else if (keyCode==RIGHT) {
        headLine.block_array.get(i).moveToRight();
      } else if (keyCode==UP) {
        headLine.block_array.get(i).scaleUp();
      } else if (keyCode==DOWN) {
        headLine.block_array.get(i).scaleDown();
      }
    }
  }

  //
  for (int i=0; i<noseLine.block_array.size(); i++) {
    if ( noseLine.block_array.get(i).getOnFocus()) { // if block get focus
      // delete
      if (key == BACKSPACE) {
        noseLine.block_array.remove(i);
      } else if (keyCode==LEFT) {
        noseLine.block_array.get(i).moveToLeft();
      } else if (keyCode==RIGHT) {
        noseLine.block_array.get(i).moveToRight();
      } else if (keyCode==UP) {
        noseLine.block_array.get(i).scaleUp();
      } else if (keyCode==DOWN) {
        noseLine.block_array.get(i).scaleDown();
      }
    }
  }
}



////////// FUNCTION ////////// ////////// ////////// ////////// 

public void controlEvent(ControlEvent theEvent) {
  // println(theEvent.getController().getName());
  //n = 0;
}

// button record
public void record() {

  if (selectSensor == 0) {
    println("no sensor selected!");
  } else {
    // now start to getting sensor value!
    input_array.clear();
    nowRecording = true;    
    msgLabel.setText("Now Recording!");

    // left, right, head appending! At serialEvent Function!
  }
}

boolean finishRecording = false;
public void recordStop() {
  if (nowRecording) {
    nowRecording = false;
    slideValue=0;
    slider.setValue(255);
    slider.setLabelVisible(true);
    slider.setValueLabel("Recording SUCCESS");
    msgLabel.setText("STOP! Now you can use input values. : " + selectSensor);

    println(input_array.size());

    //toggleLeft.setState(false);
    //toggleRight.setState(false);
    //toggleNose.setState(false);
    //togglehead.setState(false);
    finishRecording = true;
  }
}

int numSend = 0;
public void send() {
  // send to input_array to block

  // only if finishing recording
  if (finishRecording) {

    if (numSend >= 0 && numSend < 10) {
      int originX = sec2X + sec2Margin;
      int originY = sec2Y + sec2Margin;
      int x[]= {originX, originX+50, originX+100, originX+150, originX+200, 
        originX+250, originX+300, originX+350, originX+400, originX+450}; 
      int y[] = {originY, originY, originY, originY, originY, 
        originY, originY, originY, originY, originY };
      // make block
      List<Integer> newArr = new ArrayList<Integer>();
      newArr.addAll(input_array);
      RecordedBlock newblock = new RecordedBlock(x[numSend], y[numSend], newArr, selectSensor, numSend);
      block_array.add(newblock);
    }
    numSend++;
  }
}


public void act_play() {
  
  toggleMirror.setValue(false);
  
  if (nowPlaying==false && !loading) { 

    file.play();


    // ready for output_array from left, right, head, nose
    output_array.clear();

    //temp
    nose_sensor.clear();
    right_sensor.clear();
    left_sensor.clear();
    head_sensor.clear();
    lowTEST = 0;

    // make initial signal
    for (int i =0; i<500; i++) {
      nose_sensor.add(0);
      right_sensor.add(90);
      left_sensor.add(90);
      head_sensor.add(90);
    }

    // position by part
    // todolist 11/5

    // this is one element of data
    // noseLine.block_array.get(i).data.get(j);

    for (int j=0; j < rightLine.block_array.size(); j++)
    {
      // set starting point to start
      int start = (int)((rightLine.block_array.get(j).xPos - 79)/2.398);
      int lastVal = 0;

      for (int k=0; k < rightLine.block_array.get(j).data.size(); k++) {

        //keep the final value by overwriting remains
        for (int l=start; l<right_sensor.size(); l++) {
          right_sensor.set(l, rightLine.block_array.get(j).data.get(k));
        }
        start++;
      }
    }

    for (int j=0; j < leftLine.block_array.size(); j++)
    {
      // set starting point to start
      int start = (int)((leftLine.block_array.get(j).xPos - 79)/2.398);
      int lastVal = 0;

      for (int k=0; k < leftLine.block_array.get(j).data.size(); k++) {

        for (int l=start; l<left_sensor.size(); l++) {
          left_sensor.set(l, leftLine.block_array.get(j).data.get(k));
        }
        start++;
      }
    }

    for (int j=0; j < headLine.block_array.size(); j++)
    {
      // set starting point to start
      int start = (int)((headLine.block_array.get(j).xPos - 79)/2.398);
      int lastVal = 0;

      for (int k=0; k < headLine.block_array.get(j).data.size(); k++) {

        for (int l=start; l<head_sensor.size(); l++) {
          head_sensor.set(l, headLine.block_array.get(j).data.get(k));
        }
        start++;
      }
    }

    for (int j=0; j < noseLine.block_array.size(); j++)
    {
      // set starting point to start
      int start = (int)((noseLine.block_array.get(j).xPos - 79)/2.398);
      int lastVal = 0;

      for (int k=0; k < noseLine.block_array.get(j).data.size(); k++) {

        for (int l=start; l<nose_sensor.size(); l++) {
          nose_sensor.set(l, noseLine.block_array.get(j).data.get(k));
        }
        start++;
      }
    }


    // composition -- when one block finish, final value must keep! 
    for (int i =0; i < nose_sensor.size(); i++)
    {
      output_array.add(nose_sensor.get(i));
      output_array.add(right_sensor.get(i));
      output_array.add(left_sensor.get(i));
      output_array.add(head_sensor.get(i));
    }
    println(output_array.size());
    // now playing start
    nowPlaying = true;
    println("start play");
    println(nowPlaying);
  }
}

public void act_stop() {
  if (!loading) {
    file.stop();
    if (nowPlaying==true ) {
      nowPlaying = false;
      lowTEST=0;
      println("finish by stop event");
    }
  }
}


/////////FUNCTION ////////// ////////// ////////// ////////// 


// toggle event
void selectLeft(boolean flag) {
  if (flag == true) {
    toggleRight.setState(false);
    toggleNose.setState(false);
    togglehead.setState(false);
    selectSensor = 3;
  } else {
    selectSensor = 0;
  }
}

void selectRight(boolean flag) {
  if (flag == true) {
    toggleLeft.setState(false);
    toggleNose.setState(false);
    togglehead.setState(false);
    selectSensor = 2;
  } else {
    selectSensor = 0;
  }
}

void selectNose(boolean flag) {
  if (flag == true) {
    toggleRight.setState(false);
    toggleLeft.setState(false);
    togglehead.setState(false);
    selectSensor = 1;
  } else {
    selectSensor = 0;
  }
}

void selecthead(boolean flag) {
  if (flag == true) {
    toggleRight.setState(false);
    toggleNose.setState(false);
    toggleLeft.setState(false);
    selectSensor = 4;
  } else {
    selectSensor = 0;
  }
}

void selectMirror(boolean flag) {
  mirroring = flag;
}




//



//public void record(){ //record button function _ receiving serial 
void serialEvent(Serial myPort) {  
  // read a byte from the serial port:
  int inByte = myPort.read();

  if (firstContact == false) {
    if (inByte == 'A') { 
      myPort.clear();          // clear the serial port buffer
      firstContact = true;     // you've had first contact from the microcontroller
      myPort.write('A');       // ask for more
    }
  } else {
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;

    // If we have 4 bytes:
    if (serialCount > 3 ) {

      //
      nose = serialInArray[0];
      right = serialInArray[1];
      left = serialInArray[2];
      head = serialInArray[3];

      // print the values (for debugging purposes only):
      //println(nose + "\t" + right + "\t" + left + "\t" + head + "\t");

      sensorLabel.setText("Sensor: "+nose + " " + right + " " + left + " " + head);



      // sensor recording
      if (nowRecording) {

        switch (selectSensor) {
        case 3: 
          input_array.add(left); 
          break;
        case 2: 
          input_array.add(right); 
          break;
        case 4: 
          input_array.add(head); 
          break;
        case 1: 
          input_array.add(nose); 
          break;
        }
      }

      // Send a capital A to request new sensor readings:
      myPort.write('A');
      // Reset serialCount:
      serialCount = 0;
    }
    if (mirroring) {
      myPort2.write(nose);
      myPort2.write(right);
      myPort2.write(left);
      myPort2.write(head);
    }

    if (nowPlaying) {

      //int inByte2 = myPort2.read();
      //if (firstContact == false) {
      // if (inByte2 == 'A') { 
      //   myPort2.clear();          // clear the serial port buffer
      //   firstContact = true;     // you've had first contact from the microcontroller
      //   myPort2.write('A');       // ask for more
      // }
      //} 
      //else {

      //  if (lowTEST == 0 ) {
      //    lowStart = millis();
      //  } else if (lowTEST ==1200) {
      //    int duration = millis() - lowStart;
      //    //println(duration);
      //  }
      //  if (lowTEST<list_sensor.size())
      //  {
      //    //println(lowTEST);
      //    int lowByte = list_sensor.get(lowTEST);
      //    myPort2.write(lowByte);
      //    lowTEST++;
      //    //println(lowByte);
      //  }
      //}

      if (lowTEST < output_array.size())
      {
        int lowByte = output_array.get(lowTEST);
        myPort2.write(lowByte);
        lowTEST++;
        println(mirroring);
        //println(lowByte);
      } else {
        nowPlaying = false;
        lowTEST=0;
        println("finish by time out");
        file.stop();
      }
    }
    //myPort2.write(inByte);
  }
} 