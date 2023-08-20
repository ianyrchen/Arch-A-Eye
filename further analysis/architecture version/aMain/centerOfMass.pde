float totalSumGrayscale = 0.0;

// Get the sum of grayscale for each row and each column seperately
void getColorImgGrayscale(PImage imgForMass, float[] sumOfRowGrayscale, float[] sumOfColumnGrayscale)
{
  totalSumGrayscale = 0.0;
  
  for (int y = 0; y < height; y++) 
  {
    float sumOfGray = 0.0;
    
    for (int x = 0; x < width; x++) 
    {
      int loc = x + y * width;
      color pColor = imgForMass.pixels[loc];
      float gray =  0.299*red(pColor) + 0.587*green(pColor) + 0.114*blue(pColor);
      sumOfGray += gray;
    }
    sumOfRowGrayscale[y] = sumOfGray;
    //println("sumOfRowGrayscale["+y+"]= "+sumOfGray);
    totalSumGrayscale += sumOfGray;
  }
  
  //set the value for Column array
  for (int x2 = 0; x2 < width; x2++) 
  {
    float sumOfGray2 = 0.0;
    for (int y2 = 0; y2 < height; y2++) 
    {
      int loc2 = x2 + y2 * width;
      color pColor2 = imgForMass.pixels[loc2];
      float gray2 =  0.299*red(pColor2) + 0.587*green(pColor2) + 0.114*blue(pColor2);
      sumOfGray2 += gray2;
    }
    sumOfColumnGrayscale[x2] += sumOfGray2;
    //println("sumOfRowGrayscale["+x2+"]= "+sumOfGray2);
  }
}



int getCenterOfMassValue(float[] sumOfGrayscale)
{
  float difference = totalSumGrayscale;
  float topSum = 0.0; float bottomSum = totalSumGrayscale;
  int marker = 0; // recording the divide line of top and bottom part of the array
  
  for(int i = 0; i < sumOfGrayscale.length; i++)
  {
    if(difference > Math.abs(bottomSum - topSum))
    {
      difference = Math.abs(bottomSum - topSum);
      marker = i;
    }
    
    topSum += sumOfGrayscale[i];
    bottomSum -= sumOfGrayscale[i];
  }

  //println("marker = "+marker);
  return marker;
}
