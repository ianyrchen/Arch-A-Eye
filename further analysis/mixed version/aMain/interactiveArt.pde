color[] col_arr = 
{
  color(0, 0, 0),
  color(255, 0, 0),
  color(255, 255, 0),
  color(0, 255, 0),
  color(0, 255, 255),
  color(0, 0, 255),
  color(255, 0, 255),
  color(255, 255, 255)
};
ArrayList<Object> objects = new ArrayList<Object>();
float radius = 25; // default size of object
Boolean random_col_bool = false;
float random_dist = 5; // initialize dist for random movement
Boolean col_background_bool = false;
int col_cycle = 0;
color col_global = color(col_arr[col_cycle]); // initialize color of objects
String[] shape_arr = {"circle", "square", "star"};


void randomHundredObjects(){
  int object_count = int(random(1, 20)); // create up to 20 objects
  float object_x = random(0, 1000);
  float object_y = random(0, 800);
  
  int object_col_cycle = int(random(col_arr.length));
  int object_shape_cycle = int(random(shape_arr.length));
  float object_radius = random(0, radius);
  
  for(int i = 0; i < object_count; i++)
  {
    objects.add(new Object(object_x, object_y, object_radius, col_arr[object_col_cycle], shape_arr[object_shape_cycle]));
    
    // reset random values
    object_x = random(0, 1000);
    object_y = random(0, 800);
    object_col_cycle = int(random(col_arr.length));
    object_shape_cycle = int(random(shape_arr.length));
    object_radius = random(0, radius);     
    
  }
  
  for (Object object : objects)
  {
     object.random_move();
  }
}

class Object 
{
  float x = 0, y = 0; // initialize location of object
  // initialize adjustable fields
  float r = 20; 
  String shape = "";
  color col;  
  float random_color_var = random(0, 255);
  
  PShape star; // for custom shape
  
  public Object(float x, float y, float r, color col, String shape) 
  {
    // set values locally to individual objects
    this.x = x;
    this.y = y;
    this.r = r;
    this.col = col;
    this.shape = shape;
  }

  // Object function: move. Allow movement of objects based on mouse control
  void move() 
  {
    if (dist(mouseX, mouseY, x, y) < r) 
    { // mouse is inside object   
      if (mousePressed) 
      { // if left mouse clicked, move
        x = mouseX;
        y = mouseY;
      } 
    }
    
    if(random_col_bool == false)
    {
      fill(col); // static color fill
    }
    else 
    {
      // random starting color, color cycles through default rainbow gradiant 
      fill(color(random_color_var, 255, 255)); 
      random_color_var++;
      if (random_color_var > 255) 
      {
        random_color_var = 0;
      }
    }
    
    // set shape of object 
    if (shape == "circle")
    {    
      ellipse(x, y, r, r); // object set to cicle
    }    
    else if (shape == "square") 
    {
      rect(x, y, r, r); // object set to square
    }
    else if (shape == "star") 
    {
      // object set to star
      star = createShape();
      star.beginShape();
      star.vertex(x, y-r*7/10);
      star.vertex(x+r*2/10, y-r*3/10);
      star.vertex(x+r*7/10, y-r*2/10);
      star.vertex(x+r*3/10, y+r/10);
      star.vertex(x+r*4/10, y+r*6/10);
      star.vertex(x, y+r*3/10);
      star.vertex(x-r*4/10, y+r*6/10);
      star.vertex(x-r*3/10, y+r/10);
      star.vertex(x-r*7/10, y-r*2/10);
      star.vertex(x-r*2/10, y-r*3/10);
      star.endShape(CLOSE);
      shape(star); // display star
    }
  }  
  
  // Object function: random_move. Boolean toggled to allow objects to move randomly on screen
  void random_move()
  { 
    x += random(-random_dist, random_dist);
    y += random(-random_dist, random_dist);
        
    if(random_col_bool == false){
      fill(col); // static color fill
    }
    else 
    {
      // random starting color, color cycles through rainbow gradiant 
      fill(color(random_color_var, 255, 255));
      random_color_var++;
      if (random_color_var > 255)
      {
        random_color_var = 0;
      }
    }
    
    // set shape of object 
    if (shape == "circle") 
    {    
      ellipse(x, y, r, r); // object set to cicle
    }
    else if (shape == "square") 
    {
      rect(x, y, r, r); // object set to square
    }
    
    else if (shape == "star") 
    {
      // object set to star
      star = createShape();
      star.beginShape();
      star.vertex(x, y-r*7/10);
      star.vertex(x+r*2/10, y-r*3/10);
      star.vertex(x+r*7/10, y-r*2/10);
      star.vertex(x+r*3/10, y+r/10);
      star.vertex(x+r*4/10, y+r*6/10);
      star.vertex(x, y+r*3/10);
      star.vertex(x-r*4/10, y+r*6/10);
      star.vertex(x-r*3/10, y+r/10);
      star.vertex(x-r*7/10, y-r*2/10);
      star.vertex(x-r*2/10, y-r*3/10);
      star.endShape(CLOSE);
      
      shape(star); // display star
    }
  }
  
  // Object function: col_update. 
  // Updates color of objects on screen by holding any key and clicking
  void col_update() 
  {
    if (dist(mouseX, mouseY, x, y) < r) 
    { // mouse is inside object   
      if (mousePressed && keyPressed) 
      { // if any key pressed and left mouse clicked
        col = col_global; // update object color to current global color
      }
    }
  }
  
}
