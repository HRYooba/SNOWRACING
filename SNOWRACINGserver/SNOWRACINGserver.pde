/*
2620140542 Ooba Hiroya 大場洋哉
 SNOERACING main code
 */

//--------------------------------------------------------------
/* 説明書
 1. SNOWRACINGserver.pdeを実行しましょう
 2. 実行確認できたらSNOWRACINGclient.pdeも実行しましょう
 3. 下にある『int playerNumber = 』で自分のプレイヤー番号を決めます
 4. SNOWRACINGclient.pdeで”LoadingNow…”が表示されるまで適当に選択し進めます
 5. SNOWRACINGserver.pdeにいき対戦するプレイヤーが赤くなったらEnterを押し画面が暗くなるのを確認
 6. レースが始まったら 方向キー右左で曲がり 方向キー上でジャンプ　ardinoの感圧センサでアクセル
 7. 全員がゴールしたら左の矢印をクリックしSNOWRACINGserver.pdeの画面でEnterを押す
 8. 3に戻る
 */
//--------------------------------------------------------------

/*------ライブラリ群-------*/
import processing.net.*;
/*-----------------------*/

// サーバー
Server myServer = new Server(this, 1111);

DataPlayer data1; // プレイヤーの要素を送受信するクラス
DataSceneLoading data2; // ローディング中の送受信するクラス
DataGoal data3; // ゴールの送受信するクラス

int scene; // 場面の変数
boolean countFlag; // countdownを始めるか始めないか
boolean [] playerFlag; // どのプレイヤーが参戦するか
boolean [] GoalFlag = new boolean [13]; // ゴールしたかのフラグ
int MAXplayer; // プレイしてる人数

void setup() 
{
  size(300, 300);
  data1 = new DataPlayer();
  data2 = new DataSceneLoading();
  data3 = new DataGoal();
  scene = 3;
  countFlag = false;
  playerFlag = new boolean[13];
  for (int i=1; i<13; i++)
  {
    playerFlag[i] = false;
    GoalFlag[i] = false;
  }
  MAXplayer = 0;
}

void draw() 
{
  // クライアントがLoading画面のとき
  if (scene == 3)
  {
    data2.update();
    data2.drawDisplay();
  }
  // クライアントがレース画面のとき 
  else if (scene == 4)
  {
    data1.update();
    data3.update();
    data3.drawDisplay();
  }
}

void stop() 
{
  myServer.stop();
}

void keyPressed()
{
  if (keyCode == ENTER)
  {
    if (scene == 3)
    {
      countFlag = true;
    } else if (scene == 4)
    {
      data1.init();
      data2.init();
      data3.init();
      data2.sentCount();
      countFlag = false;
      for (int i=1; i<13; i++)
      {
        playerFlag[i] = false;
        GoalFlag[i] = false;
      }
      MAXplayer = 0;
      scene = 3;
    }
  }
}

