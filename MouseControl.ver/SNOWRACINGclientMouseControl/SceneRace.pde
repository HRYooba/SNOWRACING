/*
2620140542 Ooba Hiroya 大場洋哉
 SceneRace class
 レース画面のクラス
 */


class SceneRace
{
  Player player; // プレイヤーのクラス
  PlayerOther [] otherPlayer = new PlayerOther[13]; //1~12までのプレイヤーを作成
  Camera camera; // カメラのクラス
  Background background1; // 背景のクラス
  Course course1; // コースのクラス
  HUD hud; // HUD
  int count; // 画面が切り替わってからスタートまでのカウント
  int startDash; // スタートダッシュのフラグ
  boolean BGMstop; // BGMを止めるかのフラグ
  String buffer; // サーバーから送られてきたデータを保存する

  SceneRace()
  {
    this.init();
  }

  void init()
  {
    player = new Player();
    for (int i=1; i<=12; i++)
    {
      if (i != playerNumber)
      {
        otherPlayer[i] = new PlayerOther(i);
      }
    }
    camera = new Camera();
    background1 = new Background();
    course1 = new Course();
    hud = new HUD();
    count = 0;
    startDash = 0;
    BGMstop = false;
    buffer = "";
    raceBGM.rewind();
    snowboard.rewind();
    resultSE.rewind();
  }

  // 画面の描画
  void drawDisplay()
  {
    // スタートするタイミング
    if (count >= 90+60*4)
    {
      start = true;
      if (raceBGM.position() == 0 && BGMstop == false)
      {
        raceBGM.setGain(-4);
        raceBGM.loop();
      }
    }
    // スタートする前  
    else 
    {
      count ++;
      if (count >= 90+60)
      {
        countdown.setGain(5);
        countdown.play();
      }
    }

    // 各々を動かす
    this.moveAnything();

    if (GoalTime[playerNumber] != "" && player.speed == 0)
    {
    } else 
    {
      // データを送信
      player.sentData();
    }

    // 走る音再生
    if (player.speed > 0)
    {
      snowboard.setGain(int(player.speed*20/player.MAX_speed)-10);
      if (snowboard.position() == 0)
      {
        snowboard.loop();
      }
    } else 
    {
      snowboard.rewind();
    }

    // 各々を描画
    background1.drawBackground();
    course1.test_course();
    camera.cameraMove(count);
    for (int i=1; i<=12; i++)
    {
      if (i != playerNumber && playerFlag[i] == true)
      {
        otherPlayer[i].drawPlayer();
      }
    }
    player.drawPlayer();

    // カメラのアングルが定位置に来たらHUDを表示
    if (count >= 90) 
    {
      hud.drawHUD();
      // スタートする前にRedyGoを表示
      if (start == false && count >= 90+60)
      {
        hud.RedyGo(count);
      }
    }

    if (GoalFlag[playerNumber])
    {
      this.sentData();
      this.loadData();

      hud.drawFinish(0);
      
      if (BGMstop == false)
      {
        raceBGM.pause();
        raceBGM.rewind();
        snowboard.pause();
        snowboard.rewind();
        startdash.pause();
        startdash.rewind();
        countdown.pause();
        countdown.rewind();
      }
      BGMstop = true;
      resultBGM.setGain(10);
      resultBGM.play();
      if(resultSE.position() == 0)
      {
        resultSE.setGain(-4);
        resultSE.loop();
      }

      int n = 0;
      for (int i=1; i<13; i++)
      {
        if (i == playerNumber && Ranking[i] != 0)
        {
          n++;
        }
        if (playerFlag[i] && Ranking[i] != 0 && GoalFlag[i])
        {
          n++;
        }
      }
      if (MAXplayer == 1)
      {
        Ranking[playerNumber] = 1;
      }
      if (n == MAXplayer)
      {
        hud.drawFinish(n);
        hud.drawResult();
        hud.Botton();
      }
    }
  }

  // いろいろなものをplayerクラスと連動して動かすため
  void moveAnything() 
  {
    if (mousePressed && count >= 90+60*2 && count <= 90+60*2+20 && startDash == 0)
    {
      startDash = 1;
    } else if (mousePressed && count < 90+60*2)
    {
      startDash = 2;
    }
    if (hud.mil > 30 && startDash == 1)
    {
      startDash = 0;
    }

    // スタートしたら各々のクラスの座標を動かせるようにする
    if (start)
    {
      // playerを動かす
      player.move();
      for (int i=1; i<=12; i++)
      {
        if (i != playerNumber && playerFlag[i] == true)
        {
          otherPlayer[i].move();
        }
      }

      // スタートダッシュの処理
      if (startDash == 1)
      {
        startdash.setGain(-10);
        startdash.play();
        player.acceleration = 4.5;
      } else
      {
        player.acceleration = 0.5;
      }

      // あたり判定
      this.check(); 

      // あたり判定を検出するためposX, posY, posZの値を変動させるため
      course1.posX = player.posX;
      course1.posY = player.posY;
      course1.posZ = player.posZ;
      // 背景のposX, posY, posZの値を変動させるため
      background1.posX = player.posX;
      background1.posY = player.posY;
      background1.posZ = player.posZ;
      // カメラのposX, posY, posZ, angleの値を変動させるため
      camera.posX = player.posX;
      camera.posY = player.posY;
      camera.posZ = player.posZ;
      camera.angle = player.angle;
      // HUDのposX, posY, posZ, angle, speedの値を変動させるため
      hud.posX = player.posX;
      hud.posY = player.posY;
      hud.posZ = player.posZ;
      hud.angle = player.angle;
      hud.speed = player.speed;
    }
    
    for (int i=1; i<=12; i++)
    {
      if (i != playerNumber && playerFlag[i] == true && GoalFlag[i] == false)
      {
        otherPlayer[i].move();
      }
    }
  }

  // あたり判定の処理
  void check()
  {
    if (course1.exam == 1)
    {
      player.posX = course1.sent_examX;
      player.speed = player.speed*0.9;
    } else if (course1.exam == 2)
    {
      player.posX = course1.sent_examX;
      player.speed = player.speed*0.9;
    } else if (course1.exam == 3)
    {
      player.posX = course1.sent_examX;
      player.posZ = course1.sent_examZ;
      player.speed = player.speed*0.9;
    } else if (course1.exam == 4)
    {
      player.posX = course1.sent_examX;
      player.posZ = course1.sent_examZ;
      player.speed = player.speed*0.9;
    } else if (course1.exam == 5)
    {
      player.posZ = course1.sent_examZ;
      player.speed = player.speed*0.9;
    } else if (course1.exam == 6)
    {
      player.posZ = course1.sent_examZ;
      player.speed = player.speed*0.9;
    } else if (course1.exam == 7)
    {
      player.posX = course1.sent_examX;
      player.posZ = course1.sent_examZ;
      player.speed = player.speed*0.7;
    }
  }

  // データを送る
  void sentData() 
  {
    myClient.write(playerNumber+","+GoalTime[playerNumber]+"g");
  }

  // 画面切り替えまでのカウントを読み込む
  void loadData() 
  {
    if (myClient.available() > 0) 
    {
      // bufferにデータを入れていく
      buffer += myClient.readString();

      // bufferに"p"という文字がある間
      while (buffer.indexOf ("g") != -1)
      {
        // loadcount = "count" となるようにbufferから必要なところだけ取り出す
        String loadrank = buffer.substring(0, buffer.indexOf("g"));

        // loadplayerで取り出したところをbufferから消去(実際は取り出したところ以外はbufferにする)
        buffer = buffer.substring(buffer.indexOf("g")+1);

        String [] data = split(loadrank, ","); // x,y,z,angle,visual_angle,roll_angleのデータを配列として格納する

        if (data.length == 3 && int(data[0]) <= 12)
        {
          GoalTime[int(data[0])] = data[1];
          Ranking[int(data[0])] = int(data[2]);
          GoalFlag[int(data[0])] = true;
        }
      }
    }
  }
}

