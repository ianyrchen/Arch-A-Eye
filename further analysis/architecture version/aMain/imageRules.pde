enum Rules {
  RULEOFTHIRDS,
  GOLDENMEAN,
  GOLDENTRIANGLE
}

ArrayList<Line> LinesForGoldenTriangle = new ArrayList<Line>();

class Coordinate
{
  float x, y;
  private boolean isOccupiedByText;
  private boolean isOccupiedByImg;
  
  public Coordinate(float x, float y) {
    this.x = x;
    this.y = y;
    isOccupiedByText = false;
  }
  
  public boolean GetIsOccupiedByText()
  {
    return isOccupiedByText;
  }
  
  public void SetIsOccupiedByText(boolean occupied)
  {
    isOccupiedByText = occupied;
  }
  
  public boolean GetIsOccupiedByImg()
  {
    return isOccupiedByImg;
  }
  
  public void SetIsOccupiedByImg(boolean occupied)
  {
    isOccupiedByImg = occupied;
  }
}

// used to keep track of current grid's coordinates
class GridCoordinates
{
  private ArrayList<Coordinate> coordinates;
  
  public GridCoordinates() {
    coordinates = new ArrayList<Coordinate>();
  }
  
  public void AddCoordinate(float x, float y)
  {
    Coordinate co = new Coordinate(x,y);
    coordinates.add(co);
  }
  
  public ArrayList<Coordinate> GetCoordinates()
  {
    return coordinates;
  }
  
  public Coordinate GetCoordinateByIndex(int i)
  {
    return coordinates.get(i);
  }
  
  public Coordinate GetFirstUnoccupiedCoordinate()
  {
    Coordinate result = null;
    
    for(int i = 0; i < coordinates.size(); i++)
    {
      if(coordinates.get(i).GetIsOccupiedByImg() == false)
        result = coordinates.get(i);
    }
    return result;
  }
}

class Line
{
  private float x1;
  private float y1;
  private float x2;
  private float y2;
  
  public Line(float px1, float py1, float px2, float py2)
  {
    x1 = px1;
    y1 = py1;
    x2 = px2;
    y2 = py2;
  }
  
  public float getYValueByX(float x)
  {
    float y = 0;
    if(x2 != x1)  
      y = ((y2-y1)/(x2-x1)) *(x-x1) +y1;
      
    return y;
  }
  
  public float getXValueByY(float y)
  {
    float x = 0;
    
    if(y2 != y1)  
      x = ((x2-x1)/(y2-y1)) *(y-y1) + x1;
      
    return x;
  } 
}


// Generate the focal points' coordinates based on Rule of Thirds,  Golden Mean and Golden Triangle
GridCoordinates generatePivotalPointsByRules(Rules rule){
  stroke(240);
  //stroke(255); // white color
  GridCoordinates newCoordinates = new GridCoordinates();
  float cellWidth = 0;
  float cellHeight = 0;
    
  if(rule == Rules.RULEOFTHIRDS)
  {
    cellWidth = width/3;
    cellHeight = height/3;
  
    for(int i = 1; i < 3; i++)
    {    
      for(int j = 1; j < 3; j++)
      {
        newCoordinates.AddCoordinate(cellWidth*i, cellHeight*j);
      }
    }
  }
  
  if(rule == Rules.GOLDENMEAN)
  {
    float xOffset = width/(1+SCALE);
    float yOffset = height/(1+SCALE);
    
    // Add 4 pivotal points
    newCoordinates.AddCoordinate(xOffset, yOffset);
    newCoordinates.AddCoordinate(xOffset, height - yOffset);
    newCoordinates.AddCoordinate(width - xOffset, yOffset);
    newCoordinates.AddCoordinate(width - xOffset, height - yOffset);
  }

  if(rule == Rules.GOLDENTRIANGLE)  
  {  
    //Two focal points coordinates
    float squareSum = width*width + height*height;
    float x1 = width*height*height/squareSum;
    float y1 = height*height*height/squareSum;
    float x2 = width*width*width/squareSum;
    float y2 = width*width*height/squareSum;
    
    newCoordinates.AddCoordinate(x1, y1); // the point with bigger y value and bigger x value
    //println("\n\nGOLDEN TRIANGLE point x1="+x1+" y1="+y1 +"----------------");
    
    // there are 3 lines for Golden Triangle rule
    Line newL = new Line(x1, y1, 0, height); 
    LinesForGoldenTriangle.add(newL);
    newCoordinates.AddCoordinate(x2, y2);
    newL = new Line(x2, y2, width, 0); 
    LinesForGoldenTriangle.add(newL);
    newL = new Line(x2, y2, x1, y1); 
    LinesForGoldenTriangle.add(newL);
  }
  
  return newCoordinates;  
}

void drawGridByRule(Rules rule, int currentBGIngNum)
{
  if(currentBGIngNum >=8)
    background(backgroundColor);
  stroke(240);
  //stroke(255); // white color
    
  if(rule == Rules.RULEOFTHIRDS)
  {
    float cellWidth = width/3;
    float cellHeight = height/3;

    for(int i = 1; i < 3; i++)
    {
      line(cellWidth*i, 0, cellWidth*i, height); //draw vertical lines
    }
  
    for(int j = 1; j < 3; j++) //draw horizontal lines
    {
      line(0, cellHeight*j, width, cellHeight*j);
    }
  }
  
  if(rule == Rules.GOLDENMEAN)
  {
    float xOffset = width/(1+SCALE);
    float yOffset = height/(1+SCALE);
    
    // draw grid
    line(xOffset, 0, xOffset, height);
    line(width - xOffset, 0, width - xOffset, height);
    line(0, yOffset, width, yOffset);
    line(0, height-yOffset, width, height-yOffset);
  }

  if(rule == Rules.GOLDENTRIANGLE)  
  {  
    
    line(0, 0, width, height); //diagnal line
    
    //Two focal points coordinates
    float squareSum = width*width + height*height;
    float x1 = width*height*height/squareSum;
    float y1 = height*height*height/squareSum;
    float x2 = width*width*width/squareSum;
    float y2 = width*width*height/squareSum;
    
    // Draw penperdicular lines
    line(0, height, x1, y1);
    line(width, 0, x2, y2);
  }
}
