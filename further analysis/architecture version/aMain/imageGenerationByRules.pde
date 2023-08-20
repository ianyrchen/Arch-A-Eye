static int NumOfImagesGenerated = 0;
GridCoordinates CurrentCoordinates;
Rules CurrentRule;
int TOTALIMAGES = 21;  // is the # of actual images + 1
int BOOKCOVERIMAGES = 9;
int MOVIEIMAGES = 14;
int EVENTIMAGES = 21;
int CHOSENIMAGES = 3; // choose at most 3 images from 9 images for now
float imageSize = 0;
ArrayList<ImageCoor> ImgBoundaryCoordinates = new ArrayList<ImageCoor>();
ArrayList<Integer> ImgNumbers = new ArrayList<Integer>();
PImage[] imgs;
float [] xValue; 
float [] yValue; 
      
void getImageNumbers()
{
  ImgNumbers = new ArrayList<Integer>(); 
  // different type get differnt images- limit to 3 images 
  int numOfImgs = min((int)random(1,4), CHOSENIMAGES);

  int num = 0;
  for(int i = 0; i < numOfImgs; i++)
  {
    if(TypeOfImage == ImageType.BOOKCOVER) 
    {
      num = (int)random(0,BOOKCOVERIMAGES);
    }
    else if(TypeOfImage == ImageType.MOVIEPOSTER) 
    {
      num = (int)random(BOOKCOVERIMAGES+1,MOVIEIMAGES);
    }
    else if(TypeOfImage == ImageType.EVENTPOSTER) 
    {
      num = (int)random(MOVIEIMAGES+1,EVENTIMAGES);
    }
    
    while (ImgNumbers.contains(num))
    {
      if(TypeOfImage == ImageType.BOOKCOVER) 
      {
        num = (int)random(0,BOOKCOVERIMAGES);
      }
      else if(TypeOfImage == ImageType.MOVIEPOSTER) 
      {
        num = (int)random(BOOKCOVERIMAGES+1,MOVIEIMAGES);
      }
      else if(TypeOfImage == ImageType.EVENTPOSTER) 
      {
        num = (int)random(MOVIEIMAGES+1,EVENTIMAGES);
      }
    }
    ImgNumbers.add(num);
  }
}

void loadImgOntoPivotalPoint(Coordinate coordinate, int k)
{
  coordinate.SetIsOccupiedByImg(true);      
        
  boolean withinBound = false;
  while(!withinBound)
  {
    if((coordinate.x - imageSize/2) > 0 && (coordinate.y-imageSize/2)> 0 && (coordinate.x+imageSize/2)<width && (coordinate.y+imageSize/2) <height)
    {
      withinBound = true;
    }
    else
    {
      imageSize -= 10;
      imgs[k].resize((int)imageSize, 0);
    }
  }
        
  xValue[k] = coordinate.x;
  yValue[k] = coordinate.y;
        
  ImageCoor imgCoor = new ImageCoor(coordinate.x - imageSize/2, coordinate.y-imageSize/2, coordinate.x+imageSize/2, coordinate.y+imageSize/2);
  //stroke(255);
  //line(0,coordinate.y-imageSize/2, width, coordinate.y-imageSize/2);
  //line(coordinate.x-imageSize/2,0, coordinate.x-imageSize/2, height);
  //line(coordinate.x+imageSize/2,0, coordinate.x+imageSize/2, height);
  //line(0,coordinate.y+imageSize/2, width, coordinate.y+imageSize/2);
  ImgBoundaryCoordinates.add(imgCoor);
  //ellipse(coordinate.x-imageSize/2, coordinate.y-imageSize/2, 5,5);
  //ellipse(coordinate.x+imageSize/2, coordinate.y+imageSize/2, 5,5);
}

void generateImageByRules()
{ //<>//
  int currentBGIngNum = 0;
  println("==> Entering generateImageByRules");
  
  if(currentBGIngNum == 0)
  {
    float r = random(1);
    CurrentRule = Rules.RULEOFTHIRDS;
    if(r >= 2.0/3.0)
      CurrentRule = Rules.RULEOFTHIRDS;
    if(r <= 1.0/3.0)
      CurrentRule = Rules.GOLDENMEAN;
    if(r > 1.0/3.0 && r < 2.0/3.0)
      CurrentRule = Rules.GOLDENTRIANGLE;
  }
  //CurrentRule = Rules.GOLDENTRIANGLE; // Ian tmp
  //CurrentRule = Rules.RULEOFTHIRDS;
  CurrentCoordinates = generatePivotalPointsByRules(CurrentRule);
  
  // loop through the pivotal  points

//Ian tmp
  //int i = (int)random(0, CurrentCoordinates.GetCoordinates().size());
  for(int i = 0; i < CurrentCoordinates.GetCoordinates().size(); i++)
  { //<>//
    for(currentBGIngNum = 0; currentBGIngNum < 8; currentBGIngNum++)
    {
      println("currentBGIngNum = "+currentBGIngNum);
                
      PImage bgImage = loadImage("Background Images/" + currentBGIngNum+".jpg");
      bgImage.resize(width, height);
      background(bgImage); //<>//
      
      if(currentBGIngNum == 0)
      {
        resetCoordinatesOccupancy();  
        getImageNumbers(); //randomly decide # of images to load and the images' sequence#
    
        Coordinate coordinate = CurrentCoordinates.GetCoordinateByIndex(i);
        float x = coordinate.x;
        float y = coordinate.y;
        
        imgs = new PImage[ImgNumbers.size()];
        xValue = new float[ImgNumbers.size()]; 
        yValue = new float[ImgNumbers.size()]; 
        
        //Ian tmp
        //int k=0;
        for(int k = 0; k < ImgNumbers.size(); k++)
        {
          imgs[k] = loadImage(ImgNumbers.get(k)+".png"); 

          imageSize = random(width/2, width+1);
          println("imageSize = "+imageSize);
          imgs[k].resize((int)imageSize, 0);

          if(k==0)     // first image will occupy a pivotal point
          {
            loadImgOntoPivotalPoint(coordinate, k);
          }
          else   // get next unoccupied pivotal point and use it
          {
            coordinate = CurrentCoordinates.GetFirstUnoccupiedCoordinate();
            if(coordinate != null)  // find an unoccupied pivotal point
            {
              loadImgOntoPivotalPoint(coordinate, k);
            }
            else // display along the lines
            {
              boolean isCollide = true;
              while(isCollide && imageSize > 150)
              {
                imageSize -= 5;
                if(CurrentRule == Rules.GOLDENTRIANGLE)
                {
                  int ln = (int) random(0, 2);
                  Line l = LinesForGoldenTriangle.get(ln);
                  xValue[k] = random(width/5, width/2);
                  yValue[k] = l.getYValueByX(xValue[k]);
                }
                else  // the other 2 rules
                {
                  float xy = random(0, 1);

                  if(xy >=0.5) // y value is not changed: horizontal line
                  {
                    xValue[k] = random(width/5, width/2);
                    yValue[k] = y;
                  }
                  else  // x value is not changed: vertical line
                  {
                    xValue[k] = x;
                    yValue[k] = random(height/6, height/3);
                  }
                }
          
                boolean withinBound = false;
                while(!withinBound && imageSize > 150)
                {
                  if((xValue[k]+imageSize/2)<width && (yValue[k] + imageSize/2) <height && (xValue[k]-imageSize/2) > 0 && (yValue[k]-imageSize/2) -imageSize/2 > 0)
                    withinBound = true;
                  else
                  {
                    imageSize -= 5;
                  }
                }
                isCollide = false;
                // Image collide is ok
                //checkCollide(ImgBoundaryCoordinates, xValue[k]-imageSize/2, yValue[k]-imageSize/2, xValue[k]+imageSize/2, yValue[k] + imageSize/2);
                println("imageSize = "+imageSize + " isCollide =" +isCollide);
              }
    
              imgs[k].resize((int)imageSize, 0);
              ImageCoor imgCoor = new ImageCoor(xValue[k]-imageSize/2, yValue[k]-imageSize/2, xValue[k]+imageSize/2, yValue[k] + imageSize/2);
              ImgBoundaryCoordinates.add(imgCoor);
            }  // else display along the line
          } //<>//
        }// for loop to load images
      } // if currentBGIngNum = 0
    
      outputResultImage(currentBGIngNum);
    } // loop through all background images
    
    // Processing Random Background and Algorithmic Background  - WRONG
    outputResulImagetWithoutBGImage();
  } 
}

void outputResulImagetWithoutBGImage()
{
    useRandomBackground = false;
    outputResultImage(8);  // Algorithmic Background
    useRandomBackground = true;
    outputResultImage(8);  // Random background
    useRandomBackground = false;
}

void outputResultImage(int currentBGIngNum)
{
   setupColors(currentBGIngNum);
   drawGridByRule(CurrentRule, currentBGIngNum);
   
   imageMode(CENTER);
   for(int l = 0; l < ImgNumbers.size(); l++)
   {
     image(imgs[l], xValue[l], yValue[l]);
   }
  
   drawTextByRules();

   // save the generated images into a diretory
   save(".\\data\\GeneratedRawImages\\generatedRaw" + NumOfImagesGenerated +".png");
   NumOfImagesGenerated++; 
}

void resetCoordinatesOccupancy()
{
  TextBoundaryCoordinates = new ArrayList<ImageCoor>(); //reset this array as well
  ImgBoundaryCoordinates = new ArrayList<ImageCoor>(); //reset this array as well
  ImgNumbers.clear();
  
  for(int i = 0; i < CurrentCoordinates.GetCoordinates().size(); i++)
  {
    //reset coordinate's occupancy
    CurrentCoordinates.GetCoordinateByIndex(i).SetIsOccupiedByText(false);
    CurrentCoordinates.GetCoordinateByIndex(i).SetIsOccupiedByImg(false);
  }
}
