/*
2620140562 kawasoe kotaro 川添　浩太郎
 Human class
 playerを描写するクラス
 */

class Human {

  Human() {
    init();
  }

  void init() {
  }

  // 円柱の関数
  void pillar(float length, float radius1, float radius2) {

    float x1, y1, z1;
    pushMatrix();
  //円柱の底面の円を描写
    beginShape(TRIANGLE_FAN);
    y1 = -length / 2;
    vertex(0, y1, 0);
    for (int n = 0; n <= 360; n = n + 10) {
      x1 = cos(radians(n)) * radius1;
      z1 = sin(radians(n)) * radius1;
      vertex(x1, y1, z1);
    }
    endShape();   

   //円柱の上の部分の円描写    
    beginShape(TRIANGLE_FAN);
    y1= length / 2;
    vertex(0, y1, 0);
    for (int n = 0; n <= 360; n = n + 10) {
      x1 = cos(radians(n)) * radius2;
      z1 = sin(radians(n)) * radius2;
      vertex(x1, y1, z1);
    }
    endShape();
    //円柱の側面の描写
    beginShape(TRIANGLE_STRIP);
    for (int n =0; n <= 360; n = n + 5) {
      x1 = cos(radians(n)) * radius1;
      y1 = -length / 2;
      z1 = sin(radians(n)) * radius1;
      vertex(x1, y1, z1);
      x1 = cos(radians(n)) * radius2;
      y1= length / 2;
      z1 = sin(radians(n)) * radius2;
      vertex(x1, y1, z1);
    }
    endShape();
    popMatrix();
  }

  // 人のキャラの関数
  void draw_human(float x, float y, float z, color p, color b, float r, float j) {
    rotateY(PI);
    fill(p);
    rotateX(radians(r));
    rotateZ(radians(-j));
    rotateX(radians(j/2));
    pushMatrix();
    rotateX(radians(-r*1.3));
    rotateY(radians(r));
    rotateZ(radians(j*1.3));
    rotateY(radians(j/2));
    rotateX(radians(-j/2*1.3));
    translate(0, 33, 0);
    //頭部の描写
    pushMatrix();
    translate(x, y-70, z);
    noStroke();
    sphere(12);
    popMatrix();

    //左腕の描写
    pushMatrix();
    rotateY(-PI*2/5);//----------
    translate(x+10, y-50, z);
    rotateZ(-PI/3);
    pillar(15, 3, 2);
    popMatrix();
    pushMatrix();
    rotateY(-PI*2/5);//-----------
    translate(10+5*pow(3, 1/2), -47);
    fill(0);
    sphere(4);
    fill(p);
    translate(0, 0, 10); //------
    rotateX(PI/2);
    pillar(20, 3, 2);
    popMatrix();

    //右腕の描写
    pushMatrix();
    rotateY(-PI*2/5);//--------
    translate(x-10, y-53, z);
    rotateZ(PI/2.5);
    pillar(15, 3, 2);
    popMatrix();
    pushMatrix();
    rotateY(-PI*2/5);//------------
    translate(-10-5*pow(3, 1/2), -51);
    fill(0);
    sphere(4);
    fill(p);
    translate(0, 0, 10);
    rotateX(PI/2);
    pillar(20, 3, 2);
    popMatrix();

    //胴体の描写
    pushMatrix();
    translate(x, y-45, z);
    pillar(28, 6, 4);
    translate(0, 13, 0);
    sphere(4);
    popMatrix();
    popMatrix();

    // 下半身
    pushMatrix();
    translate(0, 50, 0);
    pushMatrix();
    translate(x, y-40, z);
    pillar(15, 4, 6);
    popMatrix();

    //右脚の描写
    pushMatrix();
    rotateY(-PI/8);// ---------------
    translate(x-9, y-25, z);
    rotateZ(PI/6);
    pillar(25, 3, 2);
    popMatrix();
    pushMatrix();
    rotateY(-PI/8);// ---------------
    translate(-9-5*pow(3, 1/2), -17);
    fill(0);
    sphere(4);
    fill(p);
    translate(0, 10, 0);
    pillar(15, 3, 2);
    popMatrix();

    //左脚の描写
    pushMatrix();
    rotateY(-PI/8);// ---------------
    translate(x+6, y-24, z);
    rotateZ(-PI/8);
    pillar(20, 3, 2);
    popMatrix();
    pushMatrix();
    rotateY(-PI/8);// ---------------
    translate(8+5*sin(PI/8), -13);
    fill(0);
    sphere(4);
    translate(3, 5, -2);
    rotateZ(-PI/6.5);
    rotateX(-PI/10);// ---------------
    fill(p);
    pillar(18, 3, 2);
    popMatrix();

    //ボードの描写
    fill(b);
    pushMatrix();
    translate(x, y, z);
    box(90, 2, 20);
    popMatrix();
    popMatrix();
  }
}

