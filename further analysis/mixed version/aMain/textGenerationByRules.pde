// used to record the boundary of Title and Author
ArrayList<ImageCoor> TextBoundaryCoordinates = new ArrayList<ImageCoor>();
String movieMoreInfo = "DIRECTED BY JOHN DOE\nCO-STRARRING DAVID DOE  JANE DOE\nA PRODUCTION OF MOVIE COMPANY";
String eventTimeLocationInfo = "Time: July 8th 2021 \nLocation: Event Hall";
String eventMoreInfo = "This event aims to promote unity and diversity within our community!";
String fontStr;
  
void initInputTexts()
{
  input = new String[3][3];
  if(TypeOfImage == ImageType.BOOKCOVER)
  {
     input[0][0] = "BOOK TITLE";
     input[0][1] = "Author's Name";
     input[0][2] = "Now is no time to think of what you do not have. Think of what you can do with that there is.";
  }
  if(TypeOfImage == ImageType.MOVIEPOSTER)
  {
     input[1][0] = "MOVIE TITLE";
     input[1][1] = movieMoreInfo;
  }
     
  if(TypeOfImage == ImageType.EVENTPOSTER)
  {
    input[2][0] = "EVENT NAME";
    input[2][1] = eventTimeLocationInfo;
    input[2][2] = eventMoreInfo;
  }
}

boolean vert = false;  // the text layout should not change for a pair of images

void drawHeadersByRules()
{
  fill(headerColor);
  
  if(random(1) > 0.5)
    fontStr = generateFont("serif");
  else
    fontStr = generateFont("sansserif");
    
  if(!randomFont)  
    textFont(createFont("Catamaran-Light.ttf", 1));
  System.out.println("fontStr = " + fontStr);
  
  // start from 2th row in the input file
  for(int i = 1; i < input[CurrentFileNumber].length; i++) //<>//
  {
    println("input array length = "+ input[CurrentFileNumber].length);
    
    if(input[CurrentFileNumber][i] == null || input[CurrentFileNumber][i].length() == 0)
      break;
    
    if(i == 1) //this row is a sub-title
    {
      if(TypeOfImage != ImageType.MOVIEPOSTER)
        textSize = gridY / SCALE; // size becomes 1/1.618 of previous items
      else
        textSize = gridY / (SCALE*1.5);
      textSize(textSize);  
      
      vert = random(1) > 0.5 && TypeOfImage != ImageType.MOVIEPOSTER;
      //vert = false; //Ian tmp
      
      if(TypeOfImage == ImageType.EVENTPOSTER)
        vert = false; // time and location should be horizontal
        
      if(vert)
      {
        vertHeaderByRules(input[CurrentFileNumber][i], false);  //Ian tmp
      }
      else
      {
        horizontalHeaderByRules(input[CurrentFileNumber][i], false);
      }
    }
    else // other rows are description paragrahs and just make sure no collision
    {
      textSize = gridY / (SCALE * 1.5);
      
      if(!randomFont)
        textFont(createFont("Catamaran-Medium.ttf", 1));
      
      textSize(textSize);

      //if(!useRandomBackground)
        vert = random(1) > 0.5;
      //vert = true;  //Ian tmp
      if(vert)
      {
        vertParagraghByRules(input[CurrentFileNumber][i]); //Ian tmp
      }
      else
      {
        horizontalParagraphByRules(input[CurrentFileNumber][i]); //Ian tmp
      }     
    } 
  }
}

float fontBig = 0;
boolean vertTitle = false;
void drawTitleByRules()
{
  fill(titleColor);
  textSize(gridY*1.5);
  String fontStr = "";
  
  if(isSerif == true && random(1) > 0.5)
    fontStr = generateFont("sansserif");
  else
    fontStr = generateFont("serif");
  System.out.println(fontStr);
  PFont fontOfStr;
  
  //if(!useRandomBackground)
  {
    fontBig = random(33, 48);
    vertTitle = random(1) > 0.5;// && TypeOfImage != ImageType.MOVIEPOSTER;;
  }
    //vert = true;  //Ian tmp
  if(vertTitle)
  {
    fontOfStr = createFont(fontStr, gridX);
    if(!randomFont)
      fontOfStr = createFont("Catamaran-Bold.ttf", gridX);
    textFont(fontOfStr);
    vertTitleByRules(fontOfStr);
  }
  else
  {
    fontOfStr = createFont(fontStr, gridY);
    if(!randomFont)
      fontOfStr = createFont("Catamaran-Bold.ttf", gridY);
    textFont(fontOfStr);
    horizontalTitleByRules(fontOfStr);
  }
}

float txtXHorizontalOrig = 0;
float txtYHorizontalOrig = 0;
// This is for horizontal
// not capitalized = is a paragraph
void setValidTextPostionLowerBoundByRules(boolean capitalized, float longestWordLength, float stringLength, boolean isTitle, boolean wraparound)
{
    println("\n Entering setValidTextPostionLowerBoundByRules(): longestWordLength =" + longestWordLength + " stringLength=" + stringLength + " textSize=" + textSize);
    float lengthToTest = 0;

    if (!capitalized)
        lengthToTest = longestWordLength * 8;
    else
        lengthToTest = stringLength;

    println("lengthToTest = " + lengthToTest);
    boolean occupied = false;

    //for golden triangle, paragrah cannot be put around pivatol points
    int t = 0; // number of try
    while (!occupied && t < 2000 && ((CurrentRule == Rules.GOLDENTRIANGLE && capitalized) || CurrentRule != Rules.GOLDENTRIANGLE))
    {
        t++;

        int i = (int)random(CurrentCoordinates.GetCoordinates().size());
        Coordinate coordinate = CurrentCoordinates.GetCoordinateByIndex(i);
        println("i= " + i);
        println("coordinate.x= " + coordinate.x + " coordinate.y = " + coordinate.y + " isOcucupiedByText = " + coordinate.isOccupiedByText);

        if (coordinate.GetIsOccupiedByText() == false && coordinate.GetIsOccupiedByImg() == false)
        {
            if (coordinate.x + lengthToTest/2 < (width -10) && coordinate.x - lengthToTest / 2 > 10 &&
                coordinate.y - textSize > 10 && coordinate.y + textSize < height -10)
            {
                txtY = (coordinate.y + textSize) < height - 10 ? coordinate.y : height - textSize - 10;
                // try to evenly spread the text around pivatol point
                txtX = (coordinate.x - lengthToTest / 2) > 10 ? (coordinate.x - lengthToTest / 2) : 10;

               if(isTitle || !horizontalNonTitleHasCollision(txtX, txtY, lengthToTest, capitalized, wraparound))
               {
                 println("horizontalNonTitleHasCollision find no collision");
                  coordinate.SetIsOccupiedByText(true);
                  occupied = true;
                  break;
               }
            }
        }
        else
            continue;
    }

    // try 2000 times
    // if using pivatoal points doesn't work, random generate some values
    for (int k = 0; k < 4000 && !occupied; k++)
    {
        txtX = random(10, width - 10);   // Y is fixed but still need an init value
        txtY = random(textSize + 10, height -10);

        if (isTitle)
        {
            if (txtX + lengthToTest < (width - 10))
                break;
        }
        else if (capitalized && !wraparound) // Author or director
        {
            if (TypeOfImage == ImageType.BOOKCOVER)
            {
                boolean isCollide = checkCollide(TextBoundaryCoordinates, txtX, txtY - textSize, txtX + lengthToTest, txtY) ||
                                    checkCollide(ImgBoundaryCoordinates, txtX, txtY - textSize, txtX + lengthToTest, txtY);
                if (txtX + lengthToTest < (width - 10) && !isCollide && txtY + textSize < (height -10))
                {
                    println("Author no collide! txtX =" + txtX + " txtY =" + txtY);
                    break;
                }
            }
            if (TypeOfImage == ImageType.MOVIEPOSTER)
            {
                boolean isCollide = checkCollide(TextBoundaryCoordinates, txtX, txtY - textSize, txtX + lengthToTest, txtY + 5 * textSize) ||
                                    checkCollide(ImgBoundaryCoordinates, txtX, txtY - textSize, txtX + lengthToTest, txtY + 5 * textSize);
                if (txtX + lengthToTest < (width - 10) && !isCollide && txtY + 5 * textSize < (height -10))
                {
                    println("Director printing no collide! txtX =" + txtX + " txtY =" + txtY);
                    break;
                }
            }
        }
        else if (wraparound)
        {
            println("\nEvent Time and Location check collide\n");
            boolean isCollide = checkCollide(TextBoundaryCoordinates, txtX, txtY - textSize, txtX + lengthToTest, txtY + 3 * textSize) ||
                                checkCollide(ImgBoundaryCoordinates, txtX, txtY - textSize, txtX + lengthToTest, txtY + 3 * textSize);
            if (!isCollide)
            {
                if (txtX + lengthToTest < (width - 10) && txtY + 3 * textSize < (height -10))
                {
                    println("Event Time and Location no collide! txtX =" + txtX + " txtY =" + txtY);
                    break;
                }
            }
        }
        else  // give less randomness if it's a paragraph
        {
            println("\nParagragh check collide\n");
            boolean isCollide = checkCollide(TextBoundaryCoordinates, txtX, txtY - textSize, txtX + lengthToTest, txtY + 4 * textSize) ||
                                checkCollide(ImgBoundaryCoordinates, txtX, txtY - textSize, txtX + lengthToTest, txtY + 4 * textSize);
            if (!isCollide)
            {
                if (txtX + lengthToTest < (width - 10) && txtY + 4 * textSize < height)
                {
                    println("Paragragh no collide! txtX =" + txtX + " txtY =" + txtY);
                    break;
                }
            }
        }

        //println("Before last try the lower bound: txtX= "+ txtX + " txtY = " + txtY);
        if (k == 3999)
        {
            println("LAST RESORT to get lower bound in setValidTextPostionLowerBoundByRules");
            txtX = 10;
            txtY = height - 5 * textSize;
        }
    }

    println("Set the lower bound: txtX= " + txtX + " txtY = " + txtY);
    txtXHorizontalOrig = txtX;
    txtYHorizontalOrig = txtY;
}

boolean vertNonTitleHasCollision(float x, float y, float lengthToTest, boolean capitalized, boolean wraparound)
{
  boolean result = false; //no collision
 // ellipse(x, y, 15, 15);
  //line(0, y, width, y);
  //line(x-textSize, 0, x, height);
  
  if(capitalized && !wraparound)
  {
    if (TypeOfImage == ImageType.BOOKCOVER)
    {
       result = checkCollide(TextBoundaryCoordinates, x - textSize, y, x, y + lengthToTest) ||
                checkCollide(ImgBoundaryCoordinates, x - textSize, y, x, y + lengthToTest);
    }
    if (TypeOfImage == ImageType.MOVIEPOSTER)
    {
       result = checkCollide(TextBoundaryCoordinates, x - 4 * textSize, y, x, y + +lengthToTest) ||
                checkCollide(ImgBoundaryCoordinates, x - 4 * textSize, y, x + lengthToTest, y + lengthToTest);
    }
  }
  else if(wraparound)
  {
    result = checkCollide(TextBoundaryCoordinates, x - 3 * textSize, y, x , y +  lengthToTest) ||
             checkCollide(ImgBoundaryCoordinates, x - 3 * textSize, y, x , y +  lengthToTest);    
  }
  else
  {
    result = checkCollide(TextBoundaryCoordinates, x - 4 * textSize, y, x, y + lengthToTest) ||
                          checkCollide(ImgBoundaryCoordinates, x - 4 * textSize, y, x, y + lengthToTest);
  }
  return result;
}

boolean horizontalNonTitleHasCollision(float x, float y, float lengthToTest, boolean capitalized, boolean wraparound)
{
 // ellipse(x, y, 15, 15);


  boolean result = false; //no collision
  if(capitalized && !wraparound)
  {
    if (TypeOfImage == ImageType.BOOKCOVER)
    {
       result = checkCollide(TextBoundaryCoordinates, x, y - textSize, x + lengthToTest, y) ||
                checkCollide(ImgBoundaryCoordinates, x, y - textSize, x + lengthToTest, y);
    }
    if (TypeOfImage == ImageType.MOVIEPOSTER)
    {
       result = checkCollide(TextBoundaryCoordinates, x, y - textSize, x + lengthToTest, y + 5 * textSize) ||
                checkCollide(ImgBoundaryCoordinates, x, y - textSize, x + lengthToTest, y + 5 * textSize);
    }
  }
  else if(wraparound)
  {
    result = checkCollide(TextBoundaryCoordinates, x, y - textSize, x + lengthToTest, y + 3 * textSize) ||
             checkCollide(ImgBoundaryCoordinates, x, y - textSize, x + lengthToTest, y + 3 * textSize);     
  }
  else
  {
    result = checkCollide(TextBoundaryCoordinates, x, y - textSize, x + lengthToTest, y + 4 * textSize) ||
             checkCollide(ImgBoundaryCoordinates, x, y - textSize, x + lengthToTest, y + 4 * textSize);
  }
  return result;
}

float txtXVerticalOrig = 0; // record the 1st image of the pair's data
float txtYVerticalOrig = 0;
//Wraparoundis for Event poster's Time and location
void setValidTextPostionVerticalOriginByRules(boolean capitalized, float longestWordLength, float stringLength, boolean isTitle, boolean wraparound)
{
    println("\n Entering setValidTextPostionVerticalOriginByRules: longestWordLength =" + longestWordLength + " stringLength=" + stringLength + " textSize=" + textSize);
    float lengthToTest = 0;
    if (!capitalized)
        lengthToTest = longestWordLength * 8;
    else
        lengthToTest = stringLength;

    println("lengthToTest = " + lengthToTest);
    boolean occupied = false;
    int t = 0;
    //for golden triangle, paragrah cannot be put around pivatol points
    while (!occupied && t < 2000 && ((CurrentRule == Rules.GOLDENTRIANGLE && capitalized) || CurrentRule != Rules.GOLDENTRIANGLE))
    {
        t++;
        int i = (int)random(CurrentCoordinates.GetCoordinates().size());
        println("i = " + i + " size = " + CurrentCoordinates.GetCoordinates().size());
        Coordinate coordinate = CurrentCoordinates.GetCoordinateByIndex(i);

        if (coordinate.GetIsOccupiedByText() == false && coordinate.GetIsOccupiedByImg() == false)
        {
            if (coordinate.y + lengthToTest / 2 < (height - 10) && coordinate.y - lengthToTest / 2 > 10 &&
                coordinate.x - textSize > 10 && coordinate.x + textSize < width - 10 )
            {
                txtX = (coordinate.x + textSize) < width - 10 ? coordinate.x : width - textSize - 10;
                // try to evenly spread the text around pivatol point
                txtY = (coordinate.y - lengthToTest / 2) > 10 ? (coordinate.y - lengthToTest / 2) : 10;

                if(isTitle || !vertNonTitleHasCollision(txtX, txtY, lengthToTest, capitalized, wraparound))
                {
                  coordinate.SetIsOccupiedByText(true);
                  occupied = true;
                  break;
                }
            }
        }
        else
            continue;
    }

    // try 4000 times
    // if using pivatoal points doesn't work, random generate some values
    for (int k = 0; k < 4000 && !occupied; k++)
    {
        txtY = random(10, height - 10);   // Y is fixed but still need an init value
        txtX = random(textSize + 10, width - 10);

        if (isTitle && TypeOfImage == ImageType.BOOKCOVER)
        {
            if (txtY + lengthToTest < (height - 10) && txtX + textSize < (width - 10))
                break;
        }
        else if (capitalized && !wraparound) // Author or director
        {
            if (TypeOfImage == ImageType.BOOKCOVER)
            {
                boolean isCollide = checkCollide(TextBoundaryCoordinates, txtX - textSize, txtY, txtX, txtY + lengthToTest) ||
                                    checkCollide(ImgBoundaryCoordinates, txtX - textSize, txtY, txtX, txtY + lengthToTest);
                if (txtY + lengthToTest < height - 10 && !isCollide && txtX + textSize < width - 10)
                {
                    println("Author no collide! txtX =" + txtX + " txtY =" + txtY + " upperBoundX=" + upperBoundX + " upperBoundY=" + upperBoundY);
                    break;
                }
            }
            if (TypeOfImage == ImageType.MOVIEPOSTER)
            {
                boolean isCollide = checkCollide(TextBoundaryCoordinates, txtX - 4 * textSize, txtY, txtX, txtY + +lengthToTest) ||
                                    checkCollide(ImgBoundaryCoordinates, txtX - 4 * textSize, txtY, txtX + lengthToTest, txtY + lengthToTest);
                if (txtY + lengthToTest < height - 10 && !isCollide && txtX + textSize < width - 10)
                {
                    upperBoundX = txtX + lengthToTest;
                    upperBoundY = txtY + textSize;
                    println("Director printing no collide! txtX =" + txtX + " txtY =" + txtY + " upperBoundX=" + upperBoundX + " upperBoundY=" + upperBoundY);
                    break;
                }
            }
        }
        else if(wraparound)
        {
            boolean isCollide = checkCollide(TextBoundaryCoordinates, txtX - 3 * textSize, txtY, txtX , txtY +  lengthToTest) ||
                                checkCollide(ImgBoundaryCoordinates, txtX - 3 * textSize, txtY, txtX , txtY +  lengthToTest);  
            if (!isCollide)
            {
                if (txtY + lengthToTest < (height - 10) && txtX + 3 * textSize < width)
                {
                    //println("Event Time and Location no collide! txtX =" + txtX + " txtY =" + txtY);
                    break;
                }
            }
        }
        else  // give less randomness if it's a paragraph
        {
            boolean isCollide = checkCollide(TextBoundaryCoordinates, txtX - 4 * textSize, txtY, txtX, txtY + lengthToTest) ||
                                checkCollide(ImgBoundaryCoordinates, txtX - 4 * textSize, txtY, txtX, txtY + lengthToTest);
            if (!isCollide)
            {
                if (txtY + lengthToTest < height - 10 && txtX - 4 * textSize > 0)
                {
                    upperBoundX = txtX;
                    upperBoundY = txtY + lengthToTest;
                    //txtX = txtX - 4*textSize;
                    println("Paragragn no collide! txtX =" + txtX + " txtY =" + txtY + " upperBoundX=" + upperBoundX + " upperBoundY=" + upperBoundY);
                    break;
                }
            }
        }

        if (k == 3999)
        {
            println("LAST RESORT to get lower bound in setValidTextPostionVerticalOriginByRules");
            txtY = 10;
            txtX = width - 5 * textSize;
        }
    }

    println("Set the vertical lower bound: txtX= " + txtX + " txtY = " + txtY);
    txtXVerticalOrig = txtX;
    txtYVerticalOrig = txtY;
}
 //<>// //<>//
//Used by Title and Author, TimeLocation (wrappedAround)
void vertHeaderByRules(String s, boolean isTitle)
{
  textSize(textSize);
  boolean wraparound = false;
  if(s.contains("\n") == true && (TypeOfImage == ImageType.EVENTPOSTER))
  {
    wraparound = true;
  }  
  
  System.out.println("\nEntering vertHeader, s = " + s + "; textSize = " +textSize);
  println("width = "+width); println("height = "+height);
  String[] words = s.split("\\s+"); //<>//
  
  //if(!useRandomBackground)
    setValidTextPostionVerticalOriginByRules(true, getLongestWordLength(words), textWidth(s), isTitle, wraparound);
  //else
  //{
   // txtX = txtXVerticalOrig; // get the previous iamge's data
   // txtY = txtYVerticalOrig;
 // }
  
  //println("textSize = " + textSize);
  println("Before pushMatrix txtX = "  + txtX + ", txtY = " + txtY); //<>//
  if(isTitle && txtX < 190) // for vertical title, make sure the txtX > 190
    txtX = 190;
    
  pushMatrix();
  translate(txtX, txtY);
  rotate(PI/2);
  //println("after pushMatrix txtX = "  + txtX + ", txtY = " + txtY);
  
  noStroke(); //Ian tmp
  line(-txtY, 0, height-txtY, 0);
  textAlign(BOTTOM);
    
  if(isTitle)
  {
    stroke(titleColor);  //Ian tmp
    println("I am printing title: txtX = " +txtX+" txtY = " +txtY +" textWidth(s)=" +textWidth(s)+" textSize =" + textSize);

    println("Printing title s = "+s);
    text(s, 0, 0);
   // text(s.toUpperCase(), 0, 0, textWidth(s), textSize);
   //if(!useRandomBackground)
   {
      ImageCoor titleCoor = new ImageCoor(txtX, txtY, txtX + textSize,  txtY + textWidth(s));
      TextBoundaryCoordinates.add(titleCoor);
   }
  }
  else if(wraparound) // event's time and location
  {
    println("I am printing Time and Location: txtX = " +txtX+" txtY = " +txtY +" textWidth(s)=" +textWidth(s)+" textSize =" +textSize);
    stroke(headerColor);
    text(s, 0, 0);
   // if(!useRandomBackground)
    {
      ImageCoor authorCoor = new ImageCoor(txtX- 7.0*textSize, txtY, txtX, txtY + textWidth(s));
      TextBoundaryCoordinates.add(authorCoor);
    }
  }
  else //Author
  {
    if(TypeOfImage == ImageType.BOOKCOVER)
    {
      println("I am printing author: txtX = " +txtX+" txtY = " +txtY +" textWidth(s)=" +textWidth(s)+" textSize =" +textSize); //<>//
      stroke(headerColor);
      text(s, 0, 0);
     // if(!useRandomBackground)
      {
        ImageCoor authorCoor = new ImageCoor(txtX, txtY, txtX+textSize, txtY + textWidth(s));
        TextBoundaryCoordinates.add(authorCoor);
      }
    }
    if(TypeOfImage == ImageType.MOVIEPOSTER )
    {
      println("I am printing director: txtX = " +txtX+" txtY = " +txtY +" textWidth(s)=" +textWidth(s)+" textSize =" +textSize);
      stroke(headerColor);
      text(s, 0, 0);
     // if(!useRandomBackground)
      {
        ImageCoor directorCoor = new ImageCoor(txtX- 4*textSize, txtY, txtX, txtY + textWidth(s));
        TextBoundaryCoordinates.add(directorCoor);
      }
    }
  }

  popMatrix();
    //println("After popMatrix txtX = "  + txtX + ", txtY = " + txtY);
    
  println("textWidth = "+textWidth(s));
  for(int i = 0; i < TextBoundaryCoordinates.size(); i++)
  {
    ImageCoor co = TextBoundaryCoordinates.get(i);
    println("co.x1 = "  + co.x1 + " co.x2 = " + co.x2);
    println("co.y1 = "  + co.y1+ " co.y2 = " + co.y2);
    //ellipse(co.x1, co.y1, 5, 5);
    //ellipse(co.x2, co.y2, 5, 5);
  }
  
      //Ian tmp line
      
  /*    if(isTitle)
      {
    stroke(0);
    line(txtX, 0, txtX, height);
    line(0, txtY, width, txtY);
      }*/
}

void vertParagraghByRules(String s)
{
  System.out.println("\nEntering vertParagraghByRules, s = " + s); //<>//
  println("width = "+width); println("height = "+height);

  String[] words = s.split("\\s+");

 // if(!useRandomBackground)
    setValidTextPostionVerticalOriginByRules(false, getLongestWordLength(words), textWidth(s), false, false);
 // else
 // {
 //   txtX = txtXVerticalOrig; // get the previous iamge's data
 //   txtY = txtYVerticalOrig;
 // }
  
  println("Before pushMatrix txtX = "  + txtX + ", txtY = " + txtY);
  pushMatrix();
  translate(txtX, txtY);
  rotate(PI/2);
  
  noStroke(); //Ian tmp
  line(-txtY, 0, height-txtY, 0);
  textAlign(BOTTOM);
  
  println("I am printing paragragh: txtX = " +txtX+" txtY = " +txtY +" upperBoundX=" +upperBoundX+" 4*textSize =" + 4*textSize);
  if(TypeOfImage == ImageType.BOOKCOVER)
    text(s, 0, 0, 8*getLongestWordLength(words), 6*textSize);
  else
    text(s, 0, 0, 4*getLongestWordLength(words), 6*textSize);

  popMatrix();
  
  xMax = txtX;
  yMin = txtY; //<>//
  xMin = max(0, txtX - 4*textSize); 
  if(TypeOfImage == ImageType.BOOKCOVER)
    yMax = txtY + 8*getLongestWordLength(words); 
  else
    yMax = txtY + 4*getLongestWordLength(words); 

  println("textWidth "+textWidth(s));
  println("xMin = "  + xMin + " xMax = " + xMax);
  println("yMin = "  + yMin + " yMax = " + yMax);
  fill(255);
  //ellipse(xMin, yMin, 15, 15);
  //ellipse(xMax, yMax, 15, 15);  
}

//Used by Title and Author
void horizontalHeaderByRules(String s, boolean isTitle)
{
  System.out.println("\n==>Entering horizontalHeaderByRules, s = " + s); //<>//
  textSize(textSize);
  float strLen = 0;
  boolean wraparound = false;
  if(s.contains("\n") == true && (TypeOfImage == ImageType.EVENTPOSTER))
  {
    strLen = textWidth(s);
    wraparound = true;
  }
  else
    strLen = textWidth(s);
  println("width = "+width); println("height = "+height);

  String[] words = s.split("\\s+");

  //if(!useRandomBackground)
    setValidTextPostionLowerBoundByRules(true, getLongestWordLength(words), strLen, isTitle, wraparound);
  //else
 // {
  //  txtX = txtXHorizontalOrig;
  //  txtY = txtYHorizontalOrig;
  //}

  noStroke();  // Ian tmp
  //stroke(titleColor);
  line(0, txtY, width, txtY);
  textAlign(BOTTOM);
  //if(height-txtY < 160) // for horizontal title, make sure the txtY > 160
   // txtY = height - 160;
    
  if(isTitle)  //for big title
  {
    stroke(titleColor);
    println("I am printing title: txtX = " +txtX+" txtY = " +txtY +" textWidth(s)=" +textWidth(s)+" textSize =" +textSize);

    println("Printing horizontal title s = "+s); //<>//
    text(s, txtX, txtY);
   // text(s.toUpperCase(), 0, 0, textWidth(s), textSize);
   //if(!useRandomBackground)   // the random background resulted output is re-use all layout and coor of algorithmic output
   {
      ImageCoor titleCoor = new ImageCoor(txtX, txtY - textSize, txtX + textWidth(s),  txtY);
      TextBoundaryCoordinates.add(titleCoor);
   }
  }
  else if(wraparound)
  {
    println("I am printing Event time and location: txtX = " +txtX+" txtY = " +txtY +" textWidth(s)=" +textWidth(s)+" textSize =" +textSize + "strlen =" +strLen);
    stroke(headerColor);
    text(s, txtX, txtY);
    //if(!useRandomBackground)
    {
      ImageCoor authorCoor = new ImageCoor(txtX, txtY- textSize, txtX + strLen, txtY+ 2*textSize); //<>//
      TextBoundaryCoordinates.add(authorCoor);
    }
  }
  else // Author
  {
    if(TypeOfImage == ImageType.BOOKCOVER)
    {
      println("I am printing author: txtX = " +txtX+" txtY = " +txtY +" textWidth(s)=" +textWidth(s)+" textSize =" +textSize);
      stroke(headerColor);
      text(s, txtX, txtY);
      println("not wrap around");
      //if(!useRandomBackground)
      {
        ImageCoor authorCoor = new ImageCoor(txtX, txtY - textSize, txtX + textWidth(s), txtY);
        TextBoundaryCoordinates.add(authorCoor);
      }
    }
    if(TypeOfImage == ImageType.MOVIEPOSTER)
    {
      println("I am printing director: txtX = " +txtX+" txtY = " +txtY +" textWidth(s)=" +textWidth(s)+" textSize =" +textSize);
      stroke(headerColor);
      text(s, txtX, txtY);
      //if(!useRandomBackground)
      {
        ImageCoor authorCoor = new ImageCoor(txtX, txtY-textSize, txtX + textWidth(s), txtY + 5*textSize);
        TextBoundaryCoordinates.add(authorCoor);
      }
    }
  }

  println("textWidth = "+textWidth(s));
  for(int i = 0; i < TextBoundaryCoordinates.size(); i++)
  {
    ImageCoor co = TextBoundaryCoordinates.get(i);
    println("xMin = "  + co.x1 + " xMax = " + co.x2);
    println("yMin = "  + co.y1+ " yMax = " + co.y2);
    //ellipse(co.x1, co.y1, 5, 5);
    //ellipse(co.x2, co.y2, 5, 5);
  }
}

void horizontalParagraphByRules(String s)
{
  System.out.println("\n==>Entering horizontalParagraphByRules, s = " + s); //<>//
  println("width = "+width); println("height = "+height);

  String[] words = s.split("\\s+");

  //if(!useRandomBackground)
    setValidTextPostionLowerBoundByRules(false, getLongestWordLength(words), textWidth(s), false, false);
 // else
 // {
 //   txtX = txtXHorizontalOrig;
 //   txtY = txtYHorizontalOrig;
 // }
  //setValidTextPostionUpperBoundByRules();

  noStroke();  // Ian tmp
  line(0, txtY, width, txtY);
  textAlign(BOTTOM);

  println("I am printing paragragh: txtX = " +txtX+" txtY = " +txtY +" upperBoundX=" +upperBoundX+" 3*textSize =" + 3*textSize);
  stroke(headerColor);
  xMin = txtX;
  yMin = txtY;
  if(TypeOfImage == ImageType.BOOKCOVER)
  {
    text(s, txtX, txtY, 8*getLongestWordLength(words), 6*textSize);

    xMax = txtX + 8*getLongestWordLength(words);
    yMax = txtY + 4*textSize;
  }
  else
  {
    text(s, txtX, txtY, 4*getLongestWordLength(words), 5*textSize);

    xMax = txtX + 4*getLongestWordLength(words);
    yMax = txtY + 5*textSize;
  }

  println("textWidth = "+textWidth(s));
  println("xMin = "  + xMin + " xMax = " + xMax);
  println("yMin = "  + yMin + " yMax = " + yMax);
  //ellipse(xMin, yMin, 5, 5);
  //ellipse(xMax, yMax, 5, 5);
}

void vertTitleByRules(PFont fontOfStr)
{
  System.out.println("\n==>Entering vertTitleByRules ");
  println("width = "+width); println("height = "+height); //<>//

  if(TypeOfImage == ImageType.BOOKCOVER)
    textSize = gridY*1.2;
  else
    textSize = gridY*1.5;
  vertHeaderByRules(input[CurrentFileNumber][0], true);
}


void horizontalTitleByRules(PFont fontOfStr)
{
  println("\n==> Entering horizontalTitleByRules()");
  if(TypeOfImage == ImageType.BOOKCOVER)
    textSize = gridY*1.2;
  else
    textSize = gridY*1.5 ;
  horizontalHeaderByRules(input[CurrentFileNumber][0], true);
}
