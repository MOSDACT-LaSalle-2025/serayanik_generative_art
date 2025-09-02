/** echoes of the (e)motion — beginner ≤100 lines (red → violet residue) */
ArrayList<Beam> beams; ArrayList<Dot> dots;
int targetBeams=3, emitCooldown=40, emitTimer=0; boolean paused=false;
float H_RED=8, H_VIOLET=285;

void setup(){
  size(800,600); frameRate(60); smooth(4);
  colorMode(RGB,255); background(12,12,14);
  colorMode(HSB,360,100,100,255);
  beams=new ArrayList<Beam>(); dots=new ArrayList<Dot>();
  for(int i=0;i<targetBeams;i++) beams.add(randomBeam());
}

void draw(){
  if(paused) return;
  colorMode(RGB,255); noStroke(); fill(12,12,14,16); rect(0,0,width,height);
  colorMode(HSB,360,100,100,255);
  for(int i=beams.size()-1;i>=0;i--){
    Beam b=beams.get(i); b.update(); b.render();
    if(b.isResolving() && frameCount%b.dotEvery==0)
      dots.add(new Dot(b.pos.copy(), random(2,5), color(H_VIOLET,70,100,200)));
    if(b.dead()) beams.remove(i);
  }
  for(int i=dots.size()-1;i>=0;i--){
    Dot d=dots.get(i); d.update(); d.render();
    if(d.dead()) dots.remove(i);
  }
  emitTimer--; if(emitTimer<=0){ emitTimer=emitCooldown; if(beams.size()<targetBeams) beams.add(randomBeam()); }
}

Beam randomBeam(){
  int side=floor(random(4)); PVector p,v; float sp=random(3.0,4.5), j=radians(random(-8,8));
  if(side==0){ p=new PVector(0,random(height)); v=new PVector(1,0).rotate(j).mult(sp); }
  else if(side==1){ p=new PVector(width,random(height)); v=new PVector(-1,0).rotate(j).mult(sp); }
  else if(side==2){ p=new PVector(random(width),0); v=new PVector(0,1).rotate(j).mult(sp); }
  else{ p=new PVector(random(width),height); v=new PVector(0,-1).rotate(j).mult(sp); }
  return new Beam(p,v,floor(random(45,100)));
}

class Beam{
  PVector pos,vel; int life,maxLife; float w=3,len=90; boolean resolving=false; int resolveFrames=24,resolveTimer=0; int dotEvery=floor(random(6,12));
  Beam(PVector p,PVector v,int L){ pos=p.copy(); vel=v.copy(); life=L; maxLife=L; }
  void update(){ pos.add(vel);
    if(!resolving){ w=max(1.0,w*0.995); len*=1.002; if(--life<=0){ resolving=true; resolveTimer=resolveFrames; } }
    else{ vel.mult(0.96); resolveTimer--; } }
  int lineCol(){ float t=1.0-(float)max(0,life)/max(1,maxLife); return color(lerp(H_RED,H_VIOLET,constrain(t,0,1)),85,100,235); }
  void render(){ stroke(lineCol()); strokeWeight(w);
    PVector dir=vel.copy().normalize(); PVector a=PVector.sub(pos,PVector.mult(dir,len));
    line(a.x,a.y,pos.x,pos.y);
    if(resolving){ float t=1.0-(float)resolveTimer/resolveFrames; float e=(t<.5)?(2*t*t):(1-pow(-2*t+2,2)/2.0); float r=lerp(2,10,e);
      noStroke(); fill(H_VIOLET,70,100,220); ellipse(pos.x,pos.y,r,r); } }
  boolean isResolving(){ return resolving&&resolveTimer>0; }
  boolean dead(){ return (pos.x<-60||pos.x>width+60||pos.y<-60||pos.y>height+60)||(resolving&&resolveTimer<=0); }
}

class Dot{
  PVector pos; float r; int col; float alpha=200, shrink=0.993, decay=0.90;
  Dot(PVector p,float r,int c){ pos=p.copy(); this.r=r; col=c; }
  void update(){ r*=shrink; alpha*=decay; }
  void render(){ int c=color(hue(col),saturation(col),brightness(col),constrain(alpha,0,255)); noStroke(); ellipse(pos.x,pos.y,max(r,0.1),max(r,0.1)); }
  boolean dead(){ return alpha<2||r<0.2; }
}

void keyPressed(){
  if(key=='r'||key=='R'){ colorMode(RGB,255); background(12,12,14); colorMode(HSB,360,100,100,255);
    beams.clear(); dots.clear(); for(int i=0;i<targetBeams;i++) beams.add(randomBeam()); }
  if(key=='s'||key=='S') saveFrame("echoes_beginner-####.png");
  if(key==' ') paused=!paused;
}

/* 
Name:Sera Yanik
Date: 02/09/2025
Description: A sharp action cuts into space; its first form is a line—decisive, mathematical.
As it travels, the act softens into aftermath: the line resolves into a single dot that repeats,
echo after echo, fading yet persisting. 
The system visualizes how our movements (and moods) inscribe themselves on the environment—signals 
that may not be felt immediately, but continue to ripple through time.
Place of production: Barcelona
Instructions (if necessary): --
*/
