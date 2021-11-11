#include <DHT.h>

#define DHTTYPE DHT11
#define DHTPIN D4
#define MOISTPIN A0

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  // put your setup code here, to run once:
  dht.begin();
  Serial.begin(9600);
  Serial.println();
  Serial.println("Status\t\tHumidity (%)\t\tTemperature (C)\t\tMoisture (?)\t");

}

void loop() {
  // put your main code here, to run repeatedly:
  delay(5000);
  
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  int m = analogRead(MOISTPIN);
  
  Serial.print("Temperature = ");
  Serial.println(t);
  Serial.print("Humidity = ");
  Serial.println(h);
  Serial.print("Moisture = ");
  Serial.println(m);
}
