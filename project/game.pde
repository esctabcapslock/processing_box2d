import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;
import java.util.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import processing.sound.*; //sound library

//게임 진행과 관련된 함수들을 저장.
//전역적으로 저장되는 것들 + main 깨끗하게 만들기 위함.
class Game {
  int soil = 1000;
  mySound pongsound;
  mySound digsound;
  mySound whooshsound;
  Land land;
  Car car;
  Bucket bucket;
  boolean started = false;
  ArrayList<Particle> particles;
  ArrayList<Bucket> buckets;
  PFont namsan;

  //화면에 표시되는 자동차의 위치. (픽셀)
  Vec2 carpos;


  Game() {
    started = false;
    namsan = loadFont("data/SeoulNamsanEB-20.vlw");
    textFont(namsan, 20);
  }

  void gamesetup() {
    if (started) return;
    started = true;
    
    box2d.createWorld();
    box2d.listenForCollisions();
    
    // We are setting a custom gravity
    box2d.setGravity(-10, -100);


    pongsound = new mySound("data/pong.mp3");
    digsound = new mySound("data/dig.mp3");
    whooshsound = new  mySound("data/whoosh.mp3");


    land = new Land(game, 0);
    car = new Car(width/2, height-150);

    particles = new ArrayList<Particle>();
    buckets = new ArrayList<Bucket>();
    for (int i=0; i<1; i++) {
      particles.add(new Particle(width/2+10*i, height-150, 3));
    }
    for (int i=0; i<1; i++) {
      particles.add(new Particle(width/2-10*i, height-150, 3));
    }

    bucket = new Bucket(width/2, height-150);
  }

  void gamedraw() {
    if (!started) return;
    box2d.step();
    Vec2 pos =car.box.getpos();
    int x = (int)pos.x - width/2;
    int y = (int)pos.y - height*2/3;

    game.carpos = new Vec2(width/2, height*2/3);
    //print("pos:",x,"\n");
    // x=0;
    land.apply(x);


    land.display(x, y);
    //Particle p:particles
    for (int i=particles.size()-1; i>=0; i--) {
      Particle p = particles.get(i);
      boolean dn = p.done();
      if (dn) {
        particles.remove(i);
      } else {
        p.display(x, y);
      }
    }

    for (int i=buckets.size()-1; i>=0; i--) {
      Bucket b = buckets.get(i);
      boolean dn = b.done();
      if (dn) {
        buckets.remove(i);
      } else {
        b.display(x, y);
      }
    }
    bucket.display(x, y);
    car.display(x, y);

    game.display();
  }

  void gamekeyPressed() {
    if (!started) return;

    if (keyCode==32) {
      boolean done = car.jump(game.mouseheading().x);
      if (done) whooshsound.play();
      //for(Particle p:particles){
      //  p.jump();
      //}
    } else if (key==CODED) {
      if (keyCode == LEFT) {
        car.setSpeed(30, -300);
      } else if (keyCode == RIGHT) {
        car.setSpeed(-30, 300);
      } else if (keyCode == UP) {
        car.onMotor();
      } else if (keyCode == DOWN) {
        car.offMotor();
      }
    } else if (keyCode==68) {//d
      digsound.play();
      int[] arr = {1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1};
      //1*3 2*7 3*15
      Vec2 pos =car.box.getpos();

      //print((int)game.mouseheading().x*50);
      int x = (int)pos.x - 30 + (int)(50*game.mouseheading().x);
      //x = (int)box2d.vectorPixelsToWorld((float)x,0.0).x; //box2d 좌표로 변환.
      game.soil +=  land.dig(x, arr);
    }//
    else if (keyCode==70) {//f
      digsound.play();
      int[] arr = {1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2, 1, 1, 1};
      for (int i=0; i<arr.length; i++) arr[i]*=-1;
      Vec2 pos =car.box.getpos();
      int x = (int)pos.x - 30 + (int)(50*game.mouseheading().x);
      //x = (int)box2d.vectorPixelsToWorld((float)x,0.0).x; //box2d 좌표로 변환.
      game.soil += land.dig(x, arr);
    } else if (keyCode==82) {//r
      car.reset();
    } else if (keyCode==81) {//q
      if (game.soil < 5) return;
      game.soil-=5;
      pongsound.play();
      PVector ln = game.mouseheading();
      ln.setMag(20);
      float rio = 3;
      //print(ln.x, ln.y);
      Vec2 pos = car.box.getpos();
      particles.add(new Particle(pos.x + ln.x, pos.y+ln.y, 3, new Vec2(ln.x*rio, -ln.y*rio)));
    } else if (keyCode==87) {//w
      if (game.soil < 15) return;
      game.soil-=15;
      pongsound.play();
      PVector ln = game.mouseheading();
      ln.setMag(60);
      //print(ln.x, ln.y);
      Vec2 pos = car.box.getpos();
      buckets.add(new Bucket((int)(pos.x + ln.x), (int)(pos.y+ln.y)));
    }
  }

  void gamekeyReleased() {
    if (!started) return;
    if (key==CODED) {
      if (keyCode == LEFT) {
        car.setSpeed(0, 0);
      } else if (keyCode == RIGHT) {
        car.setSpeed(0, 0);
      }
    }
  }

  PVector mouseheading() {
    if (!started) return new PVector(0, 0);
    if (carpos==null) return new PVector(0, 0);
    Vec2 mouse = new Vec2(mouseX, mouseY);
    Vec2 ln = mouse.sub(carpos);
    ln.normalize();
    PVector ln_p = new PVector(ln.x, ln.y);
    return ln_p;  
  }

  void display() {
    if (!started) return;
    textSize(20);
    PVector ln_p = mouseheading();
    pushMatrix();
    translate(carpos.x + ln_p.x*20, carpos.y + ln_p.y*20);
    rotate(ln_p.heading());
    fill(200);
    stroke(0);
    strokeWeight(1);
    triangle(7, 0, 0, 4, 0, -4);
    popMatrix();


    fill(0);
    text("soil", 20, 27);
    rectMode(CORNERS);
    rect(60, 20, 60+soil/100, 20+3);
  }

  void gamebeginendContact(Contact cp, boolean jumpable) {
    if (!started) return;
    
    //print("gamebeginendContact",cp,jumpable,"\n");
    Object o1 =  cp.getFixtureA().getBody().getUserData();
    Object o2 =   cp.getFixtureB().getBody().getUserData();

    if (o1!=null) if (o1.getClass()==Particle.class  || o1.getClass()==Wheel.class) {
      Particle p1 = (Particle) o1;
      p1.jumpable = jumpable;
    }

    if (o1!=null)  if (o2.getClass()==Particle.class  || o2.getClass()==Wheel.class) {
      Particle p2 = (Particle) o2;
      p2.jumpable = jumpable;
    }
  }

  void drawstartpage() {
    textSize(20);
    fill(0);
    //text("abcd efg",10,100);
    textFont(namsan);
    textSize(30);
    text("Sandbox and endless world game", 120, 100);


    textSize(20);
    text("How to use", 120, 200);
    textSize(15);
    fill(100);
    int a=220, b=20, c=120;
    text("space bar: jump", c, a+=b);
    text("Left arrow: Roll to the left", c, a+=b);
    text("Right arrow: Roll to the right", c, a+=b);
    text("Q/q: throw partile (it's lifespan is 10s)", c, a+=b);
    text("W/w: throw bucket", c, a+=b);
    text("D/d: dig the land", c, a+=b);
    text("F/f: fill up the land", c, a+=b);
    text("R/r: respawn the car", c, a+=b);

    textSize(20);
    fill(0);
    text("How to start", 120, 450);
    textSize(15);
    fill(100);
    text("Click the screen", c, 450+30);
    
    textSize(20);
    fill(0);
    text("Developer", 120, 550);
    textSize(15);
    fill(100);
    text("esctabcapslock", c, 550+30);
  }
}
