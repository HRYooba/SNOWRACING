/*
2620140538 Yamasawa Soichiro 山澤総一郎
 Arduino class
 arduinoから受け取った値によってtrueかfalseを判定するクラス
 */

//
class Arduino {
  Arduino() {
    init();
  }

  void init() {
  }

  //trueかfalseの判定
  boolean pressure() {
    boolean a;
    if ( input < 150 ) {
      a = true;
    } else {
      a = false;
    }
    return a;
  }
}

