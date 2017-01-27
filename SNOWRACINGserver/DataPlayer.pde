/*
2620140542 Ooba Hiroya 大場洋哉
 DataPlayer Class
 */

class DataPlayer 
{
  String buffer; // データを格納する変数
  String data; // プレイヤーの要素を格納

  DataPlayer()
  {
    this.init();
  }

  void init()
  {
    buffer = "";
    data = "";
  }

  // すべての処理をする
  void update()
  {
    int count = 0; // ゴールしてないプレイヤーの人数を数える
    for (int i=1; i<13; i++)
    { 
      if (GoalFlag[i] == false)
      {
        if (playerFlag[i])
        {
          count++;
        }
      }
    }
    // もし全員ゴールしてるなら
    if (MAXplayer-count != MAXplayer)
    {
      this.loadData();
    }
  }

  // データを送る
  void sentData() 
  {
    myServer.write(data+"e");
  }

  // 座標などのデータを読み込む
  void loadData()
  {
    Client nextClient = myServer.available();
    if (nextClient != null) 
    {
      // bufferにデータを入れていく
      buffer += nextClient.readString();

      // bufferに"e"という文字がある間
      while (buffer.indexOf ("e") != -1)
      {
        // position = "playerNumber:x,y,z,angle,visual_angle,roll_angle" となるようにbufferから必要なところだけ取り出す
        String position = buffer.substring(0, buffer.indexOf("e"));

        // 
        String [] num = split(position, ","); 
        data = position;

        this.sentData();
        
        // positionで取り出したところをbufferから消去(実際は取り出したところ以外はbufferにする)
        buffer = buffer.substring(buffer.indexOf("e")+1);
      }
    }
  }
}

