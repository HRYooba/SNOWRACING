/*
2620140538 Yamasawa Soichiro 山澤総一郎
 Result class
 プレイヤーがゴールしたらFINISHと表示させ、全員がゴールしたら結果を表示させるためのクラス
*/


class Result {
  int count = 0;  //FINISHの文字の透過度
  int transparency=0;  //結果表示の際の戻るボタンの透過度
  float finishSize;  //FINISHという文字の最初の大きさ
  float speed;  //結果表示する文字などの出てくる速さ
  float[] box_pos = new float[13];  //結果表示をする文字の下にある長方形のY座標
  float[] ranking_posX = new float[13];  //1st～12thの文字のX座標
  float[] name_posX = new float[13];  //プレイヤー名のX座標
  float[] time_posX = new float[13];  //経過時間のX座標
  float[] text_posY = new float[13];  //文字系を表示するY座標

  Result() {
    this.init();
  }

  void init() {
    finishSize = 500;
    speed = 30;
    for (int i=1; i<13; i++) {
      box_pos[i] = 1050+(12-i)*10;      
      ranking_posX[i] = 1050+(12-i)*10+10;
      name_posX[i] = 1050+(12-i)*10+130;
      time_posX[i] = 1050+(12-i)*10+365;
      text_posY[i] = 55+55*(i-1);
    }
  }

  //ゴールした際のFINISHという文字表示
  void finish(int flag) {
    pushMatrix();
    translate(-width/2, -height/2, -300);
    if ( finishSize >= 140 ) {
      finishSize -= finishSize/10;  // 毎回1/10引くことで大きさの変化を小さくしている
    }
    if (flag == MAXplayer) {
      count += 10;  //FINISHを表示させたらcountの値を上げて消す(255-countなので)
    }
    textAlign(CENTER, CENTER);
    textFont(font100, finishSize);
    fill( 255, 215, 0, 255 - count);
    text("FINISH", width/2, height/2);
    popMatrix();
  }

  //全員がゴールした時の結果表示
  void result_screen ( int playerNum, int ranking, String time_required) {
    pushMatrix();
    translate(-width/2, -height/2, -300);
    textAlign(LEFT, BASELINE);
    //長方形
    if ( 450 < box_pos[ranking] ) {
      box_pos[ranking] = box_pos[ranking] - speed;  
    } else {
      box_pos[ranking] = 450;
    }
    noStroke();
    if ( playerNum == playerNumber ) {  //自分の順位の長方形を黄色、自分でないのは青にする
      fill(255, 180, 50, 200);
    } else {
      fill(0, 0, 50, 200);
    }
    rect( box_pos[ranking], -35+55*ranking, 500, 50);
    
    //文字系の座標
    if ( 460 < ranking_posX[ranking] ) {
      ranking_posX[ranking] = ranking_posX[ranking] - speed;
    } else {
      ranking_posX[ranking] = 460;
    }      
    if ( 580 < name_posX[ranking] ) {
      name_posX[ranking] = name_posX[ranking] - speed;
    } else {
      name_posX[ranking] = 580;
    }
    if ( 815 < time_posX[ranking] ) {
      time_posX[ranking] = time_posX[ranking] - speed;
    } else {
      time_posX[ranking] = 815;
    }
    
    //各順位の文字とその色
    textFont(font100, 35);
    if (ranking==1) {
      fill( 245, 235, 0);
      text("1st", ranking_posX[ranking], text_posY[ranking]);
    } else if (ranking==2) {
      fill( 192, 192, 192);
      text("2nd", ranking_posX[ranking], text_posY[ranking]);
    } else if (ranking==3) {
      fill( 196, 112, 34);
      text("3rd", ranking_posX[ranking], text_posY[ranking]);
    } else {
      fill(255, 255, 255, 200);
      text(ranking+"th", ranking_posX[ranking], text_posY[ranking]);
    }
    fill(255, 255, 255, 200);
    textFont( font100, 30 );
    if ( playerNum != 0 ) {
      text("Player"+playerNum, name_posX[ranking], text_posY[ranking]);
      textFont( font100, 25 );
      text(time_required, time_posX[ranking], text_posY[ranking]);
    }
    popMatrix();
  }

  // 左下に出る戻るボタン
  void leftBotton() 
  {
    pushMatrix();
    translate(-width/2, -height/2, -300);
    if (transparency<=200) {
      transparency+=25;
    }
    if (mouseX >= 0 && mouseX <= 150 && mouseY >= height-100 && mouseY <= height-50)
    {
      // 左の戻るボタン
      strokeWeight(2);
      stroke(205);
      fill(60, 60, 60, transparency);
      rect(1, height-100, 150, 50);
      noStroke();
      strokeWeight(2);
      stroke(100);
      rect(3, height-98, 146, 46);

      // 矢印
      noStroke();
      fill(205, 150, 0, transparency+55);
      rect(100, height-85, 30, 20);
      triangle(80, height-75, 110, height-95, 110, height-55);

      if (mousePressed)
      {
        ng.play();
        ng.rewind();
        resultSE.pause();
        resultBGM.pause();
        race.init();
        courseSelect.init();
        loading.init();
        start = false;
        for (int i=1; i<13; i++)
        {
          GoalFlag[i] = false;
          playerFlag[i] = false;
          GoalTime[i] = "";
          Ranking[i] = 0;
        }
        MAXplayer = 1;
        whiteout = 255;
        scene = 0;
      }
    } else
    {
      // 左の戻るボタン
      strokeWeight(2);
      stroke(255, 255, 255, transparency);
      fill(90, 90, 90, transparency);
      rect(1, height-100, 150, 50);
      noStroke();
      strokeWeight(2);
      stroke(150, 150, 150, transparency);
      rect(3, height-98, 146, 46);

      // 矢印
      noStroke();
      fill(255, 200, 50, transparency+55);
      rect(100, height-85, 30, 20);
      triangle(80, height-75, 110, height-95, 110, height-55);
    }
    popMatrix();
  }
}
