// TODO: Fix jitter when removing companies on ios
// TODO: Fix frame rate issue
// TODO: Fix falling companies from falling through marker.
// TODO: Adjust the shrinkage proportion
// TODO: add a win screen
// TODO: add a red flash when you shrink
// TODO: add title screen with instructions, 
// TODO: change difficulty based on screen size
// TODO: color of circle is upward or downward trend

int cRamp = 0;
boolean cTriggerR = false;
boolean cTriggerG = false;

ArrayList companies = new ArrayList();

// myMan sizing
float es = 50;

//global variables for background color
color bgc = 30;

//gloabl variable for array of stocks and prices
String[] mCaps;

//gloabl win variable
boolean win = false;

// Timing variables
int startTime;
int counter = 0;
int once = 0;
int pauseTimer = 0;

void setup() {
  size(800, 600);
  startTime = millis();
  mCaps = loadStrings("all.php");
  // println(mCaps);
  noCursor();
  strokeWeight(3);
}

void draw() {  
  stroke(255);
  scene();
  populateCompany();
  displayCompanies();
  myMan();

  if (cTriggerR) {
    coverScreenR();
  }
  
    if (cTriggerG) {
    coverScreenG();
  }
}

void mouseReleased() {
  //cTrigger = true;
}

void coverScreenR() {
  noStroke();
  if (cRamp < 10 && cTriggerR == true) {
    cRamp++;
    float m = map(cRamp, 0, 10, 100, 0);
    fill(255, 0, 0, m); 
    rect(0, 0, width, height);
    //es = 50;
  } 
  else { 
    cRamp = 0; 
    cTriggerR = false;
  }
}

void coverScreenG() {
  noStroke();
  if (cRamp < 10 && cTriggerG == true) {
    cRamp++;
    float m = map(cRamp, 0, 10, 100, 0);
    fill(0, 255, 0, m); 
    rect(0, 0, width, height);
    //es = 50;
  } 
  else { 
    cRamp = 0; 
    cTriggerG = false;
  }
}

// Behavior and display for "myMan"
void myMan() {
  fill(225, 100, 100);
  ellipse(mouseX, mouseY, es, es);
  fill(255);
  textSize(es/5);
  text(str(int(es))+"M", mouseX, mouseY);
  if (es > width*1.5) {
    win = true;
  }
  for (int i = companies.size()-1; i >= 0; i--) {
    Company c = (Company) companies.get(i);
    if (
    c.display().x > mouseX - ((c.cSize()/2)+(es/2)) && 
      c.display().x < mouseX + ((c.cSize()/2)+(es/2)) && 
      c.display().y > mouseY - ((c.cSize()/2)+(es/2)) && 
      c.display().y < mouseY + ((c.cSize()/2)+(es/2))
      ) {
        
        

      // adjust size of myMan based on company size  
      if (es > c.cSize()) {
        es+=(c.cSize()/2);
        cTriggerG = true;
      } 

      if (es < c.cSize()) {
        es-=(c.cSize()/8);
        cTriggerR = true;
      }

      // if myMan is too small make 50
      if (es < 50) {
        es = 50;
      }
      companies.remove(i);
    }
  }
} 

void scene() {
  background(bgc);
}

// draw company circles
void populateCompany() {

  if (millis() > startTime + 1000) {
    startTime = millis(); // reset start time
    counter ++; // add to the counter
    int companyPick = int((random(mCaps.length))/2);
    companies.add(new Company(companyPick));
    once = 0;
  }

//  if (counter % 120 == 0 && once == 0) {
//    mCaps = loadStrings("all.php");
//    once = 1;
//  }
}

// show and remove company circles
void displayCompanies() {
  for (int i = companies.size()-1; i >= 0; i--) {
    Company c = (Company) companies.get(i);
    c.display();
  }

  for (int i = companies.size()-1; i >= 0; i--) {
    Company c = (Company) companies.get(i);
    if (c.display().y > height) {
      companies.remove(i);
    }
  }
}

// a class for creating each company circle
class Company {
  int sValue;
  float ex;
  float ey;
  int ewh;
  PVector[] pairs;

  Company(int sv) {
    sValue = sv;
    ex = random(width);
    pairs = new PVector[int(mCaps.length/2)];
  }

  // outputs a PVector with x = to market value and y = to compnay stock symbol
  PVector pairing(int n) {
    for (int i = 0; i < pairs.length; i++) {
      pairs[i] = new PVector(i*2, (i*2)+1);
    }

    PVector p = new PVector(pairs[n].x, pairs[n].y);

    if (p.y > width) { 
      p.y = width/1.5;
    }
    if (p.y < 2) { 
      p.y = 2;
    }
    float m = map(p.y, 2, width/2, 2, width/2);
    p.y = int(m);

    return p;
  }

  int mCap() {
    int x = mCaps[int(pairing(sValue).y)];
    return x;
  }

  String symbol() {
    String x = mCaps[int(pairing(sValue).x)];
    return x;
  }

  int cSize() {
    return ewh;
  }

  PVector display() {
    ewh = mCap();
    //println(ewh);
    //    ey = ey + ewh/50;
    float s = 200 / ewh;
    s > 2 ? s = 2 : s = s;
      ey = ey + s;
    //fill(250);
    noFill();
    ellipse(ex, ey, ewh, ewh);
    fill(225, 100, 100);
    int ts = int(ewh/5);
    if (ts < 10) {
      ts = 15;
    }
    textSize(ts);
    textAlign(CENTER);
    text(symbol(), ex, ey);
    PVector CompanyPosition = new PVector(ex, ey);
    return CompanyPosition;
  }
}

