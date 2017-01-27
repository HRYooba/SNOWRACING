/*
2620140542 Ooba Hiroya 大場洋哉
 SNOWRACING main code
 */

//--------------------------------------------------------------
/* 説明書
 1. SNOWRACINGserver.pdeを実行しましょう
 2. 実行確認できたらSNOWRACINGclient.pdeも実行しましょう
 3. 下にある『int playerNumber = 』で自分のプレイヤー番号を決めます
 4. SNOWRACINGclient.pdeで”LoadingNow…”が表示されるまで適当に選択し進めます
 5. SNOWRACINGserver.pdeにいき対戦するプレイヤーが赤くなったらEnterを押し画面が暗くなるのを確認
 6. レースが始まったら 方向キー右左で曲がり 方向キー上でジャンプ　mousePressedでアクセル
 7. 全員がゴールしたら左の矢印をクリックしSNOWRACINGserver.pdeの画面でEnterを押す
 8. 3に戻る
 */
//--------------------------------------------------------------

//************************************************************** 
int playerNumber = 1; // プレイヤー番号(1~12)
String IP = "127.0.0.1"; // サーバーのIPアドレス
//**************************************************************


/*------ライブラリ群-------*/
import ddf.minim.*;
import processing.net.*;
/*-----------------------*/

/* 使用した音楽素材フリーサイト
 http://dova-s.jp  
 http://pocket-se.info
 http://taira-komori.jpn.org/freesound.html
 http://on-jin.com
 http://soundeffect-lab.info
 */
// 音楽
Minim  minim; // Minim型変数であるminimの宣言
AudioPlayer op; // サウンドデータ格納用の変数
AudioPlayer ok; // サウンドデータ格納用の変数
AudioPlayer ng; // サウンドデータ格納用の変数
AudioPlayer menuok; // サウンドデータ格納用の変数
AudioPlayer countdown; // サウンドデータ格納用の変数
AudioPlayer startdash; // サウンドデータ格納用の変数
AudioPlayer snowboard; // サウンドデータ格納用の変数
AudioPlayer raceBGM; // サウンドデータ格納用の変数
AudioPlayer menuBGM; // サウンドデータ格納用の変数
AudioPlayer selectcourseBGM; // サウンドデータ格納用の変数
AudioPlayer cursor; // サウンドデータ格納用の変数
AudioPlayer resultBGM; // サウンドデータ格納用の変数
AudioPlayer resultSE; // サウンドデータ格納用の変数

// クライアント
Client myClient = new Client(this, IP, 1111);

// クラス
SceneRace race; // レース場面
SceneCourseSelect courseSelect; // コース選択場面
SceneLoading loading; // ローディング画面
SceneMenu menu; // メニュー画面

// フォント
PFont font30; // フォントサイズ30の英語数字
PFont font50; // フォントサイズ50の英語数字
PFont font100; // フォントサイズ100の英語数字
PFont font30j; // フォントサイズ30のひらがなカタカナ

// グローバル変数
int scene; // 画面切り替えのための変数
int whiteout; // ホワイトアウト
boolean start; // スタートしていいかの判定
boolean [] GoalFlag = new boolean [13]; // ゴールのフラグ
boolean [] playerFlag = new boolean [13]; // 他のプレイヤーの描写するかのフラグ
String [] GoalTime = new String [13]; // ゴールした時間
int [] Ranking = new int[13]; // ゴールした順位
int MAXplayer; // プレイヤーの人数
int input; // arduinoから送られてくる値

void setup() 
{
  size(1000, 700, P3D);

  minim = new Minim(this);
  op = minim.loadFile("op.mp3");
  ok = minim.loadFile("ok.mp3");
  ng = minim.loadFile("return.mp3");
  menuok = minim.loadFile("menu.mp3");
  countdown = minim.loadFile("countdown.mp3");
  startdash = minim.loadFile("startdash.mp3");
  snowboard = minim.loadFile("snowboard.mp3");
  raceBGM = minim.loadFile("Race For Fame.mp3");
  menuBGM = minim.loadFile("The pulse.mp3");
  selectcourseBGM = minim.loadFile("selectcourse.mp3");
  cursor = minim.loadFile("cursor.mp3");
  resultBGM = minim.loadFile("resultBGM.mp3");
  resultSE = minim.loadFile("result.mp3");

  race = new SceneRace();
  courseSelect = new SceneCourseSelect();
  loading = new SceneLoading();
  menu = new SceneMenu();

  font30 = loadFont("HelveticaNeue-Bold-30.vlw");
  font50 = loadFont("HelveticaNeue-Bold-50.vlw");
  font100 = loadFont("HelveticaNeue-Bold-100.vlw");
  font30j = loadFont("HelveticaNeue-Bold-30-j.vlw");

  scene = 0;
  whiteout = 0;
  start = false;
  for (int i=1; i<13; i++)
  {
    GoalFlag[i] = false;
    playerFlag[i] = false;
    GoalTime[i] = "";
    Ranking[i] = 0;
  }
  MAXplayer = 1;
}

void draw() 
{
  background(255);

  // 最初のOPからモード選択の画面
  if (scene == 0)
  {
    camera();
    whiteout -= 5;
    menu.drawDisplay();
    fill(255, whiteout);
    noStroke();
    rect(0, 0, width, height);
  } 

  // ステージ選択の画面
  else if (scene == 1)
  {
    whiteout -= 10;
    courseSelect.drawDisplay();
    fill(255, whiteout);
    noStroke();
    rect(0, 0, width, height);
  } 

  // Loading画面
  else if (scene == 2)
  {
    whiteout -= 2;
    loading.drawDisplay();
    fill(255, whiteout);
    noStroke();
    rect(0, 0, width, height);
  }

  // レース画面
  else if (scene == 3)
  {
    lights();
    ambientLight(100, 100, 100); 
    race.drawDisplay();
  }
}

void stop() {
  // サンドデータ終了
  op.close();
  ok.close();
  ng.close();
  menuok.close();
  countdown.close();
  startdash.close();
  snowboard.close();
  raceBGM.close();
  menuBGM.close();
  selectcourseBGM.close();
  cursor.close();
  resultBGM.close();
  resultSE.close();
  minim.stop();
  super.stop();

  // 通信終了
  myClient.stop();
}

