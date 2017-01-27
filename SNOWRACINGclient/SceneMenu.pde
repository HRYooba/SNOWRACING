// 1-4-21 Asako Kumon
// SceneMenu class
// オープニングとメニュー画面のクラス

class SceneMenu {

  Crystal []crystal = new Crystal[35];
  int [] flag = new int [4]; // ボタンを押したか押してないかを判断するフラグ
  PImage menu;    // menu画面の背景
  PImage offer;   // 提供画像
  int n=0; // ブラックアウトするのに必要な変数(0~255*2)

  SceneMenu() {
    init();
  }

  void init() {
    for (int i=0; i<crystal.length; i++) {
      crystal[i]=new Crystal();   // インスタンス化
    }
    for (int i=0; i<flag.length; i++) {
      flag[i]=0;   // ボタンを押していない状態
    }
    menu=loadImage("menu.png");
    offer=loadImage("offer.jpg");
  }

  // 提供とメニュー画面の表示
  void drawDisplay() {
    textAlign(LEFT, BASELINE);
    
    // メニュー画面を黒から白へ(明転)
    if (n<255*2) {
      n+=2;
    }
    tint(n-255);
    image(menu, 0, 0, width, height);
    
    // 提供画面を白から黒へ(暗転)
    if (n<255) {
      tint(255-n);
      image(offer, 0, 0, width, height);
      op.setGain(-5);
      op.play();
    } else {  // メニュー画面になったら
      if (menuBGM.position() == 0)
      {
        menuBGM.loop();
      }
    }
    // 雪を降らせる
    for (int i=0; i<crystal.length; i++) {
      crystal[i].move();
      crystal[i].display(100);
    }
    // ボタンの表示
    botton(width/2+100, 250, n-255, "ひとりで", 0);
    botton(width/2+100, 340, n-255, "みんなで", 1);
    botton(width/2+100, 430, n-255, "リプレイ", 2);
    botton(width/2+100, 520, n-255, "せってい", 3);
  }

  // モード選択のボタン
  void botton(int x, int y, int a, String name, int n) {
    // ボタンの上にマウスカーソルがある時
    if (mouseX >= x && mouseX <= x+300 && mouseY >= y && mouseY <= y+50)
    {
      // ボタンの形 
      noStroke();
      fill(255, 180, 50, a-155);
      rect(x, y, 300, 50);
      triangle(x-20, y+25, x, y, x, y+50);
      triangle(x+300, y, x+300, y+50, x+320, y+25);
      fill(255, 150, 20, a-155);
      rect(x-5, y-5, 310, 60);
      triangle(x-20-5, y+25, x-5, y-5, x-5, y+50+5);
      triangle(x+300+5, y-5, x+300+5, y+50+5, x+320+5, y+25);
      fill(255, a);
      textFont(font30j, 30);
      text(name, x+20, y+35);

      if (mousePressed)
      {
        flag[n] = 1;   // 押した
      }
      // メニュー画面でボタン押した時
      if (mousePressed == false && flag[n] == 1)
      {
        menuBGM.pause();
        menuBGM.rewind();
        menuok.setGain(-5);
        menuok.play();
        menuok.rewind(); 
        scene = 1;   // ステージ選択画面
        whiteout = 255;
        flag[n] = 0;
      }
    } else 
    {
      // カーソルがボタンの上に無い時
      noStroke();
      fill(0, 0, 50, a-155);
      rect(x, y, 300, 50);
      triangle(x-20, y+25, x, y, x, y+50);
      triangle(x+300, y, x+300, y+50, x+320, y+25);
      fill(50, a-155);
      rect(x-2, y-2, 304, 54);
      triangle(x-20-2, y+25, x-2, y-2, x-2, y+50+2);
      triangle(x+300+2, y-2, x+300+2, y+50+2, x+320+2, y+25);
      fill(255, a);
      textFont(font30j, 30);
      text(name, x+20, y+35);
      flag[n] = 0;
    }
  }
}

