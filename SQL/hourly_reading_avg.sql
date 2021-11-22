CREATE EVENT hourly_reading_avg
	ON SCHEDULE EVERY 1 HOUR
    STARTS DATE_FORMAT(CURRENT_TIMESTAMP() + INTERVAL 1 HOUR, "%Y-%m-%d %H:00:01")
DO
INSERT INTO hourly_reading (sensor_id, reading_date, reading_hour, average_reading) 
SELECT 
	sensor_id,
    cast(reading_time as date) as reading_date,
    HOUR(reading_time) AS reading_hour, 
    AVG(reading)
FROM sensor_reading 
WHERE cast(reading_time as date) = cast(date_sub(current_timestamp(), INTERVAL 1 HOUR) as date) 
	AND HOUR(reading_time) = hour(date_sub(current_timestamp(), INTERVAL 1 HOUR))
GROUP BY reading_hour, reading_date, sensor_id;