PImage img;
int tour;
int i, j, w, h;
float r, g, b;
int [][]obst={
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,1},
        {1,1,0,0,1,0,0,1,0,0,0,0,0,0,0,1},
        {1,0,0,0,1,0,0,1,1,3,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1},
        {1,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1},
        {1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
      }; 

Coord coordRed = look4Red();

void setup() {
  size(512, 512);
  img = loadImage("im.png");
  w=img.width;
  h=img.height;
  tour=0;
  loadPixels();
  img.loadPixels();
}

void draw() {
for (int x = 0; x < w; x++ ) {
    for (int y = 0; y < h; y++ ) {

     int loc = x + y*w;
      int stepx=w/16;
      int stepy=h/16;
      i= y/stepy; j=x/stepx;
      int val=obst[i][j];
      switch (val)
      {
        case 0: r= 0; g=0; b=0; break;
        case 1: r= 0; g=0; b=255; break;
        case 2: r= 255; g=0; b=0; break;
        case 3: r= 0; g=255; b=0; break;
        case 4: r= 192; g=192; b=192; break;
        case 5: r= 255; g=255; b=0; break;
      }      
      color c = color(r, g, b);
      pixels[loc]=c;      
    }
  }
  updatePixels(); 
  if(tour==-1)exit();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      if (obst[coordRed.x - 1][coordRed.y] == 1 || obst[coordRed.x - 1][coordRed.y] == 3) {
      } else {
        cleanPath();
        changePos(coordRed, new Coord(coordRed.x - 1, coordRed.y));
        pathfinding(new Bloc(coordRed.x, coordRed.y, null));
      }
    } else if (keyCode == DOWN) {
      if (obst[coordRed.x + 1][coordRed.y] == 1 || obst[coordRed.x + 1][coordRed.y] == 3) {
      } else {
        cleanPath();
        changePos(coordRed, new Coord(coordRed.x + 1, coordRed.y));
        pathfinding(new Bloc(coordRed.x, coordRed.y, null));
      }
    } else if (keyCode == LEFT) {
      if (obst[coordRed.x][coordRed.y - 1] == 1 || obst[coordRed.x][coordRed.y - 1] == 3) {
      } else {
        cleanPath();
        changePos(coordRed, new Coord(coordRed.x, coordRed.y - 1));
        pathfinding(new Bloc(coordRed.x, coordRed.y, null));
      }
    } else if (keyCode == RIGHT) {
      if (obst[coordRed.x][coordRed.y + 1] == 1 || obst[coordRed.x][coordRed.y + 1] == 3) {
      } else {
        cleanPath();
        changePos(coordRed, new Coord(coordRed.x, coordRed.y + 1));
        pathfinding(new Bloc(coordRed.x, coordRed.y, null));
      }
    }
  } else {
    println("Touche incorrecte");
  }
}

class Coord {
    int x;
    int y;

    public Coord (int x, int y) {
        this.x = x;
        this.y = y;
    }

}

class Bloc {
    int x;
    int y;
    Bloc dad;

    public Bloc (int x, int y, Bloc dad) {
        this.x = x;
        this.y = y;
        this.dad = dad;
    }
}

void changePos(Coord cIni, Coord cFin) {
  obst[cIni.x][cIni.y] = 0;
  obst[cFin.x][cFin.y] = 2;
  coordRed = cFin;
}

Coord look4Red () {
  for (int i = 0; i < 16; ++i) {
    for (int j = 0; j < 16; ++j) {
      if (obst[i][j] == 2) {
        return new Coord(i, j);
      }
    }
  }
  return null;
}

void pathfinding(Bloc red) {
  ArrayList<Bloc> stack = new ArrayList<Bloc>();
  ArrayList<Bloc> trash = new ArrayList<Bloc>();
  int pos;
  stack.add(red);
  
  while (obst[stack.get(stack.size() - 1).x][stack.get(stack.size() - 1).y] != 3) {
    pos = stack.size() - 1;
    if (!exist(trash, stack.get(stack.size() - 1))) {
      if (obst[stack.get(pos).x - 1][stack.get(pos).y] != 1) {
        stack.add(new Bloc(stack.get(pos).x - 1, stack.get(pos).y, stack.get(pos)));
      }
      if (obst[stack.get(pos).x + 1][stack.get(pos).y] != 1) {
        stack.add(new Bloc(stack.get(pos).x + 1, stack.get(pos).y, stack.get(pos)));
      }
      if (obst[stack.get(pos).x][stack.get(pos).y - 1] != 1) {
        stack.add(new Bloc(stack.get(pos).x , stack.get(pos).y - 1, stack.get(pos)));
      }
      if (obst[stack.get(pos).x][stack.get(pos).y + 1] != 1) {
        stack.add(new Bloc(stack.get(pos).x , stack.get(pos).y + 1, stack.get(pos)));
      }
      trash.add(stack.remove(pos));
    } else {
      stack.remove(stack.size() - 1);
    }
    
  }

  for (Bloc o : trash) {
    if (o.x != coordRed.x || o.y != coordRed.y) {
      obst[o.x][o.y] = 4;
    }
  }

  Bloc goal = stack.get(stack.size() - 1);
  while (goal.dad != null) {
    if (obst[goal.x][goal.y] != 3) {
      obst[goal.x][goal.y] = 5;
    } 
    goal = goal.dad;
  }
}

boolean exist (ArrayList<Bloc> t, Bloc b) {
  for (Bloc bt : t) {
      if (bt.x == b.x && bt.y == b.y) {
        return true;
      }
    }
  return false;
}

void cleanPath() {
  for (int x = 0; x < 16; x++ ) {
    for (int y = 0; y < 16; y++ ) {
      if (obst[x][y] == 4 || obst[x][y] == 5) {
        obst[x][y] = 0;
      }
    }
  }
}
