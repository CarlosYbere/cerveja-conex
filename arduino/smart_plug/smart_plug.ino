
const int sensorIn = A0;
int mVperAmp = 66; // use 100 for 20A Module and 66 for 30A Module
double Voltage = 0;
double VRMS = 0;
double AmpsRMS = 0;
double Pot = 0;
boolean IN1 = true;
boolean IN2 = true;


byte byteRead;

//SoftwareSerial mySerial(10, 11); // RX, TX


void setup(){ 
  
  Serial.begin(115200);
  
  delay(1000);
  
  pinMode(6,OUTPUT); // Rele IN1
  pinMode(7,OUTPUT); // Rele IN2
}

void loop(){

    /*  check if data has been sent from the computer: */
  while (Serial.available()) {
    /* read the most recent byte */
    delay(10);
    byteRead = Serial.read();
    
    //Serial.write (byteRead);

    switch(byteRead)
    {
    case 'n': //IN1
      if (IN1){
        IN1 = false;
        digitalWrite(6, 1);
      }
      else{
        IN1 = true;
        digitalWrite(6, 0);
      }
      break;
    
    case 'm': //IN2
      if (IN2){
        IN2 = false;
        digitalWrite(7, 1);
      }
      else{
        IN2 = true;
        digitalWrite(7, 0);
      }
      break; 
    
    }
  }

  
  Voltage = getVPP();
  VRMS = (Voltage/2.0) *0.707; 
  AmpsRMS = (VRMS * 1000)/mVperAmp;
  AmpsRMS = AmpsRMS - 0.06;

  if( AmpsRMS < 0){
    AmpsRMS = 0;
  }

  Pot = 120 * AmpsRMS;

  //Serial.print(AmpsRMS);
  //Serial.println(" Amps RMS");
  //Serial.print(Pot);
  //Serial.println(" W");
  //Serial.print(24*Pot/1000);
  //Serial.println(" kWh/dia");
  //Serial.print("Conta de luz: ");
  //Serial.print((24*Pot/1000)*30); 
  //Serial.print(" kWh/mes  ");
  //Serial.print("R$");
  //Serial.print((24*Pot/1000)*30*0.54346);
  //Serial.println("/mes");

  Serial.print("<SerialArduino>");
  Serial.print("<Amp>");
  Serial.print(AmpsRMS);
  Serial.print("</Amp>");

  Serial.print("<Pot>");
  Serial.print(Pot);
  Serial.print("</Pot>");

  Serial.print("<KWhdia>");
  Serial.print(24*Pot/1000);
  Serial.print("</KWhdia>");

  Serial.print("<KWhmes>");
  Serial.print((24*Pot/1000)*30);
  Serial.print("</KWhmes>");

  Serial.print("<Conta>");
  Serial.print((24*Pot/1000)*30*0.54346);
  Serial.print("</Conta>");
  
  Serial.print("<IN1>");
  Serial.print(IN1);
  Serial.print("</IN1>");
  
  Serial.print("<IN2>");
  Serial.print(IN2);
  Serial.print("</IN2>");
  
  Serial.println("</SerialArduino>");
  
  Serial.flush();
  
  
  //Serial.print(Pot);
  //Serial.println(" W");
  //Serial.print(24*Pot/1000);
  //Serial.println(" kWh/dia");
  //Serial.print("Conta de luz: ");
  //Serial.print((24*Pot/1000)*30); 
  //Serial.print(" kWh/mes  ");
  //Serial.print("R$");
  //Serial.print((24*Pot/1000)*30*0.54346);
  //Serial.println("/mes");
    

}
// if (byteRead == "Off"){
// digitalWrite(7,1);
// digitalWrite(6,1);
//}


float getVPP()
{
  float result;

  int readValue;             //value read from the sensor
  int maxValue = 0;          // store max value here
  int minValue = 1024;          // store min value here

  uint32_t start_time = millis();
  while((millis()-start_time) < 1000) //sample for 2 Sec
  {
    readValue = analogRead(sensorIn);
    // see if you have a new maxValue
    if (readValue > maxValue) 
    {
      /*record the maximum sensor value*/
      maxValue = readValue;
    }
    if (readValue < minValue) 
    {
      /*record the maximum sensor value*/
      minValue = readValue;
    }
  }

  // Subtract min from max
  result = ((maxValue - minValue) * 5.0)/1024.0;

  return result;
}

