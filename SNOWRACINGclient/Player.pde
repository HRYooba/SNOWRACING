/*
2620140542 Ooba Hiroya 大場洋哉
 Player class
 playerの処理や描画のクラス
 */

class Player {

  Human main_human; // 人のキャラクタのクラス
  Arduino arduino; // Arduinoのクラス
  color player_color; // playerの色
  color board_color; // ボードの色
  float posX; // x座標
  float posY; // y座標
  float posZ; // z座標
  float angle; // player自身の座標系に対しての角度
  float visual_angle; // playerのカメラに対しての角度
  float roll_angle; // playerの腰とかの動きに対しての角度
  float acceleration; //加速度
  float speed; // 速さ
  float MAX_speed; // 最高速
  float friction; // 減速の摩擦係数
  float jamp_speed; // ジャンプの上昇スピード
  boolean jamp_flag; // ジャンプするかしないかのフラグ
  boolean jamping_flag; // ジャンプしているかしていないかのフラグ

  Player() 
  {
    this.init();
  }

  void init() 
  {
    main_human = new Human();
    arduino = new Arduino();
    if (playerNumber == 1)
    {
      player_color = color(255, 0, 0);
      board_color = color(150, 100, 0);
    } else if (playerNumber == 2)
    {
      player_color = color(0, 255, 0);
      board_color = color(100, 150, 0);
    } else if (playerNumber == 3)
    {
      player_color = color(0, 0, 255);
      board_color = color(0, 100, 150);
    } else if (playerNumber == 4)
    {
      player_color = color(255, 255, 0);
      board_color = color(250, 200, 0);
    } else if (playerNumber == 5)
    {
      player_color = color(200, 100, 0);
      board_color = color(100, 0, 120);
    } else if (playerNumber == 6)
    {
      player_color = color(100, 100, 100);
      board_color = color(50, 50, 50);
    } else if (playerNumber == 7)
    {
      player_color = color(200, 200, 200);
      board_color = color(200, 100, 100);
    } else if (playerNumber == 8)
    {
      player_color = color(0, 200, 250);
      board_color = color(100, 0, 50);
    } else if (playerNumber == 9)
    {
      player_color = color(100, 200, 0);
      board_color = color(0, 100, 120);
    } else if (playerNumber == 10)
    {
      player_color = color(255, 0, 255);
      board_color = color(100, 0, 120);
    } else if (playerNumber == 11)
    {
      player_color = color(255, 10, 100);
      board_color = color(200, 0, 80);
    } else if (playerNumber == 12)
    {
      player_color = color(50, 50, 50);
      board_color = color(200, 20, 20);
    }
    posX = 1000+playerNumber*100;
    posY = 0;
    posZ = -100;
    angle = 90;
    visual_angle = 0;
    roll_angle = 0;
    acceleration = 0.5;
    speed = 0;
    MAX_speed = 40;
    friction = 0.4;
    jamp_speed = 0;
    jamp_flag = false;
    jamping_flag = false;
  }

  // playerの描画
  void drawPlayer() 
  {
    pushMatrix();
    // 画面の中心に持ってくる
    translate(width/2, height/2, 0); 

    // playerの座標を動かす
    translate(posX, posY-15, posZ);

    // playerの回転
    rotateY(radians(-1*(angle+visual_angle)));

    // playerキャラクター
    main_human.draw_human(0, 0, 0, player_color, board_color, -1*roll_angle, posY/5);    
    popMatrix();
  }

  // playerの操作
  void move() 
  {
    // 感圧センサが感知したら
    if (arduino.pressure() == true) 
    { 
      if (GoalFlag[playerNumber] == false)
      {
        // 最高速度になるまで
        if (speed <= MAX_speed) 
        {
          // 速度を上げる
          speed = speed + acceleration*0.4;
        }
        if (keyPressed) 
        {
          // ジャンプする
          if (keyCode == UP && jamp_flag == false)
          {
            jamp_flag = true;
            jamp_speed = 10+speed*0.3;
          }
          // 右側に曲がる
          if (keyCode == RIGHT) 
          {
            angle += 1.5 - speed/MAX_speed;
            if (roll_angle < 45) 
            {
              roll_angle += 1;
            }
            if (visual_angle < 30) {
              visual_angle += 1.5 - speed/MAX_speed;
            }
          }
          // 左側に曲がる
          else if (keyCode == LEFT) 
          {
            angle -= 1.5 - speed/MAX_speed;
            if (roll_angle > -45) 
            {
              roll_angle -= 1;
            }
            if (visual_angle > -30) 
            {
              visual_angle -= 1.5 - speed/MAX_speed;
            }
          }
        } 
        // keyPressed == false
        else 
        { 
          // keyPressedをやめた時playerの画面に対しての角度を正面にする
          if (roll_angle > 0)
          {
            roll_angle -= 2;
            if (roll_angle < 0) {
              roll_angle = 0;
            }
          } else if (roll_angle < 0) 
          {
            roll_angle += 2;
            if (roll_angle > 0) {
              roll_angle = 0;
            }
          }
          if (visual_angle > 0) 
          {
            visual_angle -= speed/MAX_speed;
          } else if (visual_angle < 0) 
          {
            visual_angle += speed/MAX_speed;
          }
        }
      }
    }
    // 感圧センサが感知してない時 
    else 
    {  
      if (speed > 0) 
      {
        // 減速
        speed = speed - acceleration*friction; 
        if (keyPressed) 
        {
          // ジャンプする 
          if (keyCode == UP && jamp_flag == false)
          {
            jamp_flag = true;
            jamp_speed = 10+speed*0.3;
          }
          // 右側に曲がる
          if (keyCode == RIGHT) 
          {
            angle += 1.5 - speed/MAX_speed;
            if (roll_angle < 45) 
            {
              roll_angle += 1;
            }
            if (visual_angle < 30) 
            {
              visual_angle += 1.5 - speed/MAX_speed;
            }
          }
          // 左側に曲がる 
          else if (keyCode == LEFT) 
          {
            angle -= 1.5 - speed/MAX_speed;
            if (roll_angle > -45) 
            {
              roll_angle -= 1;
            }
            if (visual_angle > -30) 
            {
              visual_angle -= 1.5 - speed/MAX_speed;
            }
          }
        } 
        // keyPressde == false
        else 
        { 
          // keyPressedをやめた時playerの画面に対しての角度を正面にする
          if (roll_angle > 0)
          {
            roll_angle -= 2;
            if (roll_angle < 0) {
              roll_angle = 0;
            }
          } else if (roll_angle < 0) 
          {
            roll_angle += 2;
            if (roll_angle > 0) {
              roll_angle = 0;
            }
          }
          if (visual_angle > 0) 
          {
            visual_angle -= speed/MAX_speed;
          } else if (visual_angle < 0) 
          {
            visual_angle += speed/MAX_speed;
          }
        }
      }
      // speedが0以下になったら
      else if (speed <= 0) 
      {
        // 速度を0
        speed = 0;
        // playerの腰の角度を元に戻す
        if (roll_angle > 0)
        {
          roll_angle -= 2;
          if (roll_angle < 0) {
            roll_angle = 0;
          }
        } else if (roll_angle < 0) 
        {
          roll_angle += 2;
          if (roll_angle > 0) {
            roll_angle = 0;
          }
        }
      }
    }

    // ジャンプに関する処理
    if (jamp_flag) 
    {
      // 初期状態からのジャンプ
      if (posY == 0 && jamping_flag == false)
      {
        jamping_flag = true;
        jamp_speed = jamp_speed - 0.9;

        // ジャンプ中の動き
      } else if (posY < 0 && jamping_flag == true)
      {
        jamp_speed = jamp_speed - 0.9;
        if (speed > 0.6)
        {
          speed -= 0.5;
        }

        // ジャンプ終了
      } else if (posY >= 0 && jamping_flag == true)
      {
        jamp_flag = false;
        jamping_flag = false;
        jamp_speed = 0;
        posY = 0;
      }
    }

    // angleを0~360度の範囲に変換
    if (angle < 0) 
    {
      angle = 360 + angle;
    } else 
    {
      angle = angle % 360;
    }

    // 座標を動かす
    posZ = posZ + speed*sin(radians(angle));
    posY += -1*jamp_speed;
    posX = posX + speed*cos(radians(angle));
  }

  // データを送る
  void sentData() {
    myClient.write(
    playerNumber+","
      +posX+","
      +posY+","
      +posZ+","
      +angle+","
      +visual_angle+","
      +roll_angle
      +"e"
      );
  }
}

