/*
2620140542 Ooba Hiroya 大場洋哉
Camera class
playerを追いかけるカメラのクラス
*/

class Camera extends Player 
{
  Camera () 
  {
    super.init();
  }

  // カメラの位置
  void cameraMove(int _count) 
  {
    float X = width/2+posX;
    float Y = height/2+posY;
    float Z = posZ;
    
    // 始まった時の動き
    if (_count < 90)
    {
      camera(X-300*cos(radians(180-_count*2+angle)), Y-100*sin(radians(60)), Z-300*sin(radians(180-_count*2+angle)), X, Y, Z, 0, 1, 0);
    }
    // 定位置に来た時
    else 
    {
      camera(X-300*cos(radians(angle)), Y-100*sin(radians(60)), Z-300*sin(radians(angle)), X, Y, Z, 0, 1, 0);
    }
  }
}

