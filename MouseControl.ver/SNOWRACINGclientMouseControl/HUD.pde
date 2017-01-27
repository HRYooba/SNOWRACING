/*
2620140542 Ooba Hiroya 大場洋哉
 HUD class
 Head-Up Displayの表示
 */

class HUD extends Player
{
  Result result;
  int StartTime; // スタートした時間を記憶
  int mil; // 1000分の1秒
  int sec1; // 1秒
  int sec2; // 10秒
  int min1; // 1分
  int min2; // 10分

  HUD ()
  {
    this.init();
  }

  void init() 
  {
    super.init();
    result = new Result();
    StartTime = -1; // 現実ではありえない数値にする
    mil = 0;
    sec1 = 0;
    sec2 = 0;
    min1 = 0;
    min2 = 0;
  }

  void drawHUD()
  {
    textAlign(LEFT, BASELINE);
    if (GoalFlag[playerNumber])
    {
      // ゴールしたらゴール時間を保存
      GoalTime[playerNumber] = ""+min2+""+min1+"'"+sec2+""+sec1+"'"+mil;
    } else {
      this.TIME();
      this.meter();
    }
  }

  // 今がスタートからどのくらい経ったかを測る関数
  int getNow(int _StartTime) {
    int num;
    num = millis() - _StartTime;
    return num;
  }

  // 右上のTIMEの表示
  void TIME()
  {
    textAlign(LEFT, BASELINE);
    noLights();
    hint(DISABLE_DEPTH_TEST);
    // スタートした瞬間だけ通る
    if (start && StartTime == -1) 
    {
      // StartTimeに現在のmillisを格納
      StartTime = millis();

      // 描画
      pushMatrix();
      translate(width/2, height/2, 0); 
      translate(posX, posY, posZ); 
      rotateY(radians(-1*(angle)-90));
      textFont(font30, 15);
      fill(50);
      text("TIME ", 100, -140);
      fill(50);
      text(""+min2+""+min1+"'"+sec2+""+sec1+"'"+mil+"0", 145, -140);
      popMatrix();
    } 
    // スタートした後に通る
    else if (start && StartTime != -1)
    {
      // 数値を調整して変数に格納
      mil = getNow(StartTime)%1000/10;
      sec1 = getNow(StartTime)/1000%10;
      sec2 = getNow(StartTime)/10000%6;
      min1 = getNow(StartTime)/60000%10;
      min2 = getNow(StartTime)/600000%6;

      // 描画
      pushMatrix();
      translate(width/2, height/2, 0); 
      translate(posX, posY, posZ); 
      rotateY(radians(-1*(angle)-90));
      textFont(font30, 15);
      fill(50);
      text("TIME ", 100, -140);
      fill(50);
      text(""+min2+""+min1+"'"+sec2+""+sec1+"'"+mil, 145, -140);
      popMatrix();
    }
    // スタートする前
    else if (start == false && StartTime == -1)
    {
      // 描画
      pushMatrix();
      translate(width/2, height/2, 0); 
      translate(posX, posY, posZ); 
      rotateY(radians(-1*(angle)-90));
      textFont(font30, 15);
      fill(50);
      text("TIME ", 100, -140);
      fill(50);
      text(""+min2+""+min1+"'"+sec2+""+sec1+"'"+mil+"0", 145, -140);
      popMatrix();
    }
    hint(ENABLE_DEPTH_TEST);
  }

  // RedyGoの描画
  void RedyGo(int _num)
  {
    textAlign(LEFT, BASELINE);
    int theta = (_num - (90+60))*6%360; // 0~360
    int count = 3-(_num - (90+60))*6/360; // 3,2,1,0

      noLights();
    hint(DISABLE_DEPTH_TEST);
    // タイムバーの描画
    pushMatrix();
    translate(width/2, height/2, 0); 
    translate(posX, posY-100, posZ); 
    rotateY(radians(-1*(angle)-90));
    for (int i=0; i<theta; i++)
    {
      fill(theta+150, count*50, 0);
      noStroke();
      ellipse(30*cos(radians(i-90)), 30*sin(radians(i-90)), 8, 8);
    }    
    popMatrix();

    // countdown描画
    pushMatrix();
    translate(width/2, height/2, 0); 
    translate(posX+8, posY-100+11, posZ);
    rotateY(radians(-1*(angle)-90));
    textFont(font100, 30);
    fill(50);
    if (count != 0)
    {
      text(""+count, 0, 0);
    }
    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }

  // スピードメーター
  void meter()
  {
    textAlign(LEFT, BASELINE);
    noLights();
    hint(DISABLE_DEPTH_TEST);
    pushMatrix();
    translate(width/2, height/2, 0); // 画面真ん中に 
    translate(posX, posY, posZ); // playerとともに動く
    rotateY(radians(-1*(angle)-90)); // 角度調整
    translate(220, 130, 0); // 画面のどこに移動するか
    rotateX(radians(18)); // 歪み調整

    // メーター部分
    noFill();
    stroke(100);
    strokeWeight(2);
    arc(0, 0, 130, 130, radians(110), radians(120+190));
    arc(0, 0, 120, 120, radians(110), radians(120+190));
    // メーターの区切り
    strokeWeight(3);
    fill(100);
    textFont(font30, 7);
    for (int i=0; i<=5; i++)
    {
      if (i < 5)
      {
        line(60*cos(radians(120+i*36+18)), 60*sin(radians(120+i*36+18)), 65*cos(radians(120+i*36+18)), 65*sin(radians(120+i*36+18)));
      }
      line(55*cos(radians(120+i*36)), 55*sin(radians(120+i*36)), 65*cos(radians(120+i*36)), 65*sin(radians(120+i*36)));
      text(""+i*20, (55-i*1.5)*cos(radians(120+i*36)), (55-i*1.5)*sin(radians(120+i*36)));
    }
    // 棒
    strokeWeight(5);
    stroke(200, 30, 20);
    line(0, 0, 40*cos(radians(this.speed/MAX_speed*180+120)), 40*sin(radians(this.speed/MAX_speed*180+120)));
    // 真ん中の点
    noStroke();
    fill(200, 30, 20);
    ellipse(0, 0, 5, 5);

    popMatrix();
    hint(ENABLE_DEPTH_TEST);
  }

  // 結果の表示
  void drawResult()
  {
    pushMatrix();
    noLights();
    hint(DISABLE_DEPTH_TEST);
    translate(width/2, height/2, 0); // 画面真ん中に 
    translate(posX, posY, posZ); // playerとともに動く
    rotateY(radians(-1*(angle)-90)); // 角度調整
    rotateX(radians(17)); // 歪み調整
    for (int i=1; i<13; i++ ) {
      if (i != playerNumber)
      {
        if (playerFlag[i])
        {
          result.result_screen(i, Ranking[i], GoalTime[i]);
        }
      } else 
      {
        result.result_screen(playerNumber, Ranking[playerNumber], GoalTime[playerNumber]);
      }
    }
    for (int j=MAXplayer+1; j<13; j++)
    {
      result.result_screen(0, j, GoalTime[j]);
    }
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
  
  // Finishの表示
  void drawFinish(int _flag)
  {
    pushMatrix();
    noLights();
    hint(DISABLE_DEPTH_TEST);
    translate(width/2, height/2, 0); // 画面真ん中に 
    translate(posX, posY, posZ); // playerとともに動く
    rotateY(radians(-1*(angle)-90)); // 角度調整
    rotateX(radians(17)); // 歪み調整
    result.finish(_flag);
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
  
  // ゴールした後の戻るボタン
  void Botton()
  {
    pushMatrix();
    noLights();
    hint(DISABLE_DEPTH_TEST);
    translate(width/2, height/2, 0); // 画面真ん中に 
    translate(posX, posY, posZ); // playerとともに動く
    rotateY(radians(-1*(angle)-90)); // 角度調整
    rotateX(radians(17)); // 歪み調整
    result.leftBotton();
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
}

