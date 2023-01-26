// Processin側
// https://scrapbox.io/ZawaBlogs/Arduino%E3%81%8B%E3%82%89Processing%E3%81%AB%E8%A4%87%E6%95%B0%E3%81%AEint%E5%9E%8B%E3%83%87%E3%83%BC%E3%82%BF%E3%82%92%E9%80%81%E3%82%8B
// 「ArduinoからProcessingに複数のint型データを送る」を改造
// Arduino-Processing連携によるの圧力センサ指示値の表示
 
 import processing.serial.*;
 Serial myPort;
 
 int []data = new int [1];      //Arduinoから送られてくるデータが1個の場合の設定
 
 // printArray(Serial.list());  //使用できるシリアルポートの番号を調べる際に使う（コメントアウトを外す）
 
 
 void setup() {
   myPort = new Serial(this, Serial.list()[1], 9600);  //シリアルポート関係の出力。Serial.list()[x]のxは環境に合わせて要調整
    size(800, 800); //出力スクリーン解像度の指定
   //日本語フォント使用の設定
   PFont font = createFont("Meiryo", 50);
   textFont(font);
 }
 
 
 void draw(){
   
  background(256,256,256); //背景色は白
  fill(0);                 //文字色は黒
  
  //日本語表示設定
  float pressure_float_Pa = data[0];//Arduinoから送られてきた値を[Pa]のfloat型に変換
  textSize(40);
 
 //圧力の出力
 
    //「測定値」の文字出力
    text("測定値",100,200);
 
    //数値部の出力
    if(pressure_float_Pa > 1000000 )                                {text(pressure_float_Pa/1000000,100,300);}
    if(pressure_float_Pa < 1000000 && pressure_float_Pa > 100000 )  {text(pressure_float_Pa/100000,100,300);}
    if(pressure_float_Pa < 100000 && pressure_float_Pa > 10000 )    {text(pressure_float_Pa/10000,100,300);}
    if(pressure_float_Pa < 10000 && pressure_float_Pa > 1000 )    {text(pressure_float_Pa/1000,100,100);}
    //text(data[1],100,200);  //Arduinoから送信されたint値[1/3]の表示
    //text(data[2],100,300);  //Arduinoから送信されたint値[2/3]の表示
  
    //指数部＋単位（×10^x Pa）の出力
    if(pressure_float_Pa > 1000000 )                               {text("×10⁶  [Pa]",250,300); }
    if(pressure_float_Pa < 1000000 && pressure_float_Pa > 100000 ) {text("×10⁵  [Pa]",250,300); }
    if(pressure_float_Pa < 100000  && pressure_float_Pa > 10000)   {text("×10⁴  [Pa]",250,300); }
    if(pressure_float_Pa < 10000   && pressure_float_Pa > 1000)    {text("×10³  [Pa]",250,300); }    
  
 
 //棒グラフの出力
 rect(100, 500,20+(pressure_float_Pa/1000),20);
 //rect(160,185,20+(data[1]/5),20);
 //rect(160,285,20+(data[2]/5),20);
 
 //大気圧との倍率を出力
 text("大気圧（1.013×10⁵ [Pa]）の",100,600);
 text(pressure_float_Pa/101300,90,650); text("倍",250,650); 
 }
 
 
 //送られてきたデータを処理する関数
  void serialEvent(Serial p) {  
    String inString = myPort.readStringUntil('\n');  // Arduinoから送られたデータ（,区切り・int 3個）の `\n`までを受け取り、String型で保存
 
    if (inString != null) {
      inString = trim(inString);                     // trim()で文字列から改行（`\n`）を削除
      data = int(split(inString, ','));              // split()で`,`で区切られた文字列を配列として抜き出し、各々をint型として保存
      println(data);//受信したデータ配列を参照       // 確認用コンソール出力
    }
  }
