//公式のソースコードをLCD出力対応に改造
//https://github.com/Seeed-Studio/Seeed_Learning_Space/blob/master/Grove%20-%20Intergraded%20Pressure%20Sensor(MPX5700AP)/get_pressure/get_pressure.ino
int rawValue; // A/D readings
// キャリブレーション用。kPa単位で指定。この値を増やすと、表示される気圧が減少します
int offset = 370;  //5V駆動で300~400
int fullScale = 9630; // max pressure (span) adjust
float pressure; // final pressure
#define SERIAL Serial

//LCDの設定
#include <LiquidCrystal_I2C.h> //https://github.com/johnrickman/LiquidCrystal_I2C
LiquidCrystal_I2C lcd(0x27,16,2);


void setup() {
  SERIAL.begin(9600);
  //LCD関係
  lcd.init(); 
  lcd.backlight();
}

void loop() {
  
  rawValue = 0;
  for (int x = 0; x < 10; x++) rawValue = rawValue + analogRead(A0);
  pressure = (rawValue - offset) * 700.0 / (fullScale - offset); // pressure conversion

  //シリアル出力
  SERIAL.print(pressure*10, 1); 
  //SERIAL.println("  hPa");

  //LCD出力
  lcd.setCursor(0, 0);
  lcd.print(pressure*10, 1); 
  lcd.print("  hPa");
  
  //更新時間（ms）
  delay(200);
}
