/*
2620140542 Ooba Hiroya 大場洋哉
Background class
playerを中心として円柱を作り、それを背景とするクラス
*/

class Background extends Player 
{

  PImage background_image; // 背景テクスチャの画像を格納する変数

  Background() 
  {
    super.init();
    background_image = loadImage("background.jpg"); // 背景テクスチャのロード
  }

  // 背景の円柱を描く関数
  void drawBackground()
  {
    pushMatrix();
    translate(width/2, height/2, 0); 
    translate(posX, -250, posZ); 
    beginShape(QUAD_STRIP);
    texture(background_image);
    for (int i=0; i<=360; i+=10) 
    {
      fill(255);
      noStroke();
      if (sin(radians(i)) <= 0) 
      {
        vertex(5000*cos(radians(i)), -1500, 5000*sin(radians(i)), -1280*sin(radians(i)), 0);
        vertex(5000*cos(radians(i)), 1500, 5000*sin(radians(i)), -1280*sin(radians(i)), 264);
      } 
      else 
      {
        vertex(5000*cos(radians(i)), -1500, 5000*sin(radians(i)), 1280*sin(radians(i)), 0);
        vertex(5000*cos(radians(i)), 1500, 5000*sin(radians(i)), 1280*sin(radians(i)), 264);
      }
    }
    endShape();
    popMatrix();
  }
}

