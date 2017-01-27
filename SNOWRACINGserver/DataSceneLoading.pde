/*
2620140542 Ooba Hiroya 大場洋哉
 DataSceneLoading
 */

class DataSceneLoading 
{

  int count; // 次の場面に行くまでのカウント
  String buffer; // dataを格納する変数

  DataSceneLoading ()
  {
    this.init();
  }

  void init()
  {
    count = 200;
    buffer = "";
  }
  
  // すべての処理をする
  void update()
  {
    this.loadData();
    
    int Num = 0; // 参戦するプレイヤーの人数を数える
    for (int i=1; i<13; i++)
    {
      if (playerFlag[i])
      {
        Num++;
      }
    }
    MAXplayer = Num;
    
    if (countFlag)
    {
      count --;
      this.sentCount();
    } else {
      this.sentPlayer();
    }
    
    if (count <= 0)
    {
      scene = 4;
    }
  }
  
  // 画面に描
  void drawDisplay()
  {
    background(255);
    if (countFlag)
    {
      background(0);
    }
    for (int i=1; i<13; i++)
    {
      int wid = 0;
      int hei = 0;
      if (i >= 1 && i <= 4)
      {
        wid = i;
      }
      if (i >= 5 && i <= 9)
      {
        wid = i-4;
      }
      if (i >= 9)
      {
        wid = i-8;
      }
      if (i >= 1 && i <= 4)
      {
        hei = 1;
      }
      if (i >= 5 && i <= 9)
      {
        hei = 2;
      }
      if (i >= 9)
      {
        hei = 3;
      }
      noStroke();
      fill(0);
      ellipse(width/4*wid-37.5, height/3*hei-50, 50, 50);
      text("player"+i, width/4*wid-60, height/3*hei-10);
      if (playerFlag[i])
      {
        noStroke();
        fill(255, 0, 0);
        ellipse(width/4*wid-37.5, height/3*hei-50, 50, 50);
        text("player"+i, width/4*wid-60, height/3*hei-10);
      }
    }
  }

  // データを送る
  void sentCount() 
  {
    myServer.write(count+"e");
  }

  void sentPlayer()
  {
    for (int i=0; i<13; i++)
    {
      if (playerFlag[i])
      {
        myServer.write(i+"p");
      }
    }
  }

  // クライアントがローディング画面になったかを確認
  void loadData()
  {
    Client nextClient = myServer.available();
    // もしloading画面にクライアントが着いたら
    if (nextClient != null) 
    {
      // bufferにデータを入れていく
      buffer += nextClient.readString();

      // bufferに"e"という文字がある間
      while (buffer.indexOf ("y") != -1)
      {
        // loadNnumber = "playerNumber" となるようにbufferから必要なところだけ取り出す
        String loadNumber = buffer.substring(0, buffer.indexOf("y"));

        // yをbufferから消去(実際は取り出したところ以外はbufferにする)
        buffer = buffer.substring(buffer.indexOf("y")+1);

        int playerNumber = int(loadNumber);

        // その人のフラグをオンにする
        playerFlag[playerNumber] = true;
      }
    }
  }
}

