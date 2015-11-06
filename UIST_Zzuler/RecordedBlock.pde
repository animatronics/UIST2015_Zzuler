public class RecordedBlock {

  private int X, Y;
  private int Length =1200;
  private int Size = 40;//Lengthze linearly increases as the length increases
  private int type = 1; // 1 - nose, 2 - right, 3 - left, 4 - head
  private List<Integer> Data;
  private String fromSensor="wow";
  private int id = 0;


  RecordedBlock(int x, int y, List<Integer> data, int type, int id) {
    this.X = x;
    this.Y = y;
    this.Data = data;
    this.type = type;
    this.id = id;
  }

  public void Display() {
    //text
    switch(type) {
    case 1: 
      fromSensor = "Nose";
      fill(0, 255, 255, 230);
      rect(X, Y, Size, Size);
      fill(255);
      break;
    case 2: 
      fromSensor = "Right";
      fill(60, 179, 113);
      rect(X, Y, Size, Size);
      fill(255);
      break;
    case 3: 
      fromSensor = "Left";
      fill(255, 215, 0);
      rect(X, Y, Size, Size);
      fill(255);
      break;
    case 4: 
      fromSensor = "Head";
      fill(12, 23, 200);
      rect(X, Y, Size, Size);
      fill(255);
      break;
    }


    //println(fromSensor + type);
    int textSize =Size/4;//display text relative to its size
    textSize(textSize);
    text((id+1)+" : "+fromSensor, X, Y, Size, Size);  // Text wraps within text box
  }

  public boolean output = false;
  public void isClicked(int mX, int mY) {
    int distX = mX - X;
    int distY = mY - Y;    
    if (mousePressed) {
      if (distX <= 40 && distX >= 0 && distY<=40 && distY>=0 ) {
        output = true;
      }
    }
  }


  public boolean isDragged(int mX, int mY) {

    int distX = mX - X;
    int distY = mY - Y;
    int areaXY = distX*distY;

    //kdpark
    if (distX <= 40 && distX >= 0 && distY<=40 && distY>=0 && mousePressed) {
      return true;
    } else {
      return false;
    }

    // seung jae
    //if ( distX> -20 && distY> -20 && mousePressed&& areaXY < (this.Size * this.Size) ) {
    //  return true;
    //} else 
    //{
    //  return false;
    //}
  }

  public boolean isCaptured(int lineMiddleX, int lineMiddleY, int forceDist) {

    if ( abs(X-lineMiddleX) < (Length/2) && abs(Y-lineMiddleY)<(forceDist+Size/2)) {

      if ( (abs(pmouseY-mouseY))>forceDist/4 && mousePressed ) {

        return false;
      }

      return true;
    } else {
      return false;
    }
  }
}