
class Car {
  // Our object is one box and two wheels
  Box box;
  Wheel wheel1;
  Wheel wheel2;
  RevoluteJointDef rjd1, rjd2;
  RevoluteJoint joint1, joint2;
  
  float wheelspeed = 0;
  
  Car(float x, float y) {
    makebody(x,y);
  }
  
  void reset(){
    Vec2 pos =  box.getpos();
    
    box.killBody();
    wheel1.killBody();
    wheel2.killBody();
    makebody(pos.x, height-300);
  }

  void makebody(float x, float y) {
    // Initialize position of the box
    box = new Box(x, y, 20, 4, false);
    // Initialize position of two wheels
    wheel1 = new Wheel(x-10, y, 8);
    wheel2 = new Wheel(x+10, y, 8);

    // Define joints
    rjd1 = new RevoluteJointDef();
    rjd1.initialize(box.body, wheel1.body, wheel1.body.getWorldCenter());
    rjd1.motorSpeed = wheelspeed;//-PI*20;
    rjd1.maxMotorTorque = 100000;//300.0;
    rjd1.enableMotor = true;
    box2d.world.createJoint(rjd1);
    joint1 = (RevoluteJoint) box2d.world.createJoint(rjd1);

    rjd2 = new RevoluteJointDef();
    rjd2.initialize(box.body, wheel2.body, wheel2.body.getWorldCenter());
    rjd2.motorSpeed = wheelspeed;// -PI*20;
    rjd2.maxMotorTorque = 100000;//300.0;
    rjd2.enableMotor = true;
    //box2d.world.createJoint(rjd2);
    joint2 = (RevoluteJoint) box2d.world.createJoint(rjd2);
  }

  void setSpeed(float v, float t){
    //print("Setspeed",v,t,"\n");
    wheelspeed = v;
    joint1.setMotorSpeed(v);
    joint2.setMotorSpeed(v);
  }
  void onMotor(){
    joint1.enableMotor(true);
    joint2.enableMotor(true);
  }
  void offMotor(){
    joint1.enableMotor(false);
    joint2.enableMotor(false);
  }
  
  void display(int x, int y) {
    box.display(x,y);
    if(wheelspeed>0){
      wheel1.display(x,y,100,220,100);
      wheel2.display(x,y,100,220,100);
    }else if(wheelspeed<0){
      wheel1.display(x,y,100,100,220);
      wheel2.display(x,y,100,100,220);
    }
    else{
      wheel1.display(x,y);
      wheel2.display(x,y);
      
    }
    
  }
  boolean jump(float x){
    if(!wheel1.jumpable && !wheel2.jumpable) return false;
      PVector force = new PVector(x,1);
      force.setMag(5000);
      
      Vec2 force_v = new Vec2(force.x, force.y);
        Vec2 pos1 = wheel1.body.getWorldCenter();
        Vec2 pos2 = wheel2.body.getWorldCenter();
      wheel1.body.applyForce(force_v, pos1);
      wheel2.body.applyForce(force_v, pos2);
      return true;
  }
  
  
}
