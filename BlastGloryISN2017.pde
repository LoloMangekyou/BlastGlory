//////////GNU General Public License v3.0//////////  
//////////ATENTION ce jeu a été réalisé par Loïc Rizzo/ Lucas Marcel/ Célia Chemineau //////////// 
//////////OPEN SOURCE GAME ///////////

/////// HAVE FUN ON BlastGlory !!!! //////



ArrayList <Bullet> bullets = new ArrayList <Bullet> ();
ArrayList <Enemy> enemies = new ArrayList <Enemy> ();
ArrayList <Boss> boss = new ArrayList <Boss> ();
    PVector player, playerSpeed;
    float maxSpeed = 8;
    int hp =3;                   //point de vie
    int kill =0;                 //score
    int es = 25;                 //cadence spawn enemy
    float dx =3;                 //vitesse enemy
    int cdt =5;                  //cadence de tir
    boolean menu = false;        //variable menu
    int pvb =0;                  //boss pv
    int c =0;                    //color boss
    int bkill=0;                 //boss kill 
    int clean=0;                 //clean le board 
    int gm = 1;                  //godMode variable
    
   
     
    void setup() {
      size(1200, 900);
      player = new PVector(width/2, height/2);
      playerSpeed = new PVector();                  
      noCursor();
      noStroke();
      smooth();
    }
   
     
    void draw() {
            
                if(!menu){                          //menu
                  background(100);
                  textSize(70);               
                      fill(20,200,200);
                      text("Blast Glory", width/2-150, 100);
                      textSize(50);
                      fill(0,0,0);
                      text("Menu", width/2-300, 250);
                      textSize(30);
                      text("Appuyer sur   u   pour jouer", width/2-200, 350);
                      text("Commandes :",width/2-200,450);
                      text(" z   pour avancer",width/2-100,500);
                      text(" s   pour reculer",width/2-100,550);
                      text(" q   pour aller à gauche",width/2-100,600);
                      text(" d   pour aller à droite ",width/2-100,650);
                      text("tirer ---> clic gauche  ",width/2-100,700);
                      text("Appuper sur   p   pour mettre pause", width/2-200, 750);
                      text("Appuper sur   h   pour revenir au menu", width/2-200, 800);
                      text("Appuper sur   g   pour activer le GodMode", width/2-200, 850);
                  
                }
                
                
                
         if(menu){
         
                   if (frameCount%es==0) {        //cadence d'apparition des énemies 
                        enemies.add(new Enemy());
                   }
                   
                   hp=constrain(hp,-2,3);       //pour empêcher que la regen donne plus que la valeur initial d'hp                           
                   background(0);
                   player.x=constrain(player.x+playerSpeed.x,20,width-60);   //bordure de map (mur infranchissable pour le joueur) 
                   player.y=constrain(player.y+playerSpeed.y,20,height-60);  //bordure de map (mur infranchissable pour le joueur)
                   //println(player);
                   fill(0, 0, 255);        
                   ellipse(player.x,player.y, 40, 40);  //skin player 
                   fill(255);
                   ellipse(player.x,player.y, 10, 10);  //skin bullet

                   PVector mouse = new PVector(mouseX, mouseY);  
                   fill(255);
                   ellipse(mouse.x, mouse.y, 5, 5);     //curseur 
                   
                         if (frameCount%cdt==0 && mousePressed) {
                            PVector dir = PVector.sub(mouse, player); 
                            dir.normalize();
                            dir.mult(maxSpeed*3);
                            Bullet b = new Bullet(player, dir);   //vecteur trajectoire des bullets
                            bullets.add(b);                       //créer un bullet
                          }
                        
                        
              for (int i = enemies.size ()-1; i>=0; i--) {
              Enemy b = (Enemy) enemies.get(i);               // créer un énemie 
              b.move();                                       // mouvement des énnemies
                    
       
                    for(Bullet blt : bullets) {                                        // check enemy to bullet collisions  /  Pour chaque Bullet
                            if(dist(blt.x,blt.y,b.enemiPosition.x,b.enemiPosition.y) <20){   //if the distance between the bullet and enemy is less than the enemy's width
                              enemies.remove(b);                                             //remove the enemy
                              kill=kill+1;           
                             }
                      } 
            

                    if(dist(player.x,player.y,b.enemiPosition.x,b.enemiPosition.y) < 20){    //check enemy to player collision
                      enemies.remove(b);                                                     //remove the enemy
                      hp = hp+(-1*gm);                             //modifie et gangne un hp au lieu d'en perdre lors d'une colision (triche/godmode)                          
                                
                            if(hp<0){          //après la mort 
                              noLoop();        //stop le jeu
                              textSize(70);
                              fill(160,60,215);
                              text("Game Over !!!", width/2-250, 400); 
                              fill(160,60,215);
                              text("RePlay press 'O'", width/2-200, 500);
                            } 
                    }            
              } 
             
   
                for (int i = boss.size ()-1; i>=0; i--) {   
                         Boss b = (Boss) boss.get(i);           // créer un boss 
                         b.move();                              // mouvement du boss 
                            
                      for(Bullet blt : bullets) {       //check enemy to bullet collisions  / Pour chaque bullet         
                                if(dist(blt.x,blt.y,b.bossPosition.x,b.bossPosition.y) <50){    //if the distance between the bullet and enemy is less than the enemy's width
                                 
                                  pvb=pvb+1;  // à chaque coup prend 1 dégat (0 à 100 et meurt à 100)
                                  c=c+2;      // couleur change 
                                  //println(pvb); 
                                                if(pvb>100){  
                                                boss.remove(b); //remove boss
                                                pvb=0;    // remet ls point de vie initial
                                                c=0;      // remet la couleur initial   
                                                bkill=bkill+1;  //permet de faire spawn le prochain boss 
                                                
                                               }
                                  //println(bkill);
                                     
                                }
                      } 
                    
                   
                        if(dist(player.x,player.y,b.bossPosition.x,b.bossPosition.y) < 50){  //check enemy to player collision
                          enemies.remove(b);  //remove énemie 
                          hp = hp+(-1*gm);    // player perd un point de vie / sauf en godmod
                                          
                              if(hp<0){   //on meurt
                                noLoop();      //stop le jeu
                                textSize(70);
                                fill(160,60,215);
                                text("Game Over !!!", width/2-250, 400); 
                                fill(160,60,215);
                                text("RePlay press 'O'", width/2-200, 500);
                              } 
                        }            
               }
                 
             
             
              if(gm==-1){                
                        textSize(20);
                        fill(255);
                        text("GodMode", width-100, 30);
                        fill(0,255,0);
                        text("ON", width-50, 46);
                      }
                      
              if(gm==1){
              textSize(20);
              fill(255);
              text("GodMode", width-100, 30);
              fill(255,0,0);
              text("OFF", width-50, 46);
              }                               //GodMode
             
          
              // passage de wave               
             
                      if(kill<10){
                        textSize(30);               
                        fill(0,0,255);
                        text("Wave 1", width/2, 100);
                       
                      }                      
                      if(kill>10 && clean==0){  
                            for (int i = enemies.size ()-1; i>=0; i--) {   
                               Enemy b = (Enemy) enemies.get(i);
                               enemies.remove(b); 
                             }  
                       clean=1;
                      }
                      
                      
                      if(20>kill && kill>10){
                        textSize(30);               
                        fill(0,0,255);
                        text("Wave 2", width/2, 100);
                        dx=2.8;
                        es=20;
                        cdt=6;
                      }
                      if(kill>20 && clean==1){ 
                            for (int i = enemies.size ()-1; i>=0; i--) {
                               Enemy b = (Enemy) enemies.get(i);
                               enemies.remove(b);
                              }
                        clean=2;
                      }
                      
                      if(30>kill && kill>20){
                        textSize(30);               
                        fill(0,0,255);
                        text("Wave 3", width/2, 100);
                        dx=2.6;
                        es=15;
                        cdt=7;
                      }
                      if(kill>30 && clean==2){  
                            for (int i = enemies.size ()-1; i>=0; i--) {
                               Enemy b = (Enemy) enemies.get(i);
                               enemies.remove(b);
                              } 
                         clean=3;
                        }
                         
                      if(40>kill && kill>30){
                        textSize(30);               
                        fill(0,0,255);
                        text("Wave 4", width/2, 100);
                        dx=2.4;
                        es=10;
                        cdt=8;
                      }
                      if(kill>40 && clean==3){  
                            for (int i = enemies.size ()-1; i>=0; i--) {
                               Enemy b = (Enemy) enemies.get(i);
                               enemies.remove(b);
                            }  
                        clean=4;
                      }
                     
                      if((bkill==0 || bkill==1) && kill>40){
                         textSize(30);               
                         fill(0,0,255);
                         text("Wave 5", width/2, 100);
                           if(bkill==0){                  
                               boss.add(new Boss());
                               bkill=1;
                           }
                       dx=2.2;
                       es=5;
                       cdt=9;
                     }                     
                     if((kill>50 && clean==4) && bkill==2){  
                           for (int i = enemies.size ()-1; i>=0; i--) {
                              Enemy b = (Enemy) enemies.get(i);
                              enemies.remove(b);     
                           } 
                       clean=5;
                     }
                                         
                    if((bkill==2 || bkill==3) && kill>60){
                         if(bkill==2){                  
                           boss.add(new Boss());
                           bkill=3;
                         }     
                      textSize(30);               
                      fill(0,0,255);
                      text("Wave 6", width/2, 100);
                      dx=2;
                      es=5;
                      cdt=7;
                    }
                    if(bkill==4 && (kill>70 && clean==5)){  
                          for (int i = enemies.size ()-1; i>=0; i--) {
                             Enemy b = (Enemy) enemies.get(i);
                             enemies.remove(b);           
                          }  
                      clean=6;
                    }
                        
                    if((bkill==4 || bkill==5 || bkill==6 || bkill==7) && kill>70){
                         if(bkill==4){                  
                           boss.add(new Boss());
                           bkill=5;
                         }
                         if(bkill==6){                  
                         boss.add(new Boss());
                          bkill=7;
                         }
                         
                      textSize(30);               
                      fill(0,0,255);
                      text("Wave 7", width/2, 100);
                      dx=2;
                      es=5;
                      cdt=5;
                   }
                   if(bkill==8 && (kill>80 && clean==6)){  
                          for (int i = enemies.size ()-1; i>=0; i--) {
                             Enemy b = (Enemy) enemies.get(i);
                             enemies.remove(b);          
                          }  
                     clean=7;
                   }
                        
                        
                   if((bkill==8 || bkill==9 || bkill==10 || bkill==11 || bkill==12 || bkill==13) && kill>80){
                          if(bkill==8){                  
                          boss.add(new Boss());
                          bkill=9;
                          }
                          if(bkill==10){                  
                          boss.add(new Boss());
                          bkill=11;
                          }
                          if(bkill==12){                  
                          boss.add(new Boss());
                          bkill=13;
                          }                        
                     textSize(30);               
                     fill(0,0,255);
                     text("Wave 8", width/2, 100);
                     dx=2;
                     es=5;
                     cdt=4;
                  }
                  if(bkill==14 && (kill>80 && clean==7)){  
                        for (int i = enemies.size ()-1; i>=0; i--) {
                           Enemy b = (Enemy) enemies.get(i);
                           enemies.remove(b);     
                        }  
                    clean=8;
                  }
                         
                  if(bkill==14 && kill>100){
                        textSize(120);               
                        fill(random(255));
                        text("Congratulation !!!!", 80, 400);
                        dx=100;
                        es=50000;
                        cdt=5;
                  }
                         
                          
                   textSize(30);                 //affiche le scrore 
                   fill(100,100,100);
                   text(kill, width-100, 80);
     
                   textSize(40);                 //affiche les hp
                   fill(100,255,0);
                   text(hp, width/10, 100);
                     
                 if (frameCount%300==0) {        //regen
                    hp=hp+1;
                  }
                     
        
                 for (Enemy b : enemies) {       //affichage skin   
                     b.display();
                  }                  
                 for (Boss b : boss) {          //affichage skin   
                     b.display();
                  }                                  
                 for (Bullet b : bullets) {     //affichage des Bullets
                     b.update();
                     b.display();
                 }
         }
  }
  
    
    
           class Enemy {                     // l'objet ennemi

                PVector enemiPosition;       // vecteur qui définisse l'ennemi 
                PVector enemySpeed; 
 
                  Enemy() {
                   enemiPosition = new PVector(width/2*(int)random(0,3),height*(int)random(0,2));        //spawn de l'ennemi 
                  }
                         void move() {
                               enemySpeed = PVector.sub(player, enemiPosition);              //mvt de l'ennemi 
                               enemySpeed.normalize();
                               enemySpeed.mult(maxSpeed/dx);
                               enemiPosition =  PVector.add(enemiPosition, enemySpeed);
                               //println(enemiPosition);
                          }
                                             
                          void display() {                   //skin ennemi
                                fill(255, 0, 0);
                                ellipse(enemiPosition.x, enemiPosition.y, 10, 10);
                          }
                    
                    
            }  
                 
                 
           class Boss {                     // l'objet ennemi

                PVector bossPosition;       // vecteur qui définisse l'ennemi 
                PVector bossSpeed; 
 
                  Boss() {
                   bossPosition = new PVector(width/2,height/2);        //spawn de l'ennemi 
                  }
                         void move() {
                               bossSpeed = PVector.sub(player, bossPosition);              //mvt de l'ennemi 
                               bossSpeed.normalize();
                               bossSpeed.mult(maxSpeed/2.5);
                               bossPosition =  PVector.add(bossPosition, bossSpeed);
                               //println(bossPosition);
                          }
                                             
                          void display() {                   //skin ennemi
                                fill(255, c, c);
                                ellipse(bossPosition.x, bossPosition.y, 50, 50);
                          }
                    
                    
            }
                 
     
            class Bullet extends PVector {                 //objet tir 
                      PVector vel;
                       
                       Bullet(PVector loc, PVector vel) {
                         super(loc.x, loc.y);
                         this.vel = vel.get();
                        }
                       
                        void update() {
                          add(vel);
                        }
                       
                        void display() {                   //skin
                          fill(255, 255, 255);
                          ellipse(x, y, 3, 3);
                        }
           }
                  
     
   void keyPressed() {                          //mvt joueur 
     
        if (key == 'z')    { playerSpeed.y = -maxSpeed; }
        if (key == 's')  { playerSpeed.y = maxSpeed;  }
        if (key == 'q')  { playerSpeed.x = -maxSpeed; }
        if (key == 'd') { playerSpeed.x = maxSpeed;  }
        
            if(keyPressed){
               if(key=='o'&& hp<0){
                   for (int i = enemies.size ()-1; i>=0; i--) {
                     Enemy b = (Enemy) enemies.get(i);
                     enemies.remove(b);
                   }                     //kill all enemies
                     for (int i = boss.size ()-1; i>=0; i--) {
                     Boss b = (Boss) boss.get(i);
                     boss.remove(b);
                   }
                      kill=0;                     //remise à 0 du score 
                      hp=3;                       //redonner les hp initial
                      es=25;
                      dx=3;
                      cdt=5;
                      c=0;
                      bkill=0;
                      pvb =0;
                      clean=0;
                      gm = 1;
                      player = new PVector(width/2, height/2);      //replacer le joueur au milieu 
                      loop();      //pour rejouer
               }      
          }
          
          if(keyPressed){
               if(key=='p'){ 
                 
                      textSize(100);               
                      fill(255,0,255);
                      text("PAUSE", width/2-200, 300);
                      textSize(30);
                      text("Appuyer sur   r   pour reprendre", width/2-200, 500);
                      textSize(30);
                      text("Appuyer sur   h   pour retourner au menu", width/2-200, 600);
                      
                      
                      noLoop();      //pour pause
               }      
          }
          if(keyPressed){
               if(key=='r'){
                       
                      loop();      //pour reprendre
               }      
          }
          
          if(keyPressed){
               if(key=='u'){
                      
                      menu = true;
               }      
          }
          
          
          
          if(keyPressed){
               if(key=='g'){
                  
                      gm = gm*-1;                   
               }      
          }
          
          if(keyPressed){
                if(key=='h'){
                     for (int i = enemies.size ()-1; i>=0; i--) {
                         Enemy b = (Enemy) enemies.get(i);
                         enemies.remove(b);
                       }                     //kill all enemies
                     for (int i = boss.size ()-1; i>=0; i--) {
                        Boss b = (Boss) boss.get(i);
                        boss.remove(b);
                     }                      //kill all boss
                        kill=0;                       //remise à 0 du score 
                        hp=3;                         //redonner les hp initial
                        es=25;
                        dx=3;
                        cdt=5;
                        c=0;
                        bkill=0;
                        pvb =0;
                        clean=0;
                        gm = 1;
                        player = new PVector(width/2, height/2);      //replacer le joueur au milieu
                        loop();
                        menu = false;
               }      
          }
  }
     
    void keyReleased() {
      if (key == 'z' || key == 's') { playerSpeed.y = 0; }
      if (key == 'q' || key == 'd') { playerSpeed.x = 0; }
    }
    
    
    
    
    
    
    

    