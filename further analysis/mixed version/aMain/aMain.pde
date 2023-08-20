import java.io.*;
import java.util.*;
import java.util.HashMap;
import java.lang.*;
import processing.opengl.*;

enum ImageType {
  BOOKCOVER,
  MOVIEPOSTER,
  EVENTPOSTER
}

void settings(){
  
  setNums();
  size(int(xLen), int(yLen));


}

void setup(){
}

void draw()
{
}

ImageType TypeOfImage = ImageType.BOOKCOVER;

void keyPressed(){
  if(key == '0'){
    println("0 is pressed and book cover will be generated!!!!");
    TypeOfImage = ImageType.BOOKCOVER;
  }
  else if(key == '1'){
    println("1 is pressed and movie poster will be generated!!!!");
    TypeOfImage = ImageType.MOVIEPOSTER;
  }
  else if(key == '2'){
    println("2 is pressed and event/ad flyer will be generated!!!!");
    TypeOfImage = ImageType.EVENTPOSTER;
  }
  
  getInputFileNumber();
    //Ian Temp
  for(int i= 0; i < 10; i++)
  {
    generateImageByRules();
  }
  afterSavingRawImage();
}

  
void afterSavingRawImage()
{
  colorMode(RGB, 255, 255, 255);  // need to use RGB for conversion
  //Now load the images again and calculare the Center Of Mass
  println("\nNumOfImagesGenerated= " +NumOfImagesGenerated);
  Table table = new Table();
  table.addColumn("Rule");
  table.addColumn("X Coordinate of Mass Center");
  table.addColumn("Y Coordinate of Mass Center");
  table.addColumn("Distance to Physical Center");
  
  for(int i= 0; i< NumOfImagesGenerated; i++)
  //int i =0;  //Ian tmp
  {
    PImage imgForMass;
    imgForMass = loadImage(".\\data\\GeneratedRawImages\\generatedRaw" + i +".png"); 
    //println("load image generatedRaw"+i);
    imgForMass.loadPixels();
    imageMode(CENTER);
    image(imgForMass, width/2, height/2);
      
    float [] sumOfRowGrayscale = new float [height];
    float [] sumOfColumnGrayscale = new float [width];
    getColorImgGrayscale(imgForMass, sumOfRowGrayscale, sumOfColumnGrayscale);

    int centerOfMassY = getCenterOfMassValue(sumOfRowGrayscale);
    int centerOfMassX = getCenterOfMassValue(sumOfColumnGrayscale);
    
    fill(0);
    ellipse(centerOfMassX, centerOfMassY, 25, 25);
    
    // calculate the distance between center of mass and the physical center
    // if the distance > 100 pixels, discard the sketch, otherwise store into a directory
    float distance = sqrt((width/2 - centerOfMassX)* (width/2 - centerOfMassX) + (height/2 - centerOfMassY) * (height/2 - centerOfMassY));
    String rule ="";
    if(CurrentRule == Rules.RULEOFTHIRDS) rule ="RULEOFTHIRDS";
    if(CurrentRule == Rules.GOLDENMEAN) rule ="GOLDENMEAN";
    if(CurrentRule == Rules.GOLDENTRIANGLE) rule ="GOLDENTRIANGLE";
    println( centerOfMassX + ",  " + centerOfMassY + ", distance is " + distance);
    TableRow newRow = table.addRow();
    newRow.setString("Rule", rule);
    newRow.setInt("X Coordinate of Mass Center", centerOfMassX);
    newRow.setInt("Y Coordinate of Mass Center", centerOfMassY);
    newRow.setFloat("Distance to Physical Center", distance);
    saveTable(table, "data/new.csv");
    //if(distance < 100)  //Ian tmp
      // save the generated images into a diretory
    save(".\\data\\GeneratedAcceptableImages\\" + i + ".png");
  } 
  
}


void drawElements(){
  //setupColors();
  drawImages(); 
  drawText();
}


void drawText(){
  drawTitle(); 
  drawHeaders(); 
}

void drawTextByRules(){
  initInputTexts();
  drawTitleByRules();  
  drawHeadersByRules();
}


void interactiveArt(){
  randomHundredObjects(); // for decotation purpose
}


// gridX, betweenX, betweenY and gridY are from input file
void drawGrid(){
  // Ian: doens't define stroke, so no line will be drawn
  stroke(240);
  for(float i = gridX; i < width; i+=(gridX + betweenX)) //<>// //<>//
  {
    //stroke(255); // white color
    line(i, 0, i, height);
    line(i + betweenX, 0, i + betweenX, height);
  }
  
  for(float i = gridY; i < height; i+=(gridY + betweenY))
  {
    line(0, i, width, i);
    line(0, i + betweenY, width, i + betweenY);
  }
}
