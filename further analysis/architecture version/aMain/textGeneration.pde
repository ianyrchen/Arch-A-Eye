boolean isSerif = true;
float SCALE = (1+sqrt(5))/2;  //Golden ratio
float textSize = 0;

// variables to track the space that has been occupied
float xMin = 0;
float xMax = width;
float yMin = 0;
float yMax = height;

float txtX = 0;
float txtY = 0;
float upperBoundX = width;
float upperBoundY = height;

String generateFont(String fontType)
{
  //System.out.println("Method called: generateFont()");
  String aStr;
  HashSet<String> mySet = new HashSet<String>(Arrays.asList(PFont.list()));
  
  if(fontType.equals("serif"))
  {
    aStr = serifFonts[(int)random(serifFonts.length)];
    float check = random(1);
    //check = random(0.3);
    
    if(check > 0.3)
    {
      //System.out.println("Nothing");
    }
    else if(check > 0.2)
    {
      //System.out.println("check bold");
      if(mySet.contains(aStr + " Bold"))
        aStr = aStr + " Bold";
    }
    else if(check > 0.1)
    {
      //System.out.println("check light");
      if(mySet.contains(aStr + " Light"))
        aStr = aStr + " Light";
    }
    else
    {
      //System.out.println("check italic");
      if(mySet.contains(aStr + " Italic"))
        aStr = aStr + " Italic";
    }
    return aStr;
  }
  else if(fontType.equals("sansserif"))
  {
    isSerif = false;
    
    aStr = sanserifFonts[(int)random(sanserifFonts.length)];
    float check = random(1);
    //check = random(0.3);
    
    if(check > 0.3)
    {
      //System.out.println("Nothing");
    }
    else if(check > 0.2)
    {
      //System.out.println("check bold");
      if(mySet.contains(aStr + " Bold"))
        aStr = aStr + " Bold";
    }
    else if(check > 0.1)
    {
      //System.out.println("check light");
      if(mySet.contains(aStr + " Light"))
        aStr = aStr + " Light";
    }
    else
    {
      //System.out.println("check italic");
      if(mySet.contains(aStr + " Italic"))
        aStr = aStr + " Italic";
    }
    return aStr;
  }
  return null;
}


void drawHeaders()
{/*
  fill(headerColor);
  String fontStr;
  
  if(random(1) > 0.5)
    fontStr = generateFont("serif");
  else
    fontStr = generateFont("sansserif");
    
  if(!randomFont)  
    textFont(createFont("Catamaran-Light.ttf", 1));
  System.out.println("fontStr = " + fontStr);
  
  // start from 4th row in the input file
  for(int i = 3; i < input.length; i++)
  {
    //String[] words = input[i].split("\\s+");
    //float textSize;

    if(i == 3) //4th row is a sub-title
    {
      textSize = gridY / SCALE; // size becomes 1/1.618 of previous items
      textSize(textSize);  

      boolean vert = random(1) > 0.5; //<>//
      //vert = true;
      if(vert)
      {
        vertHeader(input[CurrentFileNumber][i], true, false); //<>//
      }
      else
      {
        horizontalHeader(input[CurrentFileNumber][i], true, false);
      }
    }
    else // other rows are description paragrahs
    {
      textSize = gridY / (SCALE * 2);
      
      if(!randomFont)
        textFont(createFont("Catamaran-Medium.ttf", 1));
      
      textSize(textSize);

      boolean vert = random(1) > 0.5;
      //vert=true;
      if(vert)
      {
        vertParagragh(i, false);
      }
      else
      { //<>//
        horizontalHeader(input[CurrentFileNumber][i], false, false);
      }     
    } 
  }*/
}


void drawTitle()
{
  /*float minRGB = Math.min(redBackground, Math.min(greenBackground, blueBackground));
  float maxRGB = Math.max(redBackground, Math.max(greenBackground, blueBackground));
  fill(maxRGB + minRGB - redBackground, maxRGB + minRGB - greenBackground, maxRGB + minRGB - blueBackground);
  */
  fill(titleColor);
  
  String fontStr = ""; //<>//
  
  if(isSerif == true && random(1) > 0.5)
    fontStr = generateFont("sansserif");
  else
    fontStr = generateFont("serif");
  System.out.println(fontStr);
  PFont fontOfStr;
  
  float fontBig = random(33, 48);
  
  {
    boolean vert = random(1) > 0.5;
    //vert = true;
    if(vert)
    {
      fontOfStr = createFont(fontStr, gridX);
      if(!randomFont)
        fontOfStr = createFont("Catamaran-Bold.ttf", gridX);
      textFont(fontOfStr);
      vertTitle(fontOfStr);
    }
    else
    {
      fontOfStr = createFont(fontStr, gridY);
      if(!randomFont)
        fontOfStr = createFont("Catamaran-Bold.ttf", gridY);
      textFont(fontOfStr);
      horizontalTitle(fontOfStr);
    }
  }
  //System.out.println(fontStr);
}

float getLongestWordLength(String[] words)
{
  float wordLength = 0;
  for(int i=0; i < words.length; i++)
  {
    if(textWidth(words[i]) > wordLength)
       wordLength = textWidth(words[i]);
  }
  
  return wordLength; //<>//
}

// This is for horizontal //<>//
// not capitalized = is a paragraph
// wraparound = biggest title
void setValidTextPostionLowerBound(boolean capitalized, float longestWordLength, float stringLength, boolean isTitle)
{
  println("\n Entering setValidTextPostionLowerBound()");  
  float lengthToTest = 0;
  
  if(!capitalized)
    lengthToTest = longestWordLength * 3;
  else
    lengthToTest = stringLength; //<>//
  
  // try 1000 times
  for(int k = 0; k< 2000; k++)
  {
    txtX = random(width * 0.8);
    txtY = random(height *0.8);

    if(capitalized)
    { //<>//
      if(isTitle && (txtX + stringLength * 0.6  < width) && (txtY + 3 * textSize )< height)
          break;
      else
      {
        if((txtX + lengthToTest < xMin || (txtX > xMax && txtX + lengthToTest < width)) 
          && (txtY + textSize < yMin || (txtY > yMax && txtY + 4*textSize < height)))
        {
          break;
        }
      }
    } 
    else  // give less randomness if it's a paragraph
    {
      if(txtY < yMin)
      {
        if((width - txtX) * (yMin - txtY) >= 16*610)
          break;
      }
      if(txtY > yMax)
      {
        if((width -txtX) * (height - txtY) >= 16*610)
          break;
      }
        
      if(txtY > yMin && txtY < yMax && txtX < xMin)
      {
        txtX = random(5);
        if((height - txtY) * (xMin - txtX) >= 16*610)
          break;
      }
       if(txtY > yMin && txtY < yMax && txtX > xMax)
      {
        txtX = random(5) + xMax;
        if((width-txtX) * (height - txtY) >= 16*610)
          break;
      }
    }
    
    //println("Before last try the lower bound: txtX= "+ txtX + " txtY = " + txtY);
    if(k == 999)  //still not find good values, set them to near the bottom
    {
      println("LAST RESORT to get lower bound in setValidTextPostionLowerBound");
      txtX = 10;
      txtY = height-50;
      break;
    } //<>//
  }
  
  println("Set the lower bound: txtX= "+ txtX + " txtY = " + txtY);
}


void setValidTextPostionVerticalOrigin(boolean capitalized, float longestWordLength, float stringLength)
{
  println("\n Entering setValidTextPostionVerticalOrigin");
  float lengthToTest = 0;
  
  if(!capitalized)
    lengthToTest = longestWordLength * 3;
  else
    lengthToTest = stringLength;
  
  // try 1000 times
  for(int k = 0; k< 2000; k++)
  {
    txtX = random(3*textSize, width);
    txtY = random(longestWordLength, height/2);

    if(capitalized)
    {
      if((txtX + lengthToTest < xMin || (txtX > xMax && txtX + lengthToTest < width)) 
        && (txtY + textSize < yMin || (txtY > yMax && txtY + 4*textSize < height)))
      {
        break;
      }
    } 
    else  // give less randomness if it's a paragraph
    {
      if(txtX < xMin)
      {
        if(txtX * (height - txtY) >= 16*610)
          break;
      }
      if(txtX > xMax)
      {
        if((txtX - xMax) * (height - txtY) >= 16*610)
          break;
      }
        
      if(txtX > xMin && txtX < xMax && txtY < yMin)
      {
        txtY = random(5);
        if(txtX * (yMin - txtY) >= 16*610)
          break;
      }
      if(txtX > xMin && txtX < xMax && txtY > yMax)
      {
        txtY = random(5) + yMax;
        if(txtX * (height - txtY) >= 16*610)
          break;
      }
    }
    
    //println("Before last try the lower bound: txtX= "+ txtX + " txtY = " + txtY);
    if(k == 999)  //still not find good values, set them to near origin
    {
      println("LAST RESORT to get lower bound in setValidTextPostionVerticalOrigin");
      
      txtY = 10;
      txtX = width;
        
      break;
    }
  }
  
  println("Set the vertical lower bound: txtX= "+ txtX + " txtY = " + txtY);
}

void setUpperBoundValues()
{
  if(txtY < yMin)
    {
      if(txtX < xMin) //<>//
      {
        upperBoundX = xMin;
        upperBoundY = height;
      }
      if(txtX > xMin && txtX < xMax)
      {
        upperBoundY = yMin;
        upperBoundX = width;
      }
      if(txtX > xMax)
      {
        upperBoundY = height;
        upperBoundX = width;
      }
    }
    if(txtY > yMax)
    {
      upperBoundY = height;
      upperBoundX = width;
    }
    
    if(txtY > yMin && txtY < yMax && txtX < xMin)
    {
      upperBoundY = height;
      upperBoundX = xMin;
    }
    if(txtY > yMin && txtY < yMax && txtX > xMax)
    {
      upperBoundY = height;
      upperBoundX = width;
    }
}

void setValidTextPostionUpperBound(boolean capitalized)
{
  println("\n Entering setValidTextPostionUpperBound()");  
  
  if(capitalized)
  {
    setUpperBoundValues(); //<>//
  }
  else // for paragraph: upperbound is the width and length of the ractangle, NOT the coordinates of an endpoint
  {
    for(int k=0; k < 1000; k++)
    {         
      if(txtY < yMin)
      {
        upperBoundX = random(width - txtX);
        upperBoundY = random(yMin - txtY);

      }
      if(txtY > yMax)
      {
        upperBoundX = random(width - txtX);
        upperBoundY = random(height - txtY);
      }
        
      if(txtY > yMin && txtY < yMax && txtX < xMin)
      {
        upperBoundX = random(xMin - txtX);
        upperBoundY = random(height - txtY);
      }
      if(txtY > yMin && txtY < yMax && txtX > xMax)
      {
        upperBoundX = random(width - txtX);
        upperBoundY = random(height - txtY);
      }
      
      if(upperBoundX * upperBoundY >= 16*610)
        break;
        
      if (k == 999)
      {
        upperBoundX = width;
        upperBoundY = height;
        println("LAST RESORT to get upper bound in setValidTextPostionUpperBoun");
        break;
      }
    }
  }
  println("Set the upper bound: upperBoundX= "+ upperBoundX + " upperBoundY = " + upperBoundY);
}

void setValidTextPostionVerticalUpperBound(boolean capitalized)
{
  println("\n Entering setValidTextPostionVerticalUpperBound()");  
  
  if(capitalized)
  {
    setUpperBoundValues();
  }
  else // for paragraph: upperbound is the width and length of the ractangle, NOT the coordinates of an endpoint
  {
    for(int k=0; k < 2000; k++)
    {         
      if(txtX < xMin)
      {
        upperBoundX = random(txtX);
        upperBoundY = random(height - txtY);

      }
      if(txtX > xMax)
      {
        upperBoundX = random(txtX - xMax);
        upperBoundY = random(height - txtY);
      }
        
      if(txtX > xMin && txtX < xMax && txtY < yMin)
      {
        upperBoundX = random(txtX);
        upperBoundY = random(yMin - txtY);
      }
      if(txtX > xMin && txtX < xMax && txtY > yMax)
      {
        upperBoundX = random(txtX);
        upperBoundY = random(height - txtY);
      }
      
      if(upperBoundX * upperBoundY >= 16*610)
        break;
        
      if (k == 999)
      {
        upperBoundX = width;
        upperBoundY = height;
        println("LAST RESORT to get upper bound in setValidTextPostionVerticalUpperBound()");
        break;
      }
    }
  }
  println("Set the upper bound: upperBoundX= "+ upperBoundX + " upperBoundY = " + upperBoundY);
}

//isTitle is biggest title
void vertHeader(String s, boolean capitalized, boolean isTitle)
{
  //if(capitalized || isTitle) s = s.toUpperCase();    
  /*
  System.out.println("\nEntering vertHeader, s = " + s + "; textSize = " +textSize);
  println("width = "+width); println("height = "+height);
  String[] words = s.split("\\s+");
  
  setValidTextPostionVerticalOrigin(capitalized, getLongestWordLength(words), textWidth(s));
  setValidTextPostionVerticalUpperBound(capitalized);

  //println("textSize = " + textSize);
  println("Before pushMatrix txtX = "  + txtX + ", txtY = " + txtY);
  pushMatrix();
  translate(txtX, txtY);
  rotate(PI/2);
  //println("after pushMatrix txtX = "  + txtX + ", txtY = " + txtY);
  
  if(capitalized)
  {
    if(isTitle)
      text(s, 0, 0, textWidth(s)*0.6, 2.5*textSize);
    else
      //text(s.toUpperCase(), 0, 0, textWidth(s), 4*textSize);
      text(s, 0, 0);
  }
  else
    text(s, 0, 0, width-txtX, height-txtY);

  popMatrix();
    //println("After popMatrix txtX = "  + txtX + ", txtY = " + txtY);
    
  xMax = txtX + textSize;
  yMin = txtY;

  if(!isTitle)
  {
    if(txtY + textWidth(s) > height) // wrap around
    {
      xMin = txtX - 2.5*textSize;; 
      yMax = txtY + getLongestWordLength(words);
    }
    else
    {
      xMin = txtX;
      yMax = txtY + textWidth(s);
    }
  }
  else
  {
    xMin = txtX - 2*textSize;
    yMax = txtY + 3*getLongestWordLength(words);
  }
  
  println("textWidth(input[i2]= "+textWidth(s));
  println("xMin = "  + xMin + " xMax = " + xMax);
  println("yMin = "  + yMin + " yMax = " + yMax);
  //ellipse(xMin, yMin, 5, 5);
  //ellipse(xMax, yMax, 5, 5); */
}

void vertParagragh(int i2, boolean capitalized)
{/*
  String s =  input[CurrentFileNumber][i2];
  //if(capitalized) s = s.toUpperCase();
  
  System.out.println("\nEntering vertParagragh");
  println("width = "+width); println("height = "+height);

  String[] words = s.split("\\s+");

  setValidTextPostionVerticalOrigin(false, getLongestWordLength(words), textWidth(s));
  setValidTextPostionVerticalUpperBound(false);

  println("Before pushMatrix txtX = "  + txtX + ", txtY = " + txtY);
  pushMatrix();
  translate(txtX, txtY);
  rotate(PI/2);
  if(capitalized)
    text(s, 0, 0, upperBoundX, upperBoundY);
  else
    text(s, 0, 0, upperBoundX, upperBoundY);
    //text(s, 0, 0,  width-txtX, height-txtY);
  popMatrix();
  
  xMax = txtX;
  yMin = txtY;
  if(txtY + textWidth(s) > height) // wrap around
  {
    xMin = max(0, txtX - 10*textSize); 
    yMax = txtY + 5*getLongestWordLength(words);
  }
  else
  {
    xMin = txtX - 2.5*textSize;
    yMax = txtY + textWidth(s);
  }
  
  println("textWidth(input[i2]= "+textWidth(s));
  println("xMin = "  + xMin + " xMax = " + xMax);
  println("yMin = "  + yMin + " yMax = " + yMax);
  ellipse(xMin, yMin, 5, 5);
  ellipse(xMax, yMax, 5, 5);  */
}

void horizontalHeader(String s, boolean capitalized, boolean isTitle)
{
 // if(capitalized || isTitle) s = s.toUpperCase();
 /*
  System.out.println("\nEntering horizontalHeader, s = " + s);
  println("width = "+width); println("height = "+height);

  String[] words = s.split("\\s+"); //<>//

  setValidTextPostionLowerBound(capitalized, getLongestWordLength(words), textWidth(s), isTitle);
  setValidTextPostionUpperBound(capitalized);

  if(capitalized)
  {
     if(isTitle)  //for big title
      text(s, txtX, txtY,  textWidth(s)*0.6, 2.5*textSize);
    else
      text(s, txtX, txtY,  upperBoundX, upperBoundY);
  }
  else  //paragraph
    text(s, txtX, txtY, upperBoundX, upperBoundY);

  xMin = txtX;
  yMin = txtY;
  if(isTitle) // biggest title
  {
      xMax = txtX + 3*getLongestWordLength(words);
      yMax = txtY + 2*textSize;
  }
  else
  {
    if(txtX + textWidth(s) > upperBoundX) // paragraph wrap around
    {
      xMax = txtX + 5*getLongestWordLength(words);
      yMax = txtY + 6*textSize;
    }
    else
    {
      println("not wrap around");
      xMax = txtX + textWidth(s);
      yMax = txtY + textSize;
    }
  }
  
  println("textWidth(input[i2]= "+textWidth(s));
  println("xMin = "  + xMin + " xMax = " + xMax);
  println("yMin = "  + yMin + " yMax = " + yMax);
  //ellipse(xMin, yMin, 5, 5);
  //ellipse(xMax, yMax, 5, 5); */
} //<>//
 //<>//
void vertTitle(PFont fontOfStr)
{/*
  System.out.println("\n==>Entering vertTitle ");
  println("width = "+width); println("height = "+height);
  String[] words = input[CurrentFileNumber][2].split("\\s+"); //<>//
  int factor = 1;
  int rand1 = (int)random(gridNumX - words.length * factor - factor);
  //System.out.println(rand1);
  int spaceY = (int)gridNumY / 4;
  boolean withShape = random(1) > 0.5;
  
  withShape = false;
  if(!withShape){
      textSize = gridY*1.5 ;
      vertHeader(input[CurrentFileNumber][2], true, true);
  }
  else
  {
    int numVertex = (int) random(3, 6);
    println("textsize =" +textSize);
    for(int i = 0; i < words.length; i++)
    {
      float rand2 = (int)random(gridNumY-spaceY);
      txtX = ((int)(gridNumX-rand1)) * (gridX + betweenX);
      if(txtX > width) 
        txtX = width - random(80, 100);
      txtY = rand2 * (gridY + betweenY);
      if (txtY > height)
        txtY = height - random(80, 100);
      System.out.println("txtX = " + txtX + " txtY = " +txtY);
    
      pushMatrix();
      translate(txtX, txtY);
      rotate(PI/2);
      textWithShapes(fontOfStr, words[i].toUpperCase(), 0, 0, numVertex);
      popMatrix();
      rand1 += (int)random(gridNumX - rand1 - 1 -(words.length - i) * factor)+ factor;
    } 
  }*/
}


void horizontalTitle(PFont fontOfStr)
{/*
  println("\n==> Entering horizontalTitle()");
  String[] words = input[CurrentFileNumber][2].split("\\s+"); //<>//
  boolean withShape = random(1) > 0.5;
  withShape = false;
  if(!withShape){
      textSize = gridY*1.5 ;
      horizontalHeader(input[CurrentFileNumber][2], true, true);
  }
  else
  {
    int rand2 = (int)random(gridNumY - words.length  - 1) + 1;
    int spaceX = (int)gridNumX / 5;

    int numVertex = (int) random(4, 11);
    for(int i = 0; i < words.length; i++)
    {
      float rand1 = (int)random(gridNumX-spaceX);
      txtX = rand1 * (gridX + betweenX);
      txtY = rand2 * (gridY + betweenY);
    
      if(txtX > width) 
        txtX = width - random(80, 100);
      if (txtY > height)
        txtY = height - random(80, 100);
        
      textWithShapes(fontOfStr, words[i].toUpperCase(), txtX, txtY, numVertex);

      rand2 += (int)random(gridNumY - rand2 - (words.length - i)) + 1;
    }
  }*/
}

void textWithShapes(PFont fontOfStr, String str, float xStart, float yStart, int numVertex)
{
  println("\n==> Entering textWithShape(): xStart = " +xStart + " yStart = " +yStart);
  float offSetX = 0;
  float offSetY = 0;
  textFont(fontOfStr);
  
  for(int i = 0; i < str.length(); i++)
  {
    float startDegree = random(0, 2 * PI);
    float interval = random(10, 50);
    interval = 70;
    
    if(random(1) > 0.9)
    {
      offSetX = random(5, 100);
      offSetY = random(5, 100);
    }
    offSetX = 0;
    offSetY = 0;
    String curStr = Character.toString(str.charAt(i));
    float diameter;
    float centerX;
    float centerY;
    
    if(lowerCaseDescent.contains(str.charAt(i)))
    {
      diameter = fontOfStr.ascent() * fontOfStr.getSize();
      centerX = textWidth(curStr) / 2.0 + xStart;
      // yPos - f.ascent()*fontSize
      centerY =yStart + fontOfStr.descent() * fontOfStr.getSize() - diameter / 2.0;
      line(0, yStart + fontOfStr.descent() * fontOfStr.getSize(), width, yStart + fontOfStr.descent() * fontOfStr.getSize());
    }
    else if(lowerCaseNorm.contains(str.charAt(i)))
    {
      diameter = (fontOfStr.ascent() - fontOfStr.descent()) * fontOfStr.getSize();
      centerX = textWidth(curStr) / 2.0 + xStart;
      centerY = yStart - diameter / 2.0;
    }
    else
    {
      diameter = fontOfStr.ascent()* fontOfStr.getSize();
      centerX = textWidth(curStr) / 2.0 + xStart;
      centerY = yStart - diameter / 2.0;
    }
    
    println("centerX = " + centerX + " centerY =  "+ centerY);
    //ellipse(centerX, centerY, diameter, diameter);
    //rect(centerX + offSet - diameter / 2.0, centerY + offSet - diameter / 2.0, diameter, diameter);
    float radius = diameter / 2.0;
    float minRGB = Math.min(redBackground, Math.min(greenBackground, blueBackground));
    float maxRGB = Math.max(redBackground, Math.max(greenBackground, blueBackground));
    float tmpFactR = (redBackground / 255 + (maxRGB + minRGB - redBackground) / 255) / 2;
    float tmpFactG = (greenBackground / 255 + (maxRGB + minRGB - greenBackground) / 255) / 2;
    float tmpFactB = (blueBackground / 255 + (maxRGB + minRGB - blueBackground) / 255) / 2;
    
    noStroke();
    //fill(maxRGB + minRGB - redBackground * tmpFactR, maxRGB + minRGB - greenBackground * tmpFactG, maxRGB + minRGB - blueBackground * tmpFactB);
    fill(titleBackColor);
    //fill(129, 177, 213);
    
    if(!curStr.equals(" "))
      drawShapeBasedOnRadius(numVertex, startDegree, diameter, centerX + offSetX, centerY + offSetY);
    stroke(10);
    fill(titleColor);
    //fill(61, 96, 167);
    text(curStr, xStart, yStart);
    xStart += diameter + interval;
  }
}


void drawShapeBasedOnRadius(int numVertex, float startDegree, float radius, float xStart, float yStart)
{
      PShape polygon = createShape();
      polygon.beginShape();
      float degree = startDegree;
      float degreeIncrement = 2 * PI / numVertex;
      
      for(int i = 0; i < numVertex; i++)
      {
        float randomSpike = 1;
        if(random(1) > 0.7)
          randomSpike = random(1, 1.5);
        float xPoint = (float)Math.cos(degree) * radius * randomSpike + xStart;
        float yPoint = (float)Math.sin(degree) * radius * randomSpike + yStart;
        polygon.vertex(xPoint, yPoint);
        degree += degreeIncrement;
      }
      polygon.endShape(CLOSE);
      shape(polygon); 
}
