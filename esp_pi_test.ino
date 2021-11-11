#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include "DHT.h"

#define DHTTYPE DHT11   
#define DHTPIN D4
#define MOISTPIN A0

//**set network settings**
const char* ssid = "";
const char* networkPassword = "";
const char* mqtt_server = "";

WiFiClient espClient;
PubSubClient client(espClient);

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  dht.begin();
  Serial.begin(9600);

  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, networkPassword);
  
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  
  Serial.print("WiFi connected - ESP IP address: ");
  Serial.println(WiFi.localIP());
  client.setServer(mqtt_server, 1883);

}

void loop() {

  if (!client.connected()) {
    while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");

    if (client.connect("ESP8266Client")) {
      Serial.println("connected");  
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
   }
 }
  if(!client.loop())
    client.connect("ESP8266Client");

  delay(5000);
  
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  int m = analogRead(MOISTPIN);
  
  static char temperatureTemp[6];
  static char humidityTemp[6];
  static char moistTemp[6];
  
  dtostrf(t, 5, 1, temperatureTemp);
  dtostrf(h, 5, 1, humidityTemp);
  itoa(m, moistTemp, 10);

  client.publish("home/temp", temperatureTemp);
  client.publish("home/hum", humidityTemp);
  client.publish("home/moist", moistTemp);
  
  Serial.print("Humidity: ");
  Serial.println(h);
  Serial.print("Temperature: ");
  Serial.println(t);
  Serial.print("Moist = ");
  Serial.println(m);    
}
