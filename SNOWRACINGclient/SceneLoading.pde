/*
2620140542 Ooba Hiroya 大場洋哉
 SceneLoading class
 レースが始まる前のローディング画面ののクラス
 */

class SceneLoading 
{
  Crystal []crystal = new Crystal[35]; // 雪の結晶を降らすためのクラス
  int count; // 次の場面に行くまでのカウント
  String buffer; // dataを格納する変数
  boolean flag; // データを送るフラグ
  PImage menu; // 背景

  SceneLoading()
  {
    this.init();
  }

  void init()
  {
    for (int i=0; i<crystal.length; i++) {
      crystal[i]=new Crystal();
    }
    count = 200;
    buffer = "";
    flag = false;
    menu = loadImage("menu.jpg");
  }

  // 雪の結晶のマークを描く
  void Crystal(int _angle)
  {
    pushMatrix();
    stroke(102, 240, 255, 255-whiteout);
    strokeWeight(2);
    fill(180, 250, 255, 180);
    translate(width/2, height/2-100);
    rotate(radians(_angle));
    hexagon(0, 0, 50);
    for (int i = 0; i < 6; i++) {
      hexagon(75*cos(radians(60*i)), 75*sin(radians(60*i)), 25);
    }
    popMatrix();
  }

  // 六角形を描く
  void hexagon(float _x, float _y, float _r) {
    pushMatrix();
    translate(_x, _y);
    beginShape();
    for (int i = 0; i < 6; i++) {
      vertex(_r*cos(radians(60*i)), 
      _r*sin(radians(60*i)));
    }
    endShape(CLOSE);
    popMatrix();
  }

  // 描画
  void drawDisplay()
  {
    textAlign(LEFT, BASELINE);
    tint(255);
    image(menu, 0, 0);

    // 一度しか通らないように
    if (flag == false)
    {
      // loading画面に着いたというデータをおくる
      this.sentData();
      flag = true;
    }

    // 次の画面が切り替わるまでの時間とプレイヤー番号を読み取る
    this.loadData();

    // 後ろの小さな結晶
    for (int i=0; i<crystal.length; i++) {
      crystal[i].move();
      crystal[i].display(100);
    }

    // NowLoadingの文字
    fill(92, 230, 245, 200);
    textFont(font30);
    if (frameCount/30%4 == 0)
    {
      text("NowLoading...", width-220, height-30);
    } else if (frameCount/30%4 == 1)
    {
      text("NowLoading..", width-220, height-30);
    } else if (frameCount/30%4 == 2)
    {
      text("NowLoading.", width-220, height-30);
    } else if (frameCount/30%4 == 3)
    {
      text("NowLoading", width-220, height-30);
    }

    // 中央の雪の結晶
    Crystal(frameCount);
    
    // 場面を切り替える
    if (count <= 0)
    {
      scene = 3;
      count = 60*5;
      buffer = "";
    }
  }

  // データを送る
  void sentData() 
  {
    myClient.write(playerNumber+"y");
  }

  // 画面切り替えまでのカウントを読み込む
  void loadData() 
  {
    if (myClient.available() > 0) 
    {
      // bufferにデータを入れていく
      buffer += myClient.readString();

      // bufferに"p"という文字がある間
      while (buffer.indexOf ("p") != -1)
      {
        // loadcount = "count" となるようにbufferから必要なところだけ取り出す
        String loadplayer = buffer.substring(0, buffer.indexOf("p"));

        // loadplayerで取り出したところをbufferから消去(実際は取り出したところ以外はbufferにする)
        buffer = buffer.substring(buffer.indexOf("p")+1);

        // playerFlagをtrueにする
        if (int(loadplayer) != playerNumber && int(loadplayer) < 13 && count == 200)
        {
          if (playerFlag[int(loadplayer)] == false)
          {
            playerFlag[int(loadplayer)] = true;
            MAXplayer ++;
          }
        }
      }

      // bufferに"e"という文字がある間
      while (buffer.indexOf ("e") != -1)
      {
        // loadcount = "count" となるようにbufferから必要なところだけ取り出す
        String loadcount = buffer.substring(0, buffer.indexOf("e"));

        // loadcountで取り出したところをbufferから消去(実際は取り出したところ以外はbufferにする)
        buffer = buffer.substring(buffer.indexOf("e")+1);

        // count = loadcountにする
        count = int(loadcount);
      }
    }
  }
}

