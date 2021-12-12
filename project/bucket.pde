class Bucket {

  Body body;
  float w;
  float h;
  Vec2[] verticesr;
  Vec2[] verticesl;
  PolygonShape[] polygonShapes;

  Bucket(int x, int y) {
    w = 30;
    h = 30;
    makebody(new Vec2(x, y));
  }
  void makebody(Vec2 center) {
    //if(true) {return;}
    
    polygonShapes = new PolygonShape[3];

    


    PolygonShape sd = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(2.5);
    sd.setAsBox(box2dW, box2dH);

    verticesr = new Vec2[4];
    verticesr[0] = box2d.vectorPixelsToWorld(new Vec2(w/2-5, 0));
    verticesr[1] = box2d.vectorPixelsToWorld(new Vec2(w/2, -h));
    verticesr[2] = box2d.vectorPixelsToWorld(new Vec2(w/2+5, -h));
    verticesr[3] = box2d.vectorPixelsToWorld(new Vec2(w/2, 0));
    PolygonShape psr = new PolygonShape();
    psr.set(verticesr, 4);
    
    verticesl = new Vec2[4];
    verticesl[0] = box2d.vectorPixelsToWorld(new Vec2(-w/2+5, 0));
    verticesl[1] = box2d.vectorPixelsToWorld(new Vec2(-w/2, -h));
    verticesl[2] = box2d.vectorPixelsToWorld(new Vec2(-w/2-5, -h));
    verticesl[3] = box2d.vectorPixelsToWorld(new Vec2(-w/2, 0));
    PolygonShape psl = new PolygonShape();
    psl.set(verticesl, 4);
    
    
    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);



    body.createFixture(sd,1.0);
    body.createFixture(psr, 1.0);
    body.createFixture(psl, 1.0);
    polygonShapes[0]=sd;
    polygonShapes[1]=psr;
    polygonShapes[2]=psl;
    
    body.setUserData(this);

    //= box2d.vectorPixelsToWorld(new Vec2(0,h/2));
    //sd.m_centroid;
  }
  
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    //print(toc,life, brith,life+brith < toc,"life\n");
    if (pos.y > height*10) {
      killBody();
      //makeBody(pos.x, height-150, r);
      return true;
    }
    return false;
  }
  
  void killBody() {
    box2d.destroyBody(body);
  }
  
  void display(int x, int y){
       // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Get its angle of rotation
    float a = body.getAngle();

    //Fixture f = body.getFixtureList();
    //PolygonShape ps = (PolygonShape) f.getShape();
    
    for(PolygonShape ps:polygonShapes){
    
    


    rectMode(CENTER);
    pushMatrix();
    translate(pos.x-x, pos.y-y);
    rotate(-a);
    fill(175);
    stroke(0);
    beginShape();
    //println(vertices.length);
    // For every vertex, convert to pixel vector
    for (int i = 0; i < ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x, v.y);
    }
    endShape(CLOSE);
    popMatrix();
    }
  print();
  }
}
