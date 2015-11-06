public class TimeLine {

  private int X, Y;
  private int forceDist = 10;
  private int Length;
  private int type; //1n 2r 3l 4h

  private int Size = 40;//Lengthze linearly increases as the length increases
  private int ArrLength =0;

  public List<TimeBlock> block_array = new ArrayList<TimeBlock>();


  TimeLine(int x, int y, int Leng, int type) {
    this.X = x;
    this.Y = y;
    this.Length = Leng;
    this.type = type;
  }

  public void Display(int x, int y, int z, int o) {
    fill(255);
    textSize(20);
    // text
    switch(type) {
    case 1:
      text("MUSIC : \\user\\Music\\The Chain Smokers - Selfie.mp3", X, Y, 1500, 40);
      break;
    case 2:
      text("Right Arm", X, Y, 400, 40);
      break;
    case 3:
      text("Left Arm", X, Y, 400, 40);
      break;
    case 4:
      text("Head", X, Y, 400, 40);
      break;
    }


    //display blue square
    fill(x, y, z, o);    
    rect(X, Y, Length, Size);//height is half of width

    for (int i=0; i<block_array.size(); i++) {
      block_array.get(i).Display(X, Y, Size, type);
    }
  }

  public void AddBlock(TimeBlock a) {
    // batch
    block_array.add(a);
    //
  }
}