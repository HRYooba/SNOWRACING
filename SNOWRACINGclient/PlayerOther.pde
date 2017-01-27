/*
2620140542 Ooba Hiroya 大場洋哉
 PlayerOther class
 他のプレイヤーのクラス
 */


class PlayerOther extends Player 
{  
  int Num; // player番号
  String buffer; // 一旦データを保存する場所

  PlayerOther(int _num) 
  {
    init(_num);
  }

  void init(int _num) 
  {
    super.init();
    Num = _num;
    buffer = "";
    if (Num == 1)
    {
      player_color = color(255, 0, 0);
      board_color = color(150, 100, 0);
    } else if (Num == 2)
    {
      player_color = color(0, 255, 0);
      board_color = color(100, 150, 0);
    } else if (Num == 3)
    {
      player_color = color(0, 0, 255);
      board_color = color(0, 100, 150);
    } else if (Num == 4)
    {
      player_color = color(255, 255, 0);
      board_color = color(250, 200, 0);
    } else if (Num == 5)
    {
      player_color = color(200, 100, 0);
      board_color = color(100, 0, 120);
    } else if (Num == 6)
    {
      player_color = color(100, 100, 100);
      board_color = color(50, 50, 50);
    } else if (Num == 7)
    {
      player_color = color(200, 200, 200);
      board_color = color(200, 100, 100);
    } else if (Num == 8)
    {
      player_color = color(0, 200, 250);
      board_color = color(100, 0, 50);
    } else if (Num == 9)
    {
      player_color = color(100, 200, 0);
      board_color = color(0, 100, 120);
    } else if (Num == 10)
    {
      player_color = color(255, 0, 255);
      board_color = color(100, 0, 120);
    } else if (Num == 11)
    {
      player_color = color(255, 10, 100);
      board_color = color(200, 0, 80);
    } else if (Num == 12)
    {
      player_color = color(50, 50, 50);
      board_color = color(200, 20, 20);
    }
  }

  // other_playerの動き
  void move() 
  {
    if (myClient.available() > 0) 
    {
      // bufferにデータを入れていく
      buffer += myClient.readString();

      // bufferに"e"という文字がある間
      while (buffer.indexOf ("e") != -1)
      {
        // position = "playerNumber:x,y,z,angle,visual_angle,roll_angle" となるようにbufferから必要なところだけ取り出す
        String position = buffer.substring(0, buffer.indexOf("e"));

        // positionで取り出したところをbufferから消去(実際は取り出したところ以外はbufferにする)
        buffer = buffer.substring(buffer.indexOf("e")+1);

        String [] data = split(position, ","); // x,y,z,angle,visual_angle,roll_angleのデータを配列として格納する
        String [] check = split(position, "."); // ちゃんと一つの要素に対して(x=0.0)みたいになってるかチェックするため(x=0.000.0)などは排除

        if (data.length == 7 && check.length == 7 && int(data[0]) == Num)
        {
          posX = float(data[1]);
          posY = float(data[2]);
          posZ= float(data[3]);
          angle = float(data[4]);
          visual_angle = float(data[5]);
          roll_angle = float(data[6]);
        }
      }
    }
  }
}

