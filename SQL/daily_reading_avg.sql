CREATE EVENT daily_reading_avg
	ON SCHEDULE EVERY 1 DAY
    STARTS DATE_FORMAT(CURRENT_TIMESTAMP + INTERVAL 1 DAY, "%Y-%m-%d 00:00:01")
DO
INSERT INTO daily_reading (sensor_id, reading_date, average_reading) 
SELECT 
	sensor_id,
    cast(reading_time as date) as reading_date,
    AVG(reading)
FROM sensor_reading 
WHERE cast(reading_time as date) = cast(date_sub(current_timestamp(), INTERVAL 1 DAY) as date) 
GROUP BY reading_date, sensor_id;