// 1-4-21 Asako Kumon
// Crystal class
// 雪の結晶を降らせるクラス
// 参考：gist.github.com  "A kind of snow crystal"

class Crystal {
  float posX;       // 結晶のx座標
  float posY;       // 結晶のy座標
  float speedY;     // y方向のスピード
  Crystal() {
    init();
  }

  void init() {
    posX=random(width);
    posY=random(-70, height-70);
    speedY=random(0.3, 1.3);
  }

  // 中心(x,y),半径rの六角形を描く
  void hexagon(float x, float y, float r) {
    pushMatrix();
    translate(x, y);
    beginShape();
    // 頂点を結ぶ
    for (int i = 0; i < 6; i++) {
      vertex(r*cos(radians(60*i)), 
      r*sin(radians(60*i)));
    }
    endShape(CLOSE);
    popMatrix();
  }

  // 中心(posX,posY)の雪の結晶を表示する
  void display(float r) {   // rで六角形の半径変える
    stroke(102, 240, 255);
    strokeWeight(2);
    fill(180, 250, 255);
    pushMatrix();
    translate(posX, posY);
    scale(0.1);
    // 内側の六角形
    hexagon(0, 0, 0.5*r);
    
    // 外側の六角形
    for (int i = 0; i < 6; i++) {
      hexagon(0.75*r*cos(radians(60*i)), 0.75*r*sin(radians(60*i)), 0.25*r);
    }
    popMatrix();
  }

  void move() {
    posY=posY+speedY;   // speedYずつ下に動く
    if (posY>=height+10) {
      posY = 0;    // 上に戻る
    }
  }
}

