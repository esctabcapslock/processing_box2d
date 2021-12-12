class Landpart {
  int partlnth = width;
  Body body;
  int amplitude = 250;
  int bias = height-250;
  int thiscolor;
  float frequency = 0.003;
  int ind;
  Vec2[] vertices;
  Vec2[] vertices_conv;

  Landpart(int seed, int _ind) {
    //print(seed, _ind, "Landpart \n");
    noiseSeed(seed);
    randomSeed(seed+_ind);
    thiscolor = (int) (100*noise(_ind));
    ind = _ind;
    //print("vertices_conv.length",vertices_conv,"\n");
    makebody();
  }
  
  void updateland(int[] digglist, int top){
      //그린다.
      
      for (var i=0; i<partlnth; i++) {
        int x = ind*partlnth+i;
        vertices[i] = new Vec2(x, mynoise(x));
        if(0<= i+top && i+top < digglist.length) vertices[i].y += digglist[i+top]; //땅을 판 만큼 더한다.
        vertices_conv[i] = box2d.coordPixelsToWorld(vertices[i]);
      }
      
      box2d.destroyBody(body);
      makebody();
    
  }
  
  
  void makebody(){
    ChainShape chain = new ChainShape();
    if(vertices_conv == null){
          vertices = new Vec2[partlnth];
          vertices_conv = new Vec2[partlnth];
          for (var i=0; i<partlnth; i++) {
            int x = ind*partlnth+i;
            vertices[i] = new Vec2(x, mynoise(x));
            vertices_conv[i] = box2d.coordPixelsToWorld(vertices[i]);
          }
    }


    chain.createChain(vertices_conv, vertices_conv.length);

    BodyDef bd = new BodyDef();
    //print(bd.type,BodyType.STATIC,BodyType.DYNAMIC,"\n");
    bd.type = BodyType.STATIC; //원래 STATIC이라 설정할 필요 없긴 함


    //chain.
    FixtureDef fd = new FixtureDef();
    fd.shape = chain;
    fd.friction = 10;
    fd.restitution = 0.1;


    body = box2d.world.createBody(bd);
    body.createFixture(fd);
    body.setUserData(this);
  }

  void killBody() {
    box2d.destroyBody(body);
  }

  float mynoise(int x) {
    return noise(frequency*x)*amplitude + bias;
  }

  void display(int x, int y) {
    //print("landpart:", x, ind, partlnth, x-ind*partlnth, "\n");
    int sc_x = x-ind*partlnth;
    //절대좌표 x로 변환. 본 틀에 대한 검색 시작 위치.

    if (sc_x > partlnth || sc_x<-partlnth) return;


    strokeWeight(1);
    stroke(0);
    fill(thiscolor);
    beginShape();
    //vertex(0, height);

    //900 -> 800
    //690 -> 0 ~ 800-602
    //-102 -> 102

    int start, end;

    if (sc_x>0) {
      start = 0;
      end = partlnth-sc_x;
    } else {
      start = -sc_x;
      end = partlnth;
    }

    for (int i=start; i<end; i++) {

      vertex(i, vertices[i+sc_x].y-y);
      //print(i, (int)mynoise(i-x), "\n");
    }

    vertex(end, height*10);
    vertex(start, height*10);

    endShape(CLOSE);
  }
}



class Land {
  int seed;
  int partlnth = width;
  LinkedList<Landpart> Landparts;
  int topindex = 0;

  //지형 수정 정보가 저장됨!
  int[] diggedlist;
  int digged_top;
  Game game;

  Land(Game _game, int _seed) {
    //print("_fe\n");
    game = _game;
    seed = _seed;
    noiseSeed(seed);
    randomSeed(seed);
    Landparts = new LinkedList<Landpart>();
    diggedlist = new int[0];
    Landparts.add(new Landpart(seed, 0));
  }


  void apply(int x) {
    //print("apply\n");
    int start = (int) x/partlnth - 5;
    int end = (int) x/partlnth + 5;

    int c_end = topindex+Landparts.size();

    if (topindex > start) {
      for (int i=topindex-1; i>=start; i--) {
        Landpart L = new Landpart(seed, i);
        //print(L, "\n");
        Landparts.addFirst(L);
      }
      topindex = start;
    } else if (topindex < start) {
      for (int i=topindex; i<start; i++) {
        //print("else if(i<start){");
        //Landpart landpart = Landparts.removeFirst();
        //landpart.killBody();
      }
    }
    


    if (end > c_end) {
      for (int i=c_end; i<end; i++) Landparts.addLast(new Landpart(seed, i));
    } else if (end < c_end) {
      //for (int i=end; i<c_end; i++) Landparts.removeLast();
    }


    //    for (var i=min(start, topindex); i<end; i++) {
    //      if (i < topindex) {
    //        print("(i < topindex) \n");
    //        Landpart L = new Landpart(seed, i);
    //        print(L, "\n");
    //        Landparts.addFirst(L);
    //      } else if (i<start) {
    //        print("else if(i<start){");
    //        Landpart landpart = Landparts.removeFirst();
    //        landpart.killBody();
    //      } else if (i>= end) {
    //        print("(i>= end");
    //        Landpart landpart = Landparts.removeLast();
    //        landpart.killBody();
    //      } else if (i>= topindex+Landparts.size() && i < end) {
    //        print("(i>= end");
    //        Landparts.addLast(new Landpart(seed, i));
    //      }
    //    }
    //    topindex = start;
  }

  void display(int x, int y) {
    int xx = x/partlnth - topindex;
    //print("int xx:", xx, topindex, x/partlnth, "\n");
    if (xx - 1 >= 0) Landparts.get(xx - 1).display(x, y);
    Landparts.get(xx).display(x,y);
    if (xx+1 <  Landparts.size()) Landparts.get(xx+1).display(x, y);
    //x: 주어지는 그릴 위치임
    // x//width*width부터 2개를 그려야 하는데?? 대퉁 여러개를 그려야 할 것?
  }

  int dig(int x, int[] arr) {//여기서 x는 픽셀 기준  좌표인듯 하다.
  
    int sum = 0;
    for(int i:arr) sum+=i;
    if(sum<0 && game.soil + sum < 0) return 0;

    //print("\ndig, x:",x,"\narr: ");
    //for(int i:arr) print(i,", ");
    //print("\ndiggedlist: ");
    //for(int i:diggedlist) print(i,", ");
    //print("\ndigged_top:",digged_top,"\n");
    //print("\n");
    int xend = x + arr.length;
    int digend = digged_top + diggedlist.length;

    if (diggedlist.length==0) {
      digged_top = x;
      diggedlist = arr;
    } else {
      
      //배열을 확장한다.
      if (x<digged_top) {
        
          int[] pre = new int[digged_top-x];
          //print("IntList pre = new IntList(digged_top-x);",digged_top-x,pre,pre.length,"\n");
          for(int i=0; i<digged_top-x; i++) pre[i]=0;
          //print("diggedlist",diggedlist.getClass(), "1235\n");
          diggedlist = (int[]) concat(pre, diggedlist);
          digged_top = x;
      }if(xend>digend){
        int[] nextarr = new int[xend - digend];
        for(int i=0; i<xend-digend; i++) nextarr[i]=0;
        //print("nextarr", nextarr,"\n");
        //print("diggedlist",diggedlist,"\n");
       
        diggedlist = (int[]) concat(diggedlist, nextarr);
      }
      //값을 더한다.
      for(int i=0; i<arr.length; i++) diggedlist[i+x-digged_top] +=  arr[i];
    }
    
    
    int xx = x/partlnth - topindex - 1;
    if(xx<0) xx=0;
    
    int _min = 0, _max = Landparts.size();
    for(int i=(int)(x/partlnth) - 1 - topindex; i <= (int)((x+arr.length)/partlnth) - topindex; i++){
        if (i >= _min && i < _max) {
        //print("land>dig update",i,topindex+i,digged_top, digged_top - (i+topindex)*partlnth,"\n");
        Landparts.get(i).updateland(diggedlist, (i+topindex)*partlnth - digged_top);
      }
        //번호...
    }
    return sum;
  }
  int round(int x, int lnth){
    
      int sum = 0;
      return sum;
  }
}
