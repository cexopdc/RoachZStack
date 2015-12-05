// testshapes demo for Adafruit RGBmatrixPanel library.
// Demonstrates the drawing abilities of the RGBmatrixPanel library.
// For 32x32 RGB LED matrix:
// http://www.adafruit.com/products/607

// Written by Limor Fried/Ladyada & Phil Burgess/PaintYourDragon
// for Adafruit Industries.
// BSD license, all text above must be included in any redistribution.

#include <Adafruit_GFX.h>   // Core graphics library
#include <RGBmatrixPanel.h> // Hardware-specific library

/////////////////////
// Hardware Hookup //
/////////////////////
// R0, G0, B0, R1, G1, B1 should be connected to pins 
// 2, 3, 4, 5, 6, and 7 respectively. Their pins aren't defined,
// because they're controlled directly in the library. These pins
// can be moved (somewhat):
#define OE  9
#define LAT 10
#define A   A0
#define B   A1
#define C   A2
#define D   A3 // Comment this line out if you're using a 32x16
// CLK can be moved but must remain on PORTB(8, 9, 10, 11, 12, 13)
#define CLK 11  // MUST be on PORTB!

// Instantiate the RGBmatrixPanel class. One of these should be
// commented out!
// For 32x32 LED panels:
RGBmatrixPanel matrix(A, B, C, D, CLK, LAT, OE, false); // 32x32

int length;
int bars;
int temp;
int rotation;
int speedPin = 5; // analog input 5
int directionPin = 4;
char forward;

void setup() {
  Serial.begin(9600);
  matrix.begin(); 
}
  
char ch = 0;  
void loop() { 
  if(Serial.available()>0)
  {
    forward = Serial.read();
    rotation = Serial.parseInt();
    while(forward == 'b') {
      twoON_twoOFF_Backwards(rotation);
    }
    while (forward == 'f') { 
      twoON_twoOFF(rotation);
    }
  }
  
  // if you wanted to set up a version using the knobs and switch
  // read rotation from knob
  /*rotation = analogRead(speedPin)/2;
  forward = analogRead(directionPin);
  Serial.print(rotation);
  Serial.print("\n");
  Serial.print(forward);
  Serial.print("\n");
  
  if(forward < 10) {
    twoON_twoOFF_Backwards(rotation);
  }
  else { 
    twoON_twoOFF(rotation);
  }  */
  
}


// the code following is super duper ugly, please just don't even venture down here
void twoON_twoOFF_Backwards(double rotation)
{
  length = 2;
  bars = 2;
  for (int x = 31; x>=0; x--) {
      delay(rotation);
           
    if(x>=2) {
        matrix.fillRect((x-length), 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-4, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-4, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-8, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-8, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-12, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-12, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-16, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-16, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-20, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-20, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-24, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-24, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-28, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-28, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
    }       
    
    if(x<30) {
        //Serial.print("second statement");
        matrix.fillRect((x-length), 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x+30), 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x+32), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-4, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-4, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x+30)-4, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x+32)-4, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-8, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-8, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x+30)-8, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x+32)-8, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-12, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-12, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x+30)-12, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x+32)-12, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-16, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-16, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x+30)-16, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x+32)-16, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-20, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-20, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x+30)-20, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x+32)-20, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-24, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-24, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x+30)-24, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x+32)-24, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect((x-length)-28, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x)-28, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x+30)-28, 0, 2, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x+32)-28, 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
      
        
      
    }
    
  }
}


void twoON_twoOFF(double rotation)
{
  length = 2;
  bars = 2;
  temp = length;
  for (int x = length+1; x<= length*(bars+1); x++) {
      delay(rotation);
      if(x<=(length*bars)) {
        matrix.fillRect((x-length), 0, length, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect(4+(x-length), 0, length, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(4+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect(8+(x-length), 0, length, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(8+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect(12+(x-length), 0, length, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(12+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect(16+(x-length), 0, length, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(16+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect(20+(x-length), 0, length, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(20+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect(24+(x-length), 0, length, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(24+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        
        matrix.fillRect(28+(x-length), 0, length, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(28+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
      }     
      
      if(x>(length*(bars-4))) {
        matrix.fillRect((x-length), 0, temp, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect((x-length*(bars+1)), 0, (length), 32, matrix.Color333(7, 7, 7));
        matrix.fillRect((x-(length*(bars+1)+1)), 0, 1, 32, matrix.Color333(0, 0, 0));
        
        matrix.fillRect(4+(x-length), 0, temp, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(4+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect(4+(x-length*(bars+1)), 0, (length), 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(4+(x-(length*(bars+1)+1)), 0, 1, 32, matrix.Color333(0, 0, 0));
        
        matrix.fillRect(8+(x-length), 0, temp, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(8+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect(8+(x-length*(bars+1)), 0, (length), 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(8+(x-(length*(bars+1)+1)), 0, 1, 32, matrix.Color333(0, 0, 0));
        
        matrix.fillRect(12+(x-length), 0, temp, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(12+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect(12+(x-length*(bars+1)), 0, (length), 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(12+(x-(length*(bars+1)+1)), 0, 1, 32, matrix.Color333(0, 0, 0));
        
        matrix.fillRect(16+(x-length), 0, temp, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(16+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect(16+(x-length*(bars+1)), 0, (length), 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(16+(x-(length*(bars+1)+1)), 0, 1, 32, matrix.Color333(0, 0, 0));
        
        matrix.fillRect(20+(x-length), 0, temp, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(20+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect(20+(x-length*(bars+1)), 0, (length), 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(20+(x-(length*(bars+1)+1)), 0, 1, 32, matrix.Color333(0, 0, 0));
        
        matrix.fillRect(24+(x-length), 0, temp, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(24+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect(24+(x-length*(bars+1)), 0, (length), 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(24+(x-(length*(bars+1)+1)), 0, 1, 32, matrix.Color333(0, 0, 0));
        
        matrix.fillRect(28+(x-length), 0, temp, 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(28+(x-(length+1)), 0, 1, 32, matrix.Color333(0, 0, 0)); // clear column
        matrix.fillRect(28+(x-length*(bars+1)), 0, (length), 32, matrix.Color333(7, 7, 7));
        matrix.fillRect(28+(x-(length*(bars+1)+1)), 0, 1, 32, matrix.Color333(0, 0, 0));
      }
      temp = temp-1;
    }     
}

