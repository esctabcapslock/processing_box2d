class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  float r;
  float friction = 0.2;
  boolean jumpable = false;
  int brith;
  int life = 10*60; //삶은 10초

  Particle(float x, float y, float r_) {
    r = r_;
    makeBody(x, y, r);
  }

  Particle(float x, float y, float r_, Vec2 v) {
    brith = toc;
    r = r_;
    // This function puts the particle in the Box2d world
    makeBody(x, y, r, v);
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    //print(toc,life, brith,life+brith < toc,"life\n");
    if (pos.y > height*2+r*2 || life+brith < toc) {
      killBody();
      //makeBody(pos.x, height-150, r);
      return true;
    }
    return false;
  }

  Vec2 getpos() {
    return box2d.getBodyPixelCoord(body);
  }

  //
  void display(int x, int y) {
    if (jumpable) display(x, y, 255, 0, 0);
    else display(x, y, 127, 127, 127);
  }
  void display(int x, int y, int R, int G, int B) {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();
    pushMatrix();
    translate(pos.x-x, pos.y-y);
    rotate(-a);
    fill(R, G, B);
    stroke(0);
    strokeWeight(2);
    ellipse(0, 0, r*2, r*2);
    // Let's add a line so we can see the rotation
    line(0, 0, r, 0);
    popMatrix();
  }

  // Here's our function that adds the particle to the Box2D world

  void makeBody(float x, float y, float r) {
    makeBody(x, y, r, new Vec2(0, 0));
  }
  void makeBody(float x, float y, float r, Vec2 velocity) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);

    bd.bullet = true;//object may move very quickly and to check its collisions more carefully

    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);
    body.setUserData(this);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = friction;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(velocity);
    body.setAngularVelocity(0);
    //    body.setLinearVelocity(new Vec2(random(-10f,10f),random(5f,10f)));
    //body.setAngularVelocity(random(-10,10));
  }

  void jump() {
    if (!jumpable) return;
    Vec2 force = new Vec2(0, 2000);
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }
}
