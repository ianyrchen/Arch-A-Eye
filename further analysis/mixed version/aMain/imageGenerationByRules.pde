static int NumOfImagesGenerated = 0;
GridCoordinates CurrentCoordinates;
Rules CurrentRule;
int TOTALIMAGES = 21;  // is the # of actual images + 1
int BOOKCOVERIMAGES = 7;
int MOVIEIMAGES = 14;
int EVENTIMAGES = 21;
int CHOSENIMAGES = 3; // choose at most 3 images from 7 images for now
float imageSize = 0;
ArrayList<ImageCoor> ImgBoundaryCoordinates = new ArrayList<ImageCoor>();
ArrayList<Integer> ImgNumbers = new ArrayList<Integer>();
PImage[] imgs;
float [] xValue; 
float [] yValue; 
      
void getImageNumbers()
{
  ImgNumbers = new ArrayList<Integer>(); 
  // different type get differnt images
  int numOfImgs = min((int)random(1,8), CHOSENIMAGES);

  int num = 0;
  for(int i = 0; i < numOfImgs; i++)
  {
    if(TypeOfImage == ImageType.BOOKCOVER) 
    {
      num = (int)random(1,BOOKCOVERIMAGES+1);
    }
    else if(TypeOfImage == ImageType.MOVIEPOSTER) 
    {
      num = (int)random(BOOKCOVERIMAGES+1,MOVIEIMAGES+1);
    }
    else if(TypeOfImage == ImageType.EVENTPOSTER) 
    {
      num = (int)random(MOVIEIMAGES+1,EVENTIMAGES+1);
    }
    
    while (ImgNumbers.contains(num))
    {
      if(TypeOfImage == ImageType.BOOKCOVER) 
      {
        num = (int)random(1,BOOKCOVERIMAGES+1);
      }
      else if(TypeOfImage == ImageType.MOVIEPOSTER) 
      {
        num = (int)random(BOOKCOVERIMAGES+1,MOVIEIMAGES+1);
      }
      else if(TypeOfImage == ImageType.EVENTPOSTER) 
      {
        num = (int)random(MOVIEIMAGES+1,EVENTIMAGES+1);
      }
    }
    ImgNumbers.add(num);
  }
}

void generateImageByRules()
{ //<>//
  println("==> Entering generateImageByRules");
  
  if(!useRandomBackground)
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
    if(!useRandomBackground)
    {
      resetCoordinatesOccupancy();  //Ian correct?
      getImageNumbers(); //randomly decide # of images to load and the images' sequence#
    
      Coordinate coordinate = CurrentCoordinates.GetCoordinateByIndex(i);
    
      imgs = new PImage[ImgNumbers.size()];
      xValue = new float[ImgNumbers.size()]; 
      yValue = new float[ImgNumbers.size()]; 
        
      //Ian tmp
      //int k=0;
      for(int k = 0; k < ImgNumbers.size(); k++)
      //for(int k = 0; k < min(2,ImgNumbers.size()) ; k++)
      {
        imgs[k] = loadImage(ImgNumbers.get(k)+".png"); 

        imageSize = random(width/3, width);
        println("imageSize = "+imageSize);
        imgs[k].resize((int)imageSize, 0);

        if(k==0)     // first image will occupy a pivotal point
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
        else  // display along the lines
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
                yValue[k] = coordinate.y;
              }
              else  // x value is not changed: vertical line
              {
                xValue[k] = coordinate.x;
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
          ImgBoundaryCoordinates.add(imgCoor); //<>//
        }
      }

    }
    
    setupColors();
    drawGridByRule(CurrentRule);
   
    imageMode(CENTER);
    for(int l = 0; l < ImgNumbers.size(); l++)
    //for(int k = 0; k < min(2,ImgNumbers.size()); k++)
    {
      image(imgs[l], xValue[l], yValue[l]);
    }
  
    
    //Ian tmp test code
    colorMode(HSB);
    color testColor = color(dominantImgHue, dominantImgSaturation, dominantImgBrightness);
    //fill(testColor);
    //ellipse(width/2, height/2, 100, 100);
  
    drawTextByRules();


/*IAN TRY HERE to dynamically access the full sketch
    PImage imageToProcess = createImage(width, height, RGB);
    imageToProcess.set(0, 0, get());
    imageToProcess.resize(width, 0);
    imageToProcess.save(".\\data\\GeneratedRawImages\\generatedRaw" + NumOfImagesGenerated +".png");
*/
    
    if(!useRandomBackground)
      i--; // want to generate a pair of same image
    useRandomBackground = !useRandomBackground; // flip to generate a pair of images: one with random color, the other with algorithmic color
    // save the generated images into a diretory
    save(".\\data\\GeneratedRawImages\\generatedRaw" + NumOfImagesGenerated +".png");
    NumOfImagesGenerated++; 
  }
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
