int score = 0;
int rasterWidth = 50, rasterHeight = 50;
ArrayList<PVector> snake = new ArrayList();
PVector item = new PVector();
int direction = 0;
float updateTime = 100;
long lasttime;
PVector head = new PVector();
boolean item_collected = false;
float takevecX, rakevecY;
boolean gameRunning = true;
void setup()
{
  size(1000, 1000);
  background(0);
  snake.add(new PVector(width/2, height/2));
  //snake.add(new PVector(width/2+width/rasterWidth, height/2+height/rasterHeight));
  lasttime = millis();
  item.x = int(random(0, rasterWidth-1))*width/rasterWidth;
  item.y = int(random(0, rasterHeight-1))*height/rasterHeight;
  textSize(width/50);
}

void draw()
{
  if(gameRunning)
  {
    stroke(255);
    background(0);
    for(int i = 0; i < width; i+= width/rasterWidth)
    {
      line(i, 0, i, height);
      for(int j = 0; j < height; j+= height/rasterHeight)
      {
        line(0, j, width, j);
      }
    }
    updateItem();
    updateSnake();
    
    if(head.x == item.x && head.y == item.y)
      item_collected = true;
      
    text("Score: " + score, (width/10)*9, height/10);
  }
  else
  {
    exit();
  }
}

void keyPressed()
{
  if(key == CODED)
  {
    if(keyCode == LEFT && direction != 1)
    {
      direction = 3;
    }
    else if(keyCode == RIGHT && direction != 3)
    {
      direction = 1;
    }
    else if(keyCode == UP && direction != 2)
    {
      direction = 0; 
    }
    else if(keyCode == DOWN && direction != 0)
    {
      direction = 2;
    }
  }
}

void updateSnake()
{
  PVector addpos = new PVector(0, 0, 0);
  rectMode(CORNER);
  fill(255);
  noStroke();
  if(millis() > lasttime + updateTime)
  {
    //println("***TIME UPDATE STEP***");
    lasttime = millis();
    head = snake.get(0).copy();
    //println("head before moving forward: " + head);
    if(direction == 0)
    {
      head.y-=height/rasterHeight; 
    }
    else if(direction == 1)
    {
      head.x+=width/rasterWidth; 
    }
    else if(direction == 2)
    {
      head.y+=height/rasterHeight; 
    }
    else if(direction == 3)
    {
      head.x-=width/rasterWidth; 
    }
    
    //get snake add position
    addpos = snake.get(snake.size()-1).copy();

    //set snake a step forward 
    if(snake.size() > 1)
    {
      for(int seg = snake.size()-1; seg > 0; seg--)
      {
        snake.set(seg, snake.get(seg-1));
      }
    }
    //set head of snake since its the same as position 2 of the snake
    snake.set(0, head);
    //snake.set(0, new PVector(0, 0, 0));
    //println("head after moving forward: " + head);
    //check boundaries collision
    if(head.x >= width)
      head.x = 0;
    else if(head.x <= 0-width/rasterWidth)
      head.x = width-width/rasterWidth;
    else if(head.y >= height)
      head.y = 0;
    else if(head.y <= 0-height/rasterHeight)
      head.y = height-height/rasterHeight;
  }
  
  //println("***REGULAR STEP***");
  //println("snakeSize: " + snake.size());
  for(int i = 0; i < snake.size(); i++)
  {
    PVector p = snake.get(i);
    rect(p.x, p.y, width/rasterWidth, height/rasterHeight);
    //println("snakeTilePosition"+ str((i+1)) + ":" + p);
  }
  if(item_collected)
  {
    item_collected = false;
    snake.add(addpos);
    score++;
  }
  
  //check self collision
  PVector p2 = snake.get(0);
  PVector p;
  for(int i = 1; i < snake.size(); i++)
  {
    p = snake.get(i);
    if(p.x == p2.x && p.y == p2.y)
    {
      gameRunning = false;
    }
  }
}

void updateItem()
{
  if(item_collected)
  {
    if(updateTime > 20)
      updateTime--;
    item.x = int(random(0, rasterWidth-1))*width/rasterWidth;
    item.y = int(random(0, rasterHeight-1))*height/rasterHeight;
    
  }
  noStroke();
  fill(255, 0, 0);
  rect(item.x, item.y, width/rasterWidth, height/rasterHeight); 
}
