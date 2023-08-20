// Store rectangular image's coordinates
class ImageCoor 
{
  float x1, y1, x2, y2;
  public ImageCoor(float x1, float y1, float x2, float y2) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
  }
}


void drawImages() 
{
  noStroke();

  drawRandomRectangles(); // draw random-sized ractangles 

  //fragmentImages(2);
  fragmentFloodFill();
}


void floodPic(int[][] matrixPic, int curX, int curY, float xInterval, float yInterval, float minX, float minY, float maxX, float maxY, PImage img, int counter) 
{
  if (curX >= matrixPic[0].length || curX < 0) 
  {
    return;
  }
  
  if (curY >= matrixPic.length || curY < 0) 
  {
    return;
  }
  
  if (matrixPic[curY][curX] == 1) 
  {
    return;
  }
  
  if (counter <= 0)
  {
    return;
  }
  
  ArrayList<Integer> a1 = new ArrayList<Integer>(Arrays.asList(0, 1, 2, 3));
  Collections.shuffle(a1);
  matrixPic[curY][curX] = 1;
  PImage img3 = createImage((int)xInterval, (int)yInterval, RGB);
  
  for (int ii = (int)xInterval * curX; ii < (int)xInterval * (curX + 1); ii++) 
  {
    for (int j = (int)yInterval * curY; j < (int)yInterval * (curY + 1); j++) 
    {
      img3.pixels[(j - (int)(yInterval * curY))*img3.width+(ii - (int)(xInterval * curX))] = img.pixels[j*img.width+ii];
    }
  }
  
  image(img3, minX + xInterval * curX, minY + yInterval * curY, xInterval, yInterval);
  
  for (int i = 0; i < 4; i++) 
  {
    int tmpRand = a1.get(i);
    counter--;
    if (counter <= 0) 
    {
      return;
    }
    
    if (tmpRand == 0) 
    {
      floodPic(matrixPic, curX, curY + 1, xInterval, yInterval, minX, minY, maxX, maxY, img, counter);
    } 
    else if (tmpRand == 1) 
    {
      floodPic(matrixPic, curX, curY - 1, xInterval, yInterval, minX, minY, maxX, maxY, img, counter);
    } 
    else if (tmpRand == 2) 
    {
      floodPic(matrixPic, curX + 1, curY, xInterval, yInterval, minX, minY, maxX, maxY, img, counter);
    } 
    else if (tmpRand == 3) 
    {
      floodPic(matrixPic, curX - 1, curY, xInterval, yInterval, minX, minY, maxX, maxY, img, counter);
    }
  }
}


void takeRest(int[][] matrixPic, float xInterval, float yInterval, float minX, float minY, float maxX, float maxY, PImage img)
{
  int offsetX = (int)(random(-5, 5));
  int offsetY = (int)(random(-5, 5));
  for(int i = 0; i < matrixPic.length; i++)
  {
    for(int ii2 = 0; ii2 < matrixPic[0].length; ii2++)
    {
      if(matrixPic[i][ii2] == 0)
      {
        PImage img3 = createImage((int)xInterval, (int)yInterval, RGB);
       // System.out.println((int)xInterval * ii2 + " " + ((int)xInterval * (ii2 + 1)));
        //System.out.println((int)yInterval * i + " " + ((int)yInterval * (i + 1)));
        for (int ii = (int)xInterval * ii2; ii < (int)xInterval * (ii2 + 1); ii++) 
        {
          for (int j = (int)yInterval * i; j < (int)yInterval * (i + 1); j++) 
          {
            //System.out.println((j - (int)(yInterval * i)) +  " " + (ii - (int)(xInterval * ii2)));
            //System.out.println(ii + " " + xInterval + " " + ii2);
            img3.pixels[(j - (int)(yInterval * i))*img3.width+(ii - (int)(xInterval * ii2))] = img.pixels[j*img.width+ii];
          }
        }
        image(img3, minX + xInterval * ii2 + xInterval * offsetX, minY + yInterval * i + offsetY * yInterval, xInterval, yInterval);
      }
    }
  }
}



void fragmentFloodFill() 
{
  int numImages = 4;
  int smallerBy = 1;
  float randCutOff = int(random(5, 10));
  float deviation = 1;
  float initX = gridNumX * 2/ 3;
  float initY = gridNumY * 2 / 3;
  ArrayList<String> imageNames = new ArrayList<String>();
  
  for (int i = 1; i <= numImages; i++) 
  {
    imageNames.add(parseInt(i) + ".png");
  }
  
  Collections.shuffle(imageNames);
  
  int i2 = 0;
  for (int i = 0; i < 1; i++) 
  {
    if (i2 >= numImages)
      i2 = 0;
    String imgN = imageNames.get(i2);
    int imgRandX = (int)random(initX - deviation, initX) + 1;
    int imgRandY = (int)random(initY - deviation, initY) + 1;
    int imgRandX2 = (int)random(0, gridNumX - randCutOff);
    int imgRandY2 = (int)random(0, gridNumY - randCutOff);
    float imgW = imgRandX * gridX + (imgRandX) * betweenX;
    float imgH = imgRandY * gridY + (imgRandY) * betweenY;
    float imgX = imgRandX2 * (gridX + betweenX);
    float imgY = imgRandY2 * (gridY + betweenY);
    PImage img = loadImage(imgN);
    
    img.resize((int)imgW, (int)imgH);
    int[][] matrixPic = new int[imgRandY][imgRandX];
    floodPic(matrixPic, (int)random(imgRandX), (int)random(imgRandY), (gridX + betweenX), (gridY + betweenY), imgX, imgY, imgX + imgW, imgY + imgH, img, ((imgRandX - 1) * (imgRandY - 1) / 2));
   
    if(random(1) > 0.1)
      takeRest(matrixPic, (gridX + betweenX), (gridY + betweenY), imgX, imgY, imgX + imgW, imgY + imgH, img);

    imgRandX = (int)random(initX - deviation, initX) + 1;
    imgRandY = (int)random(initY - deviation, initY) + 1;
    imgRandX2 = (int)random(0, gridNumX - randCutOff);
    imgRandY2 = (int)random(0, gridNumY - randCutOff);
    imgW = imgRandX * gridX + (imgRandX) * betweenX;
    imgH = imgRandY * gridY + (imgRandY) * betweenY;
    imgX = imgRandX2 * (gridX + betweenX);
    imgY = imgRandY2 * (gridY + betweenY);
    
    /*  PImage img4 = createImage(img.width, img.height / 2, RGB);
     
     
     for(int ii = 0; ii < img.width; ii++)
     {
     for (int j = 0; j < img.height / 2; j++) {
     img4.pixels[j*img.width+ii] = img.pixels[(j + img.height / 2)*img.width+ii];
     }
     }
     image(img4, imgX, imgY, imgW, imgH/2);
     //image(img, imgX, imgY, imgW, imgH);*/
  }
  
  initX -= smallerBy;
  initY -= smallerBy;
  i2++;
  tint(255, 255);
}


void fragmentImages(int drawTime) 
{
  int numImages = 4;
  int smallerBy = 1;
  float randCutOff = 2;
  float deviation = 1;
  float initX = gridNumX * 2/ 3;
  float initY = gridNumY * 2 / 3;
  ArrayList<String> imageNames = new ArrayList<String>();
  for (int i = 1; i <= numImages; i++) 
  {
    imageNames.add(parseInt(i) + ".png");
  }
  Collections.shuffle(imageNames);
  int i2 = 0;
  for (int i = 0; i < drawTime; i++) 
  {
    if (i2 >= numImages)
      i2 = 0;
    String imgN = imageNames.get(i2);
    int imgRandX = (int)random(initX - deviation, initX) + 1;
    int imgRandY = (int)random(initY - deviation, initY) + 1;
    int imgRandX2 = (int)random(0, gridNumX - randCutOff);
    int imgRandY2 = (int)random(0, gridNumY - randCutOff);
    float imgW = imgRandX * gridX + (imgRandX) * betweenX;
    float imgH = imgRandY * gridY + (imgRandY) * betweenY;
    float imgX = imgRandX2 * (gridX + betweenX);
    float imgY = imgRandY2 * (gridY + betweenY);
    PImage img = loadImage(imgN);

    boolean isFrag = random(1)>0.8;
    if (random(1) < 0.5)
      tint(255, random(90, 120));
    if (isFrag)
    {
      PImage img3 = createImage(img.width, img.height / 2, RGB);
      for (int ii = 0; ii < img.width; ii++)
      {
        for (int j = 0; j < img.height / 2; j++)
        {
          img3.pixels[j*img.width+ii] = img.pixels[j*img.width+ii];
        }
      }
      image(img3, imgX, imgY, imgW, imgH/2);

      imgRandX = (int)random(initX - deviation, initX) + 1;
      imgRandY = (int)random(initY - deviation, initY) + 1;
      imgRandX2 = (int)random(0, gridNumX - randCutOff);
      imgRandY2 = (int)random(0, gridNumY - randCutOff);
      imgW = imgRandX * gridX + (imgRandX) * betweenX;
      imgH = imgRandY * gridY + (imgRandY) * betweenY;
      imgX = imgRandX2 * (gridX + betweenX);
      imgY = imgRandY2 * (gridY + betweenY);
      PImage img4 = createImage(img.width, img.height / 2, RGB);

      for (int ii = 0; ii < img.width; ii++)
      {
        for (int j = 0; j < img.height / 2; j++) 
        {
          img4.pixels[j*img.width+ii] = img.pixels[(j + img.height / 2)*img.width+ii];
        }
      }
      image(img4, imgX, imgY, imgW, imgH/2);
      //image(img, imgX, imgY, imgW, imgH);
    } 
    else 
    {
      image(img, imgX, imgY, imgW, imgH);
    }

    initX -= smallerBy;
    initY -= smallerBy;
    i2++;
    tint(255, 255);
  }
}
 //<>//

void drawCheckAllCoor(String imgN, float xCor1, float yCor1, float width1, float height1, ArrayList<ImageCoor> arr)
{
  for (int i = 0; i < gridNumX; i++) 
  {
    for (int i2 = 0; i2 < gridNumY; i2++) 
    {
    }
  }
}

boolean  doOverlap(float x1, float y1, float x2, float y2, float px1, float py1, float px2, float py2) 
{ //<>//
   // If one rectangle is on left side of other
   if (x1 > px2 || px1 > x2) 
   {
      return false;
   }
 
   // If one rectangle is above other
   if (y1 > py2 || py1 > y2) 
   {
     return false;
   }
 
   return true;
}

boolean checkCollide(ArrayList<ImageCoor> arr, float x1, float y1, float x2, float y2) 
{ //<>//
  for (int i = 0; i < arr.size(); i++) {
    ImageCoor curImg = arr.get(i);

    // If one rectangle is on left side of other OR if one rectangle is above other
    //println("\nCoordinate array size is : "+ arr.size()+ "curImg.x1 =" + curImg.x1 +" curImg.x2 =" + curImg.x2 +" curImg.y1 =" + curImg.y1 +" curImg.y2 =" + curImg.y2);
    //println("x1 =" + x1 +" x2 =" + x2 +" y1 =" + y1 +" y2 =" + y2);
    if (doOverlap(curImg.x1, curImg.y1, curImg.x2, curImg.y2, x1, y1, x2, y2))
      return true;
  }
  return false;
}

// draw random-sized random colored rectangles
void drawRandomRectangles() 
{
  System.out.println("==> drawRandomRectangles()");
  int numImages = 2;
  int smallerBy = 1;
  float randCutOff = 2;
  float deviation = 4;
  float initX = gridNumX;
  float initY = gridNumY;
  
  for (int i = 0; i < numImages; i++) {
    int imgRandX = (int)random(initX - deviation, initX) + 1;
    int imgRandY = (int)random(initY - deviation, initY) + 1;
    int imgRandX2 = (int)random(0, gridNumX - randCutOff);
    int imgRandY2 = (int)random(0, gridNumY - randCutOff);
    float imgW = imgRandX * gridX + (imgRandX) * betweenX;
    float imgH = imgRandY * gridY + (imgRandY) * betweenY;
    float imgX = imgRandX2 * (gridX + betweenX);
    float imgY = imgRandY2 * (gridY + betweenY);
    
    pushMatrix();
    colorMode(RGB);
    fill(color(random(255), random(255), random(255)));
    rect(imgX, imgY, imgW, imgH);
    popMatrix();
    
    initX -= smallerBy;
    initY -= smallerBy;
  }
}

// Ian: not used: get 1.jpg, 2.jpg, 3.jpg and 4.jpg
void drawRandomImages(int drawTime)
{
  System.out.println("random");
  int numImages = 11;
  int smallerBy = 1;
  float randCutOff = 2;
  float deviation = 4;
  float initX = gridNumX;
  float initY = gridNumY;
  ArrayList<String> imageNames = new ArrayList<String>();
  for (int i = 1; i <= numImages; i++) 
  {
    imageNames.add(parseInt(i) + ".png");
  }
  Collections.shuffle(imageNames);
  
  int i2 = 0;
  for (int i = 0; i < drawTime; i++) 
  {
    if (i2 >= numImages)
      i2 = 0;
    String imgN = imageNames.get(i2);
    int imgRandX = (int)random(initX - deviation, initX) + 1;
    int imgRandY = (int)random(initY - deviation, initY) + 1;
    int imgRandX2 = (int)random(0, gridNumX - randCutOff);
    int imgRandY2 = (int)random(0, gridNumY - randCutOff);
    float imgW = imgRandX * gridX + (imgRandX) * betweenX;
    float imgH = imgRandY * gridY + (imgRandY) * betweenY;
    float imgX = imgRandX2 * (gridX + betweenX);
    float imgY = imgRandY2 * (gridY + betweenY);
    PImage img = loadImage(imgN);
    image(img, imgX, imgY, imgW, imgH);
    initX -= smallerBy;
    initY -= smallerBy;
    i2++;
  }
}

//Ian: not used. To draw 1.jpg-4.jpg many times
void drawNoCollideImages(int drawTimeInput) 
{
  System.out.println("drawNoCollideImages()");
  int numImages = 11;
  int drawTimes = drawTimeInput;
  float initX = 4;
  float initY = 4;
  ArrayList<String> imageNames = new ArrayList<String>();
  ArrayList<ImageCoor> imageCoordinates = new ArrayList<ImageCoor>();
  
  for (int i = 1; i <= numImages; i++) 
  {
    imageNames.add(parseInt(i) + ".png");
  }
  
  Collections.shuffle(imageNames);
  
  for (int i = 0; i < drawTimes; i++) 
  {
    String imgN = imageNames.get(i % numImages);

    float imgRandX = initX;
    float imgRandY = initY;
    float imgRandX2 = (int)random(0, gridNumX - 1);
    float imgRandY2 = (int)random(0, gridNumY - 1);
    float imgW = initX * (gridX + betweenX);
    float imgH = initY * (gridY + betweenY);
    float imgX = imgRandX2 * (gridX + betweenX);
    float imgY = imgRandY2 * (gridY + betweenY);
    int maxChange = 0;
    
    while (checkCollide(imageCoordinates, imgRandX2, imgRandY2, imgRandX2 + imgRandX, imgRandY2 + imgRandY))
    {
      //System.out.println(i + " " + imgX + " " + imgY + " " + imgW + " " + imgH);
      imgRandX2 = (int)random(0, gridNumX - 1) + 1;
      imgRandY2 = (int)random(0, gridNumY - 1) + 1;
      imgX = imgRandX2 * (gridX + betweenX);
      imgY = imgRandY2 * (gridY + betweenY);
      maxChange++;
      if (maxChange % 100 == 0) 
      {
        imgW -= (gridX + betweenX);
        imgH -= (gridY + betweenY);
      }
      if (imgW < gridX + betweenX)
        imgW = gridX + betweenX;
      if (imgH < gridX + betweenX)
        imgH = gridY + betweenY;
      if (maxChange == 1000) 
      {
        break;
      }
    }
    
    //System.out.println(i + " " + imgRandX + " " + imgRandY + " " + imgRandX2 + " " + imgRandY2);
    // System.out.println("Met");
    //tint(255, 126);
    PImage img = loadImage(imgN);
    if (maxChange >= 100)
      drawCheckAllCoor(imgN, imgRandX2, imgRandY2, imgRandX2 + imgRandX, imgRandY2 + imgRandY, imageCoordinates);
    else 
    {
      image(img, imgX, imgY, imgW, imgH);
      ImageCoor curImage = new ImageCoor(imgRandX2, imgRandY2, imgRandX2 + imgRandX, imgRandY2 + imgRandY);
      imageCoordinates.add(curImage);
    }
    initY -= (int)random(2);
    initX -= (int)random(2);
  }
}
