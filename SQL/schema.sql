-- Creating Tables
-- Table - esp8266
-- Stores infomration about a given esp module. 
CREATE TABLE esp8266 (
    esp_id INT NOT NULL IDENTITY(1,1),
    esp_name VARCHAR(128) NOT NULL,
    description VARCHAR(256),
    CONSTRAINT pk_esp8266 PRIMARY KEY (esp_id)
);

-- Table - sensor_type
-- Stores information about a type of sensor 
-- Ex: type_name: "Soil Moisture" description: "Measures the moisture level in the soil"
CREATE TABLE sensor_type (
    sensor_type_id INT NOT NULL IDENTITY(1,1),
    type_name varchar(128) NOT NULL,
    description VARCHAR(256),
    CONSTRAINT pk_sensor_type PRIMARY KEY (sensor_type_id)
);

-- Table - sensor
-- Stores information about a single sensor
CREATE TABLE sensor (
    sensor_id INT NOT NULL IDENTITY(1,1),
    esp_id INT NOT NULL,
    sensor_type_id INT NOT NULL,
    CONSTRAINT pk_sensor PRIMARY KEY (sensor_id),
    CONSTRAINT fk_esp8266 FOREIGN KEY (esp_id) REFERENCES esp8266(esp_id),
    CONSTRAINT fk_sensor_type FOREIGN KEY (sensor_type_id) REFERENCES sensor_type(sensor_type_id)
);

-- Table - sensor_reading
-- Stores one reading for a sensor
CREATE TABLE sensor_reading (
    sensor_reading_id INT NOT NULL IDENTITY(1,1),
    sensor_id INT NOT NULL,
    reading_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reading FLOAT NOT NULL,
    CONSTRAINT pk_sensor_reading PRIMARY KEY (sensor_reading_id),
    CONSTRAINT fk_sensor FOREIGN KEY (sensor_id) REFERENCES sensor(sensor_id)
);

-- Creating Views
-- View - hourly_reading
-- Stores that average reading over a given hour for a given sensor
CREATE VIEW hourly_reading AS
    SELECT sensor_id,
        CONVERT(date, reading_time) AS reading_date,
        DATEPART(hh, reading_time) AS reading_hour,
        AVG(reading) AS avg_reading
    FROM sensor_reading
    GROUP BY CONVERT(date, reading_time), DATEPART(hh, reading_time), sensor_id;

-- View - daily_reading
-- Calculates the average reading over a given day for a sensor
CREATE VIEW daily_reading AS
    SELECT sensor_id, 
        CONVERT(date, reading_time) AS reading_date, 
        AVG(reading) as avg_reading
    FROM sensor_reading
    GROUP BY CONVERT(date, reading_time), sensor_id;