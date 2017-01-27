/*　2620140562 kawasoe kotaro 川添　浩太郎
 　コースを描写するクラス
 
 */


class Course extends Player 
{





  PImage ground; // 地面のテクスチャ
  PImage side; // 横のテクスチャ
  int exam; // あたり判定がどのエリアかを示す変数
  float sent_examX; // 判定したらどの場所にするか教えるための変数(x軸)
  float sent_examY;//判定したらどの場所に関するか教えるための変数(y軸)
  float sent_examZ; // 判定したらどの場所にするか教えるための変数(z軸)
  int Switch;//ゴールを判定する区間に存在かどうか確認するための変数
  int Switch2;//ゴール判定する区間に存在するか確認するための２つ目の変数
  int lap;//周回数をカウントするための変数






  Course() 
  {
    this.init();
  }





  void init() 
  {
    super.init();
    ground = loadImage("ground.png");
    side = loadImage("side.png");
    exam = 0;
    sent_examX = 0;
    sent_examZ = 0;
  }




  // Z軸に対して平行な直線のコース描写(x, y, z, 直線の長さ, コースの幅)
  void base_ground_horizontal(float x, float y, float z, int n, float wid) 
  {


    pushMatrix();

    translate(width/2, height/2, 0);
    translate(x, y, z);



    // 下側の外堀
    fill(255);
    noStroke();
    beginShape(QUAD_STRIP);
    texture(side);
    for (int i=-n/2; i<=n/2; i+=n) {
      vertex(-250*sqrt(3), -200, i, (i+n/2)/n*300, 0);
      vertex(0, 50, i, (i+n/2)/n*300, 300);
    }
    endShape();



    // 道路
    fill(255);
    noStroke();
    beginShape(QUAD_STRIP);
    texture(ground);
    for (int i=-n/2; i<=n/2; i+=n) {
      vertex(0, 50, i, 0, (i+n/2)/n*300);
      vertex(wid, 50, i, 300, (i+n/2)/n*300);
    }
    endShape();



    // 上側の外堀
    fill(255);
    beginShape(QUAD_STRIP);
    texture(side);
    for (int i=-n/2; i<=n/2; i+=n) {
      vertex(wid, 50, i, (i+n/2)/n*300, 0);
      vertex((wid+250*sqrt(3)), -200, i, (i+n/2)/n*300, 300);
    }
    endShape();


    popMatrix();




    // あたり判定

    float exam_distX = dist(wid/2+x, posZ, posX, posZ); // playerとこの直線の中心との距離（z軸を固定して）
    float exam_distZ = dist(posX, z, posX, posZ); // playerとこの直線の中心との距離（x軸を固定して）


    // もし道路内にいるなら

    if (exam_distX >= 0
      && exam_distX <= wid/2
      && exam_distZ <= n/2)
    {
      exam = 0;
      sent_examX = 0;
    }

    // もし道路外に行ってしまったら

    else if (exam_distX >= wid/2
      && exam_distX <= wid/2+300
      && exam_distZ <= n/2) 
    {

      // 上側の処理

      if (posX >= wid+x)
      {
        exam = 1;
        sent_examX = wid+x;
      }

      // 下側の処理

      if (posX <= x)
      {
        exam = 2;
        sent_examX = x;
      }
    }
  }




  //X軸に対して平行な直線のコース描写(x, y, z, 直線の長さ, コースの幅)
  void base_ground_vertical(float x, float y, float z, int n, float wid) 
  {
    pushMatrix();


    translate(width/2, height/2, 0);
    translate(x, y, z);



    // 下側の外堀

    fill(255);
    noStroke();
    beginShape(QUAD_STRIP);
    texture(side);
    for (int i=-n/2; i<=n/2; i+=n) {
      vertex(i, -200, -250*sqrt(3), 0, (i+n/2)/n*300);
      vertex(i, 50, 0, 300, (i+n/2)/n*300);
    }
    endShape();


    // 道路

    fill(255);
    noStroke();
    beginShape(QUAD_STRIP);
    texture(ground);
    for (int i=-n/2; i<=n/2; i+=n) {
      vertex(i, 50, 0, 0, (i+n/2)/n*300);
      vertex(i, 50, wid, 300, (i+n/2)/n*300);
    }
    endShape();


    // 上側の外堀


    fill(255);
    beginShape(QUAD_STRIP);
    texture(side);
    for (int i=-n/2; i<=n/2; i+=n) {
      vertex(i, 50, wid, 0, (i+n/2)/n*300);
      vertex(i, -200, (wid+250*sqrt(3)));
    }
    endShape();


    popMatrix();


    // あたり判定


    float exam_distX = dist(x, posZ, posX, posZ); // playerとこの直線の中心との距離（z軸を固定して）
    float exam_distZ = dist(posX, wid/2+z, posX, posZ); // playerとこの直線の中心との距離（x軸を固定して）


    // もし道路内にいるなら

    if (exam_distZ >= 0
      && exam_distZ <= wid/2
      && exam_distX <= n/2)
    {
      exam = 0;
      sent_examZ = 0;
    }


    // もし道路外に行ってしまったら

    else if (exam_distZ >= wid/2
      && exam_distZ <= wid/2+300
      && exam_distX <= n/2) 
    {
      // 上側の処理
      if (posZ >= wid+z)
      {
        exam = 5;
        sent_examZ = wid+z;
      }
      // 下側の処理
      if (posZ <= z)
      {
        exam = 6;
        sent_examZ = z;
      }
    }
  }


  // カーブの描画(x, y, z, 始まりの角度[-180~180], 終わりの角度[-180~180], どの程度の細かさか, コースの幅, 半径)
  void turn_ground(float x, float y, float z, int fn, int en, int n, float wid, float r) 
  {

    pushMatrix();


    translate(width/2, height/2, 0);
    translate(x, y, z);


    // 内側の外堀
    fill(255);
    noStroke();
    beginShape(QUAD_STRIP);
    texture(side);
    for (int i=fn; i<=en; i+=n) {
      vertex((r-250*sqrt(3))*cos(radians(i)), -200, (r-250*sqrt(3))*sin(radians(i)), 0, 150+150*cos(radians(i*3)));
      vertex(r*cos(radians(i)), 50, r*sin(radians(i)), 300, 150+150*cos(radians(i*3)));
    }
    endShape();


    // 道路
    fill(255);
    noStroke();
    beginShape(QUAD_STRIP);
    texture(ground);
    for (int i=fn; i<=en; i+=n) {
      vertex(r*cos(radians(i)), 50, r*sin(radians(i)), 0, 150+150*cos(radians(i*3)));
      vertex((r+wid)*cos(radians(i)), 50, (r+wid)*sin(radians(i)), 300, 150+150*cos(radians(i*3)));
    }
    endShape();


    // 外側の外堀
    fill(255);
    beginShape(QUAD_STRIP);
    texture(side);
    for (int i=fn; i<=en; i+=n) {
      vertex((r+wid)*cos(radians(i)), 50, (r+wid)*sin(radians(i)), 0, 150+150*cos(radians(i*3)));
      vertex(((r+wid)+250*sqrt(3))*cos(radians(i)), -200, ((r+wid)+250*sqrt(3))*sin(radians(i)), 300, 150+150*cos(radians(i*3)));
    }
    endShape();



    // あたり判定
    float exam_angle = atan2(posZ-z, posX-x)/PI*180; // playerとこのカーブの中心との角度
    float exam_dist = dist(x, z, posX, posZ); // playerとこのカーブの中心との距離


    // もし道路内にいるなら


    if (exam_angle >= fn
      && exam_angle <= en
      && exam_dist >= r
      && exam_dist <= (r+wid))
    {
      exam = 0;
      sent_examX = 0;
      sent_examZ = 0;
    }
    // もし内側に行ってしまったら 
    else if (exam_angle >= fn
      && exam_angle <= en
      && exam_dist <= r
      && exam_dist >= r-100)
    {
      exam = 3;
      sent_examX = (r+1)*cos(radians(exam_angle))+x;
      sent_examZ = (r+1)*sin(radians(exam_angle))+z;
    }
    // もし外側に行ってしまったら 
    else if (exam_angle >= fn
      && exam_angle <= en
      && exam_dist >= (r+wid)
      && exam_dist <= (r+wid)+100)
    {
      exam = 4;
      sent_examX = (r+wid-1)*cos(radians(exam_angle))+x;
      sent_examZ = (r+wid-1)*sin(radians(exam_angle))+z;
    }
    popMatrix();
  }






  // 木を描く関数
  void tree(float x, float y, float z) 
  {
    pushMatrix();
    translate(width/2, height/2+30, 0);
    translate(x, y, z);
    rotateY(radians(0));
    noStroke();
    fill(155, 111, 60);
    rect(-20, -80, 40, 100);
    fill(103, 177, 107);
    triangle(-80, -80, 0, -150, +80, -80);
    triangle(-60, -120, 0, -190, +60, -120);
    triangle(-40, -160, 0, -230, +40, -160);
    rotateY(radians(90));
    fill(155, 111, 60);
    rect(-20, -80, 40, 100);
    fill(103, 177, 107);
    triangle(-80, -80, 0, -150, +80, -80);
    triangle(-60, -120, 0, -190, +60, -120);
    triangle(-40, -160, 0, -230, +40, -160);
    popMatrix();

    // あたり判定
    float exam_angle = atan2(posZ-z, posX-x)/PI*180; // playerと木の中心との角度
    float exam_dist = dist(x, z, posX, posZ); // 木との距離
    if (exam_dist < 50)
    {
      exam = 7;
      sent_examX = x+51*cos(radians(exam_angle));
      sent_examZ = z+51*sin(radians(exam_angle));
    }
  }

  //白い木を描写する関数
  void tree_white(float x, float y, float z) 
  {
    pushMatrix();
    translate(width/2, height/2+30, 0);
    translate(x, y, z);
    rotateY(radians(0));
    noStroke();
    fill(155, 111, 60);
    rect(-20, -80, 40, 100);
    fill(230);
    triangle(-80, -80, 0, -150, +80, -80);
    triangle(-60, -120, 0, -190, +60, -120);
    triangle(-40, -160, 0, -230, +40, -160);
    rotateY(radians(90));
    fill(155, 111, 60);
    rect(-20, -80, 40, 100);
    fill(230);
    triangle(-80, -80, 0, -150, +80, -80);
    triangle(-60, -120, 0, -190, +60, -120);
    triangle(-40, -160, 0, -230, +40, -160);
    popMatrix();

    // あたり判定
    float exam_angle = atan2(posZ-z, posX-x)/PI*180; // playerと木の中心との角度
    float exam_dist = dist(x, z, posX, posZ); // 木との距離
    if (exam_dist < 50)
    {
      exam = 7;
      sent_examX = x+51*cos(radians(exam_angle));
      sent_examZ = z+51*sin(radians(exam_angle));
    }
  }

  //ゴール判定(x, y, z, 判定する直線の長さ, 判定する幅,ゴールの直線の長さ,ゴールのライン描写の幅,ゴールするまでの周回数)
  void goalJadgment(float x, float y, float z, int n, float wid, int k, float wid2, int goal)
  {
    pushMatrix();


    translate(width/2, height/2, 0);
    translate(x, y-1, z);

    //ゴールのライン描写（Z軸に対し水平）
    fill(255, 0, 0);
    noStroke();
    beginShape(QUAD_STRIP);
    for (int i=-k/2; i<=k/2; i+=k) {
      vertex(0, 50, i, 0, (i+k/2)/k*300);
      vertex(wid2, 50, i, 300, (i+k/2)/k*300);
    }
    endShape();
    popMatrix();



    float exam_distX = dist(wid/2+x, posZ, posX, posZ); // playerとこの直線の中心との距離（z軸を固定して）
    float exam_distZ = dist(posX, z-n/2, posX, posZ); // playerとこの直線の中心との距離（x軸を固定して）

    //ゴールの判定　Switchを二つ使いそれぞれに存在位置を確認し、判定する

    //コースを正常に回って来たことの確認
    if (exam_distX <= wid/2
      &&exam_distX >= 0
      && exam_distZ > n/2
      && posZ < z
      &&  Switch2 == 2
      ) {
      Switch2 = -1;
    }
    //コースを逆走したときに判定を停止する
    if ( exam_distX <= wid/2
      &&exam_distX >= 0
      && exam_distZ > n/2
      && posZ < z
      && Switch2 != -1)
    {
      Switch = -1;
    }


    //正常にコースを回ってきたことをゴール判定圏内で確認
    if (exam_distX >= 0
      && exam_distX <= wid/2
      && exam_distZ <= n/2
      && Switch != -1
      && Switch2 == -1
      )
    {

      Switch = 1;
    }

    //コースの正常に回ってきたことをもう一度確認
    if (exam_distX >= 0
      && exam_distX <= wid/2
      && exam_distZ <= n/2
      )
    {
      Switch2 = 1;
    }


    //ゴールを通ったことを判定

    if (Switch == 1
      && exam_distX >= 0
      && exam_distX <= wid/2
      && exam_distZ > n/2
      && posZ > z
      && Switch2 == 1)
    {
      lap++;
      Switch = 0;
      Switch2 = 2;
    } 

    //ゴールを正常に通らなかった場合のそれぞれの変数のリセット


    if (
    Switch != 1
      && exam_distX >= 0
      && exam_distX <= wid/2
      && exam_distZ > n/2
      && posZ > z)
    {
      Switch = 0;
      Switch2 =2;
    }

    //ゴールを指定したラップ数通った時に、ゴールは判定

    if ( lap == goal) {
      GoalFlag[playerNumber] = true;
    }
  }





  void test_course() 
  {
    //コースを描写 
    this.turn_ground(0, 0, 6000, 0, 90, 1, 1500, 1000);
    this.base_ground_horizontal(1000, 0, 0, 12000, 1500);
    this.base_ground_vertical(-4000, 0, 7000, 8000, 1500);
    this.turn_ground(0, 0, -6000, -90, 0, 1, 1500, 1000);
    this.turn_ground(-8000, 0, 5500, 90, 180, 1, 1500, 1500);
    this.turn_ground(-12500, 0, 5500, -90, 0, 1, 1500, 1500);
    this.base_ground_vertical(-17500, 0, 2500, 10000, 1500);
    this.turn_ground(-22500, 0, 2000, 90, 180, 1, 1500, 500);
    this.turn_ground(-22500, 0, 2000, -180, -90, 1, 1500, 500);
    this.base_ground_vertical(-21250, 0, 0, 2500, 1500);
    this.turn_ground(-20000, 0, -500, 0, 90, 1, 1500, 500);
    this.base_ground_horizontal(-19500, 0, -3250, 5500, 1500);
    this.turn_ground(-17000, 0, -6000, -180, -90, 1, 1500, 1000);
    this.base_ground_vertical(-8500, 0, -8500, 17000, 1500);
    this.goalJadgment(1000, 0, 0, 1000, 1500, 20, 1500, 1);


    //コース上に木を生成

    for (int i = 0; i<30; i++) {
      randomSeed(i*80+i);
      this.tree_white(-8500-800*random(-10, 11), 0, -7700-55*random(-10, 11));
      this.tree_white(-8000-800*random(-10, 11), 0, -7700-50*random(-10, 11));
      this.tree_white(-8000-800*random(-10, 11), 0, -7700-70*random(-10, 11));
      this.tree_white(-8000-700*random(-10, 11), 0, -7700-65*random(-10, 11));
      this.tree_white(-8000-800*random(-10, 11), 0, -7700-60*random(-10, 11));
    }
    for (int i = 0; i<15; i++) {
      this.tree(1000, 0, 400*i);
      this.tree(2500, 0, 400*i);
    }
    for (int i = 0; i<7; i++) {
      this.tree(1000*cos(radians(i*15)), 0, 6000+1000*sin(radians(i*15)));
    }
    for (int i = 0; i<10; i++) {
      this.tree((1500+1000)*cos(radians(i*10)), 0, 6000+(1500+1000)*sin(radians(i*10)));
    }
    for (int i =0; i<20; i++) {
      this.tree(-8000+i*400, 0, 7000);
      this.tree(-8000+i*400, 0, 8500);
    }
    for (int i = 0; i<10; i++) {
      this.tree(-8000+(1500+1500)*cos(radians(90+i*10)), 0, 5500+(1500+1500)*sin(radians(90+i*10)));
      this.tree(-8000+(1500)*cos(radians(90+i*10)), 0, 5500+(1500)*sin(radians(90+i*10)));
    }
    for (int i = 0; i<7; i++) {

      this.tree(-12500+(1500)*cos(radians(-i*15)), 0, 5500+(1500)*sin(radians(-i*15)));
    }
    for (int i = 0; i<14; i++) {
      this.tree(-12500+(1500+1500)*cos(radians(-i*7)), 0, 5500+(1500+1500)*sin(radians(-i*7)));
    }
    for (int i = 0; i<30; i++) {
      randomSeed(i*970);
      this.tree(-15500-400*random(-10, 11), 0, 3250-60*random(-10, 11));
    }
    for (int i = 0; i<15; i++) {
      this.tree(1000, 0, -6000+400*i);
      this.tree(2500, 0, -6000+400*i);
    } 
    for (int i = 0; i<15; i++) {
      this.tree_white(-18000, 0, -500-i*400);
      this.tree_white(-19500, 0, -500-i*400);
    }
  }
}

