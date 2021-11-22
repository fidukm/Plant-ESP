#include <Wire.h>
#include <DHT.h>
#include <BH1750.h>

//type of DHT sensor
#define DHTTYPE DHT11

//pin that DHT sensor is connected to
#define DHTPIN D3

//pin that moisture sensor is connected to
#define MOISTPIN A0

//set DHT sensor settings
DHT dht(DHTPIN, DHTTYPE);
BH1750 lightMeter; //SCL into D1, SDA into D2

void setup() {
  //start collecting from dht sensor
  dht.begin();
  lightMeter.begin();
  
  Serial.begin(9600);
  Serial.println();
  Serial.println("Status\t\tHumidity (%)\t\tTemperature (C)\t\tMoisture (?)\t\tLight (LUX)");
}

void loop() {
  //collect sensor data every 5 second
  delay(5000);
  
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  float m = analogRead(MOISTPIN);
  int l = lightMeter.readLightLevel();
  
  Serial.print("Temperature = ");
  Serial.println(t);
  Serial.print("Humidity = ");
  Serial.println(h);
  Serial.print("Moisture = ");
  Serial.println(m);
  Serial.print("Light: ");
  Serial.println(l);
}
