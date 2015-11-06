public class TimeBlock {
   
  public int xPos = 0;
  public List<Integer> data;
  int type;
  int id;
  int y;
  public int xSize;
  int ySize;
  boolean onFocus = false;
    
  TimeBlock(int xPos, List<Integer> data, int type, int id) {
    this.xPos = xPos;
    this.data = data;
    this.type = type;
    this.id = id;
    this.xSize = int(data.size()*2.398);
  }
  
  public void Display(int x, int y, int size, int type){
    this.y = y;
    this.ySize = size;
    this.xSize = int(data.size()*2.398);
    
    switch(type) {
     case 1: fill(0, 255, 255, 200); break;
     case 2: fill(60, 179, 113, 200); break;
     case 3: fill(255, 215, 0, 200); break;
     case 4: fill(12, 23, 200, 200); break;
    }
    
    if(onFocus){
      strokeWeight(2);
      stroke(0, 0, 0);
      //println("now onfocus");
    }
    rect(xPos, y, xSize, ySize);
    noStroke();
    
    
    // textcolor
    fill(255);
    int textSize =10;//display text relative to its size
    textSize(textSize);
    String outputText = "";
    switch(type){
     case 1:  outputText="nose"; break;
     case 2:  outputText="right"; break;
     case 3:  outputText="left"; break;
     case 4:  outputText="head"; break;
    }
    text((id+1)+" : "+outputText, xPos, y, 40, 40);  // Text wraps within text box
    
  }
  
  public boolean isTimeBlock(int mX, int mY) {
    if(mX>xPos && mX<xPos+xSize && mY>y && mY <y+ySize){
       return true; 
    }
    else{
      return false;
    }
  }
  
  public void movingBlock(int mX){
     this.xPos = mX;
  }
  
  public void setOnFocus() {
    onFocus = true;
  }
  
  public void setOffFocus() {
    onFocus = false; 
  }
  
  public boolean getOnFocus(){
    return onFocus; 
  }
  
  public void moveToLeft(){
    this.xPos = this.xPos - 2;
  }
  
  public void moveToRight(){
    this.xPos = this.xPos + 2;
  }
  
  public void scaleUp() {
    // speed down - padding
    for(int i=0;i<data.size();i=i+2) {
      data.add(i+1,data.get(i));
    }
    
  }
  
  public void scaleDown() { // speed up - delete middle
   List<Integer> temp = new ArrayList<Integer>();
   for(int i=0;i < data.size();i=i+2) {
      temp.add(data.get(i));
    }   
    data.clear();
    for(int i=0; i<temp.size();i++) {
      data.add(temp.get(i)); 
    }   
    
  }
  
  
  
}