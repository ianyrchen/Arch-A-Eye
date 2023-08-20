String[][] input;
int CurrentFileNumber = 0;
float xLen;
float yLen;
float gridX;
float betweenX;
float gridNumX;
float gridY;
float betweenY;
float gridNumY;
float redBackground;
float greenBackground;
float blueBackground;
int hueBackground;
int saturationBackground;
int brightnessBackground;
color backgroundColor;
color titleColor;
color titleBackColor;
color headerColor;
boolean randomFont;
boolean useRandomBackground = false;

//ArrayList<ColorInfo> presetColors = new ArrayList<ColorInfo>();
HashSet<Character> lowerCaseDescent = new HashSet<Character>();
HashSet<Character> lowerCaseNorm = new HashSet<Character>();

void setupColors()
{
  println("===>Entering setupColors()");
  
  randomFont = random(1) > 0.5;
  randomFont = false;  //Ian: need to take this out
  
  colorMode(HSB, 360, 100, 100);

  getDominantColorOfImage();
  
  hueBackground = int(dominantImgHue + random(20, 340))%360;
  saturationBackground = int(dominantImgSaturation + random(10, 90))%100;
  brightnessBackground = int(dominantImgBrightness + random(10, 90))%100;
  
  if(!useRandomBackground)
  {
    backgroundColor = color(hueBackground, saturationBackground, brightnessBackground);
    titleColor = color(int(hueBackground + random(150, 210))%360, int(saturationBackground + random(30, 70))%100, int(brightnessBackground + random(30, 70))%100);
    headerColor = color(int((hueBackground + random(150, 210)) % 360), int(saturationBackground+ random(30, 70))%100, int((brightnessBackground + random(30, 70))%100));
  }
  else
  {
    //Random generate the colors
    backgroundColor = color(random(0, 360), random(0, 100), random(0, 100));
    titleColor = color(random(0, 360), random(0, 100), random(0, 100));
    headerColor = color(random(0, 360), random(0, 100), random(0, 100));
  }
println("===>Leaving setupColors()");
/*
  //hueBackground = int(random(360));
  //saturationBackground = int(random(100));
  //brightnessBackground = int(random(100));
  backgroundColor = color(hueBackground, saturationBackground, brightnessBackground);
*/ //<>//
}


// Get X, Y and text from input file
void setNums()
{
  gridX = 60;
  betweenX = 5;
  gridNumX = 9;
  gridY = 60;
  betweenY = 5;
  gridNumY = 12;
  xLen = (gridX + betweenX)*(gridNumX - 1)+gridX;
  yLen = xLen * SCALE;
  
  // The hashset is used to randomnize the shape behind the text
  setupHashset();
}

void getInputFileNumber()
{
  if(TypeOfImage == ImageType.BOOKCOVER) 
  {
    CurrentFileNumber = 0;
  }
  else if(TypeOfImage == ImageType.MOVIEPOSTER) 
  {
    CurrentFileNumber = 1;
  }
  else if(TypeOfImage == ImageType.EVENTPOSTER) 
  {
    CurrentFileNumber = 2;
  }
}

void setupHashset(){
  lowerCaseDescent.add('g');
  lowerCaseDescent.add('j');
  lowerCaseDescent.add('p');
  lowerCaseDescent.add('q');
  lowerCaseDescent.add('y');
  lowerCaseNorm.add('a');
  lowerCaseNorm.add('c');
  lowerCaseNorm.add('e');
  lowerCaseNorm.add('i');
  lowerCaseNorm.add('m');
  lowerCaseNorm.add('n');
  lowerCaseNorm.add('o');
  lowerCaseNorm.add('r');
  lowerCaseNorm.add('s');
  lowerCaseNorm.add('u');
  lowerCaseNorm.add('v');
  lowerCaseNorm.add('w');
  lowerCaseNorm.add('x');
  lowerCaseNorm.add('z');
}
