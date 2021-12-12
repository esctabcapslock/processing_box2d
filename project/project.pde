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

Box2DProcessing box2d;
Game game;
int toc = 0;

void setup() {
  print(this, this);
  size(800, 800);
  box2d = new Box2DProcessing(this);
  game = new Game();
}

void draw() {
  toc++;
  background(255);
  if(!game.started){
    game.drawstartpage();
  }else
    game.gamedraw();
  
}

void keyPressed() {
  game.gamekeyPressed();
}
void keyReleased() {
  game.gamekeyReleased();
}

void beginContact(Contact cp) {
 game.gamebeginendContact(cp, true);
}

void endContact(Contact cp) {
  game.gamebeginendContact(cp, false);
}

void mouseClicked(){
   game.gamesetup();
}
