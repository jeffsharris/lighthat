#include "LPD8806.h"
#include "SPI.h"

// Example to control LPD8806-based RGB LED Modules in a strip!
// NOTE: WILL NOT WORK ON TRINKET OR GEMMA due to floating-point math
/*****************************************************************************/

#if defined(USB_SERIAL) || defined(USB_SERIAL_ADAFRUIT)
// this is for teensyduino support
int dataPin = 2;
int clockPin = 1;
#else 
// these are the pins we use for the LED belt kit using
// the Leonardo pinouts
int dataPin = 16;
int clockPin = 15;
#endif

#define N_LEDS       122
#define N_COLUMNS    19
#define LEG_LENGTH   32
#define LED_PER_ROW  18
#define N_ROWS       7
#define N_STRIPS     4
#define N_COLORS     7

const float pi = 3.14;

// Set the first variable to the NUMBER of pixels. 32 = 32 pixels in a row
// The LED strips are 32 LEDs per meter but you can extend/cut the strip
LPD8806 strip = LPD8806(N_LEDS, dataPin, clockPin);

int lights[][32] = { {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31},
                     {63, 62, 61, 60, 59, 58, 57, 56, 55, 54, 53, 52, 51, 50, 49, 48, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 35, 34, 33, 32},
                     {64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95},
                     {127, 126, 125, 124, 123, 122, 121, 120, 119, 118, 117, 116, 115, 114, 113, 112, 111, 110, 109, 108, 107, 106, 105, 104, 103, 102, 101, 100, 99, 98, 97, 96} };
                     
int columns[][7] = { {0, 20, 39, 58, 77, 95, 113},
                    {1, 21, 40, 59, 78, 96, 114},
                    {2, 22, 41, 60, 79, 97, 115},
                    {3, 23, 42, 61, 80, 98, 116},
                    {4, 24, 43, 62, 81, 99, 117},
                    {5, 25, 44, 63, 82, 100, 118},
                    {6, 26, 45, 64, 83, 101, 119},
                    {7, 27, 46, 65, 84, 102, 120},
                    {8, 28, 47, 66, 85, 103, 121},
                    {9, 29, 48, 67, 67, 67, 67},
                    {10, 30, 49, 68, 86, 104, 104},
                    {11, 31, 50, 69, 87, 105, 105},
                    // {12, 12, 12, 12, 12, 12, 12}, Don't use this row
                    {13, 32, 51, 70, 88, 106, 106},
                    {14, 33, 52, 71, 89, 107, 107},
                    {15, 34, 53, 72, 90, 108, 108},
                    {16, 35, 54, 73, 91, 109, 109},
                    {17, 36, 55, 74, 92, 110, 110},
                    {18, 37, 56, 75, 93, 111, 111}, 
                    {19, 38, 57, 76, 94, 112, 112} };
                    
                                 
                  
uint32_t colors[] = { strip.Color(127, 0, 0), strip.Color(127, 127, 0), strip.Color(0, 127, 0), strip.Color(0, 127, 127), strip.Color(0, 0, 127), strip.Color(127, 0, 127), strip.Color(127, 127, 127) };

void setup() {
  // Start up the LED strip
  strip.begin();

  // Update the strip, to start they are all 'off'
  strip.show();
}

// function prototypes, do not remove these!
void colorChase(uint32_t c, uint8_t wait);
void dither(uint8_t wait);

void rainbowDither(uint8_t wait);

void rainbowCycleWave(uint8_t wait);
void rainbowJump(uint8_t wait);

void sinWave2(uint32_t color, uint32_t backgroundColor, uint32_t spins, uint32_t wait);
void sinWave(uint32_t color, uint32_t backgroundColor, uint32_t spins, uint32_t wait);
void twistedSweep(uint32_t spins, uint8_t wait);
void diagonalSweep(uint32_t spins, uint8_t wait);
void sweep(uint32_t spins, uint8_t wait);
uint32_t Wheel(uint16_t WheelPos);

void loop() {
sinWave2(colors[0], colors[1], 20, 40);
  rainbowCycleWave(0);
  //rainbowJump(10);
diagonalSweep(20, 40);

sweep(20, 40);
twistedSweep(300, 40);

dither(10);
  

 
colorChase(strip.Color(127, 0, 0), 10); 

  
}

void sweep(uint32_t spins, uint8_t wait) { // Sweep around the hat in a colored pattern
  for (int i = 0; i < spins; i++) {
    for (int j = 0; j < N_COLUMNS; j++) {
      for (int k = 0; k < N_ROWS; k++) {
        strip.setPixelColor(columns[(j-1 + N_COLUMNS) % N_COLUMNS][k], strip.Color(0, 0, 0));
        for (int m = 0; m < N_COLORS; m++) { // For color tracking
          strip.setPixelColor(columns[(j+m) % N_COLUMNS][k], colors[m]);
        }
      }
    strip.show();
    delay(wait);
    }
  }
}

void diagonalSweep(uint32_t spins, uint8_t wait) { // Sweep around the hat in a colored pattern
  for (int i = 0; i < spins; i++) {
    for (int j = 0; j < N_COLUMNS; j++) {
      for (int k = 0; k < N_ROWS; k++) {
        strip.setPixelColor(columns[(j-1 + N_COLUMNS + k) % N_COLUMNS][k], strip.Color(0, 0, 0));
        for (int m = 0; m < N_COLORS; m++) { // For color tracking
          strip.setPixelColor(columns[(j+m + k) % N_COLUMNS][k], colors[m]);
        }
      }
    strip.show();
    delay(wait);
    }
  }
}

void twistedSweep(uint32_t spins, uint8_t wait) { // Sweep around the hat in a colored pattern
  for (int i = 0; i < spins; i++) {
    for (int j = 0; j < N_LEDS; j++) {
      if ((i + j) % LED_PER_ROW < N_COLORS) {
        strip.setPixelColor(j, colors[(i + j) % LED_PER_ROW]);
      } else {
        strip.setPixelColor(j, 0);
      }
    }
    strip.show();
    delay(wait);
  }
}

void sinWave2(uint32_t color, uint32_t backgroundColor, uint32_t spins, uint32_t wait) {
  for (int i=0; i < spins; i++) {
    for (int waveStart=0; waveStart < LED_PER_ROW; waveStart++) {
     for (int wavePointPosition=0; wavePointPosition < LED_PER_ROW; wavePointPosition++) {
       boolean foundMatch = false;
       for (int pixelPosition = 0; pixelPosition < N_ROWS; pixelPosition++) {
         float sinValue = sin(2.0 * pi * wavePointPosition / N_COLUMNS) * 4.0 + 3;
         if (((sinValue < pixelPosition) || (pixelPosition == (N_ROWS - 1))) && (foundMatch == false)) {
           strip.setPixelColor(columns[(waveStart + wavePointPosition) % N_COLUMNS][pixelPosition], colors[wavePointPosition % N_COLORS]);
           foundMatch = true;
         } else {
           strip.setPixelColor(columns[(waveStart + wavePointPosition) % N_COLUMNS][pixelPosition], strip.Color(0, 0, 0));
         }
       }
     }
    strip.show();
    delay(wait);
    }
  }
}

void sinWave(uint32_t color, uint32_t backgroundColor, uint32_t spins, uint32_t wait) {
  for (int i=0; i < spins; i++) {
    for (int waveStart=0; waveStart < LED_PER_ROW; waveStart++) {
     for (int wavePointPosition=0; wavePointPosition < LED_PER_ROW; wavePointPosition++) {
       boolean foundMatch = false;
       for (int pixelPosition = -3; pixelPosition <= 3; pixelPosition++) {
         
         float sinValue = sin(2.0 * wavePointPosition / LED_PER_ROW * pi) * 4.0;
         Serial.println(wait); 
         //Serial.println(pixelPosition); //Serial.println(" ");//Serial.println(waveStart); //Serial.print(" "); Serial.print(wavePointPosition); Serial.println(" ");
         if (sinValue < pixelPosition & foundMatch == false) {
           strip.setPixelColor(waveStart + wavePointPosition + LED_PER_ROW * (pixelPosition + 3), colors[0]);
           foundMatch = true;
         }
         else {
           strip.setPixelColor(waveStart + wavePointPosition + LED_PER_ROW * (pixelPosition + 3), colors[1]);
         }
         if ((waveStart + wavePointPosition + LED_PER_ROW * (pixelPosition + 3)) % LED_PER_ROW == 0) {
           strip.setPixelColor(waveStart + wavePointPosition + LED_PER_ROW * (pixelPosition + 3), colors[4]);
         }
       }
     }
   strip.show();
   delay(wait);
    }
  }
} 

// An "ordered dither" fills every pixel in a sequence that looks
// sparkly and almost random, but actually follows a specific order.
void dither(uint8_t wait) {

  // Determine highest bit needed to represent pixel index
  int hiBit = 0;
  int n = strip.numPixels() - 1;
  for(int bit=1; bit < 0x8000; bit <<= 1) {
    if(n & bit) hiBit = bit;
  }

  int bit, reverse;
  for(int i=0; i<(hiBit << 1); i++) {
    // Reverse the bits in i to create ordered dither:
    reverse = 0;
    for(bit=1; bit <= hiBit; bit <<= 1) {
      reverse <<= 1;
      if(i & bit) reverse |= 1;
    }
    strip.setPixelColor(reverse, colors[random(N_COLORS)]);
    strip.show();
    delay(wait);
  }
  delay(250); // Hold image for 1/4 sec
}

// Cycle through the color wheel, going down all four strands simultaneously
void rainbowCycleWave(uint8_t wait) {
  uint16_t i, j;

  for (j=0; j < 384 * 5; j++) {     // 5 cycles of all 384 colors in the wheel
    for (i=0; i < N_LEDS; i++) {
      // tricky math! we use each pixel as a fraction of the full 384-color
      // wheel (thats the i / strip.numPixels() part)
      // Then add in j which makes the colors go around per pixel
      // the % 384 is to make the wheel cycle around
      strip.setPixelColor(i, Wheel(((i * 384 / LEG_LENGTH) + j) % 384));
    }
    strip.show();   // write all the pixels out
    delay(wait);
  }
}

void colorChase(uint32_t c, uint8_t wait) {
  int i;

  for (i=0; i < strip.numPixels(); i++) {
    strip.setPixelColor(i, 0);  // turn all pixels off
  }

  for (i=0; i < strip.numPixels(); i++) {
      strip.setPixelColor(i, c); // set one pixel
      strip.show();              // refresh strip display
      delay(wait);               // hold image for a moment
      strip.setPixelColor(i, 0); // erase pixel (but don't refresh yet)
  }
  strip.show(); // for last erased pixel
}


/* Helper functions */

//Input a value 0 to 384 to get a color value.
//The colours are a transition r - g - b - back to r

uint32_t Wheel(uint16_t WheelPos)
{
  byte r, g, b;
  switch(WheelPos / 128)
  {
    case 0:
      r = 127 - WheelPos % 128; // red down
      g = WheelPos % 128;       // green up
      b = 0;                    // blue off
      break;
    case 1:
      g = 127 - WheelPos % 128; // green down
      b = WheelPos % 128;       // blue up
      r = 0;                    // red off
      break;
    case 2:
      b = 127 - WheelPos % 128; // blue down
      r = WheelPos % 128;       // red up
      g = 0;                    // green off
      break;
  }
  return(strip.Color(r,g,b));
}

