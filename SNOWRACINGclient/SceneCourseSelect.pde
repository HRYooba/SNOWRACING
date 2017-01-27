/*
2620140542 Ooba Hiroya 大場洋哉
 SceneCourseSelect class
 コースセレクト画面のクラス
 */


class SceneCourseSelect
{
  PImage background; // 背景の画像
  PImage [] course = new PImage[10]; // コース１の画像
  int[] select_flag = new int[10]; // どのコースを選択したかのフラブ
  Crystal []crystal = new Crystal[35]; // 雪の結晶を降らすため

  SceneCourseSelect()
  {
    init();
  }

  void init()
  {
    for (int i=0; i<crystal.length; i++) {
      crystal[i]=new Crystal();
    }
    background = loadImage("menu.png");
    for (int i=0; i<10; i++)
    {
      course[i] = loadImage("course"+(i+1)+".png");
      select_flag[i] = 0;
    }
  }

  // 描画
  void drawDisplay()
  {
    textAlign(LEFT, BASELINE);
    if (selectcourseBGM.position() == 0)
    {
      selectcourseBGM.loop();
    }
    strokeJoin(ROUND);
    //background(70, 170, 250);
    tint(255);
    image(background, 0, 0, width, height);
    for (int i=0; i<crystal.length; i++) {
      crystal[i].move();
      crystal[i].display(100);
    }

    // 白い透明の四角
    fill(255, 50);
    noStroke();
    rect(0, 150, width, 390);

    // 下の帯的なの
    fill(0, 0, 50, 100);
    noStroke();
    rect(250, height-110, width-500, 70);
    for (int i=0; i<7; i++)
    {
      fill(0, 0, 50, 100-i*(2+sin(radians(frameCount%360)))*8);
      if (i%2 == 0)
      {
        rect(250-i*10-10, height-110, 10, 10);
        rect(250-i*10-20, height-100, 10, 10);
        rect(250-i*10-10, height-90, 10, 10);
        rect(250-i*10-20, height-80, 10, 10);
        rect(250-i*10-10, height-70, 10, 10);
        rect(250-i*10-20, height-60, 10, 10);
        rect(250-i*10-10, height-50, 10, 10);

        rect(width-250+i*10+0, height-110, 10, 10);
        rect(width-250+i*10+10, height-100, 10, 10);
        rect(width-250+i*10+0, height-90, 10, 10);
        rect(width-250+i*10+10, height-80, 10, 10);
        rect(width-250+i*10+0, height-70, 10, 10);
        rect(width-250+i*10+10, height-60, 10, 10);
        rect(width-250+i*10+0, height-50, 10, 10);
      }
    }

    rightBotton();
    leftBotton();

    // コース画像
    // 上段
    courseImage(course[0], 25, 170, "course1", 0);
    courseImage(course[1], 25+200, 170, "course2", 1);
    courseImage(course[2], 25+400, 170, "course3", 2);
    courseImage(course[3], 25+600, 170, "course4", 3);
    courseImage(course[4], 25+800, 170, "course5", 4);
    // 下段
    courseImage(course[5], 25, 370, "course6", 5);
    courseImage(course[6], 25+200, 370, "course7", 6);
    courseImage(course[7], 25+400, 370, "course8", 7);
    courseImage(course[8], 25+600, 370, "course9", 8);
    courseImage(course[9], 25+800, 370, "course10", 9);
  }

  // 右側のOKボタン
  void rightBotton() 
  {
    if (mouseX >= width-150 && mouseX <= width && mouseY >= height-100 && mouseY <= height-50) 
    {
      // 右のOKボタン
      strokeWeight(2);
      stroke(205);
      fill(60);
      rect(width-1, height-100, -150, 50);
      noStroke();
      strokeWeight(2);
      stroke(100);
      rect(width-3, height-98, -146, 46);

      // OKの文字
      fill(205, 150, 0);
      textFont(font30, 30);
      text("OK", width-130, height-65);

      if (mousePressed) {
        selectcourseBGM.rewind();
        selectcourseBGM.pause();
        menuok.setGain(-5);
        menuok.play();
        menuok.rewind();
        scene = 2;
        whiteout = 255;
      }
    } else 
    {
      // 右のOKボタン
      strokeWeight(2);
      stroke(255);
      fill(90);
      rect(width-1, height-100, -150, 50);
      noStroke();
      strokeWeight(2);
      stroke(150);
      rect(width-3, height-98, -146, 46);

      // OKの文字
      fill(255, 200, 50);
      textFont(font30, 30);
      text("OK", width-130, height-65);
    }
  }

  // 左の戻るボタン
  void leftBotton() 
  {
    if (mouseX >= 0 && mouseX <= 150 && mouseY >= height-100 && mouseY <= height-50)
    {
      // 左の戻るボタン
      strokeWeight(2);
      stroke(205);
      fill(60);
      rect(1, height-100, 150, 50);
      noStroke();
      strokeWeight(2);
      stroke(100);
      rect(3, height-98, 146, 46);

      // 矢印
      noStroke();
      fill(205, 150, 0);
      rect(100, height-85, 30, 20);
      triangle(80, height-75, 110, height-95, 110, height-55);

      if (mousePressed)
      {
        selectcourseBGM.pause();
        selectcourseBGM.rewind();
        ng.setGain(6);
        ng.play();
        ng.rewind();
        whiteout = 255;
        scene = 0;
      }
    } else
    {
      // 左の戻るボタン
      strokeWeight(2);
      stroke(255);
      fill(90);
      rect(1, height-100, 150, 50);
      noStroke();
      strokeWeight(2);
      stroke(150);
      rect(3, height-98, 146, 46);

      // 矢印
      noStroke();
      fill(255, 200, 50);
      rect(100, height-85, 30, 20);
      triangle(80, height-75, 110, height-95, 110, height-55);
    }
  }

  // コースのイメージ
  void courseImage(PImage _imagefile, int _x, int _y, String _name, int _n)
  {
    if (mouseX >= _x-3 && mouseX <= _x-3+156 && mouseY >= _y-3 && mouseY <= _y-3+156)
    {
      // 選択した状態
      if (mousePressed && select_flag[_n] == 0)
      {
        select_flag[_n] = -1;
      }
      // 選択された状態でマウスを離したら
      if (mousePressed == false && select_flag[_n] == -1)
      {
        select_flag[_n] = 1;
        ok.setGain(5);
        ok.play();
        ok.rewind();
      }
      // 選択解除をしようと選択
      if (mousePressed && select_flag[_n] == 1)
      {
        select_flag[_n] = -2;
      }
      // 選択解除をしようとした状態でマウスが離れた
      if (mousePressed == false && select_flag[_n] == -2)
      {
        select_flag[_n] = 0;
      }

      strokeWeight(6);
      stroke(0, 0, 50, 60);
      noFill();
      rect(_x-3, _y-3, 156, 156);
      tint(200);
      image(_imagefile, _x, _y, 150, 150);

      pushMatrix();
      translate(_x+75, _y+75);
      stroke(255, 200, 50);
      strokeWeight(10);
      line(-75-14, -75-10, -75+30, -75-10);
      line(-75-10, -75-14, -75-10, -75+30);
      rotate(radians(90));
      line(-75-14, -75-10, -75+30, -75-10);
      line(-75-10, -75-14, -75-10, -75+30);
      rotate(radians(90));
      line(-75-14, -75-10, -75+30, -75-10);
      line(-75-10, -75-14, -75-10, -75+30);
      rotate(radians(90));
      line(-75-14, -75-10, -75+30, -75-10);
      line(-75-10, -75-14, -75-10, -75+30);
      popMatrix();

      int sum = 0;
      for (int i=0; i<9; i++)
      {
        sum += select_flag[i];
      }
      if (sum != 1)
      {
        fill(255);
        textFont(font30, 30);
        text(_name, width/2-50-_name.length()/2, height-70);
      }
    } else
    {
      strokeWeight(6);
      stroke(0, 0, 50, 60);
      noFill();
      rect(_x-3, _y-3, 156, 156);
      tint(255);
      image(_imagefile, _x, _y, 150, 150);
    }

    // もし選択解除されたら
    if (select_flag[_n] == 1) {
      tint(200);
      image(_imagefile, _x, _y, 150, 150);

      pushMatrix();
      translate(_x+75, _y+75);
      stroke(255, 100, 20);
      strokeWeight(10);
      line(-75-14, -75-10, -75+30, -75-10);
      line(-75-10, -75-14, -75-10, -75+30);
      rotate(radians(90));
      line(-75-14, -75-10, -75+30, -75-10);
      line(-75-10, -75-14, -75-10, -75+30);
      rotate(radians(90));
      line(-75-14, -75-10, -75+30, -75-10);
      line(-75-10, -75-14, -75-10, -75+30);
      rotate(radians(90));
      line(-75-14, -75-10, -75+30, -75-10);
      line(-75-10, -75-14, -75-10, -75+30);
      popMatrix();

      fill(255);
      textFont(font30, 30);
      text(_name, width/2-50-_name.length()/2, height-70);
    }
  }
}

