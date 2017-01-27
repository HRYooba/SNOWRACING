/*
2620140542 Ooba Hiroya 大場洋哉
 DataGoal Class
 */

class DataGoal
{
  String buffer; // dataを格納する変数
  String [] GoalTime = new String [13]; // ゴールタイムを保存する

  DataGoal()
  {
    this.init();
  }

  void init()
  {
    buffer = "";
    for (int i=1; i<13; i++)
    {
      GoalTime[i] = "";
    }
  }
  
  // すべての処理をする
  void update()
  {
    this.loadData();
    
    int count = 0; // ゴールした人数を数える
    for (int i=1; i<13; i++)
    {
      if (playerFlag[i] && GoalFlag[i])
      {
        count ++;
      }
    }
    
    // 全員がゴールしたら
    for (int i=1; i<13; i++)
    {
      if (count == MAXplayer && GoalFlag[i])
      {
        this.sentData(i);
      }
    }
  }
  
  // クライアントから送られてきたデータを処理する
  void loadData()
  {
    Client nextClient = myServer.available();
    if (nextClient != null) 
    {
      // bufferにデータを入れていく
      buffer += nextClient.readString();

      // bufferに"g"という文字がある間
      while (buffer.indexOf ("g") != -1)
      {
        // time = "number,TIME,g" となるようにbufferから必要なところだけ取り出す
        String time = buffer.substring(0, buffer.indexOf("g"));

        // timeで取り出したところをbufferから消去(実際は取り出したところ以外はbufferにする)
        buffer = buffer.substring(buffer.indexOf("g")+1);
        
        // number timeのデータを配列として格納する
        String [] data = split(time, ","); 
        
        if (data.length == 2 && int(data[0]) <= 12 && playerFlag[int(data[0])])
        {
          GoalTime[int(data[0])] = data[1];
          GoalFlag[int(data[0])] = true;
        }
      }
    }
  }

  // データを送る
  void sentData(int _num) 
  {
    myServer.write(_num+","+GoalTime[_num]+","+Rank(_num)+"g");
  }
  
  // ゴール時間をスコアとして変換
  int TimeScore(int _n)
  {
    int score = 0;
    String [] data = split(GoalTime[_n], "'");

    if (data.length == 3)
    {
      score += int(data[0])*10000;
      score += int(data[1])*100;
      score += int(data[2])*10;
    }
    return score;
  }
  
  // スコアを元にそのプレイヤーの順位を決める
  int Rank(int _n)
  {
    int rank = 1;
    for (int i=1; i<13; i++)
    {
      if (playerFlag[i])
      {
        if (TimeScore(_n) > TimeScore(i))
        {
          rank++;
        }
      }
    }
    return rank;
  }
  
  // 画面に表示
  void drawDisplay()
  {
    background(0);
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
      if (playerFlag[i])
      {
        noStroke();
        fill(255, 0, 0);
        ellipse(width/4*wid-37.5, height/3*hei-50, 50, 50);
        text("player"+i, width/4*wid-60, height/3*hei-10);
        if (GoalFlag[i])
        {
          noStroke();
          fill(0, 0, 255);
          ellipse(width/4*wid-37.5, height/3*hei-50, 50, 50);
          text("player"+i, width/4*wid-60, height/3*hei-10);
        }
      }
    }
  }
}

