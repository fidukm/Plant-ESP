CREATE DEFINER=`root`@`localhost` PROCEDURE `populate_db`()
BEGIN
insert into esp8266 (esp_name, description) values('test-esp', 'test esp entry');
SET @esp_fk = LAST_INSERT_ID();

insert into sensor_type (type_name, description) values('temperature', 'temperature sensor');
SET @temp_sensor_type_id = LAST_INSERT_ID();
insert into sensor SET esp_id=@esp_fk, sensor_type_id=@temp_sensor_type_id;
SET @temp_sensor_id = LAST_INSERT_ID();

insert into sensor_type SET type_name='humidity', description='humidity sensor';
SET @humidity_sensor_type_id = LAST_INSERT_ID();
insert into sensor SET esp_id=@esp_fk, sensor_type_id=@humidity_sensor_type_id;
SET @humidity_sensor_id = LAST_INSERT_ID();

insert into sensor_type SET type_name='sunlight', description='sunlight sensor';
SET @sun_sensor_type_id = LAST_INSERT_ID();
insert into sensor SET esp_id=@esp_fk, sensor_type_id=@sun_sensor_type_id;
SET @sun_sensor_id = LAST_INSERT_ID();

insert into sensor_type SET type_name='moisture', description='moisture sensor';
SET @moisture_sensor_type_id = LAST_INSERT_ID();
insert into sensor SET esp_id=@esp_fk, sensor_type_id=@moisture_sensor_type_id;
SET @moisture_sensor_id = LAST_INSERT_ID();

SET @first_quarter = TIMESTAMP("2021-01-01",  "1:00:00");
SET @second_quarter = TIMESTAMP("2021-04-01",  "1:00:00");
SET @third_quarter = TIMESTAMP("2021-07-01",  "1:00:00");

SET @moisture_value_first = 512;
SET @moisture_value_second = 512;
SET @moisture_value_third = 512;

SET @temp_value_first=rand_helper(8,11);
SET @temp_value_second=rand_helper(15,20);
SET @temp_value_third=rand_helper(22,25);

SET @x = 85*12;

for_loop: LOOP
    IF @x > 0 THEN
    
    SET @moisture_value_first = @moisture_value_first *(((-1+2*(rand()))*0.005)+1);
    SET @temp_value_first = @temp_value_first * (((-1+2*(rand()))*0.01)+1);
    insert into sensor_reading SET sensor_id=@temp_sensor_id, reading_time=@first_quarter, reading=@temp_value_first;
    insert into sensor_reading SET sensor_id=@humidity_sensor_id, reading_time=@first_quarter, reading=rand_helper(10, 90);
    insert into sensor_reading SET sensor_id=@sun_sensor_id, reading_time=@first_quarter, reading=rand_helper(20, 100);
    insert into sensor_reading SET sensor_id=@moisture_sensor_id, reading_time=@first_quarter, reading=@moisture_value_first;
    SET @first_quarter = ADDTIME(@first_quarter, "2:00:00");
    
    SET @moisture_value_second = @moisture_value_second *(((-1+2*(rand()))*0.005)+1);
    SET @temp_value_second = @temp_value_second * (((-1+2*(rand()))*0.01)+1);
    insert into sensor_reading SET sensor_id=@temp_sensor_id, reading_time=@second_quarter, reading=@temp_value_second;
    insert into sensor_reading SET sensor_id=@humidity_sensor_id, reading_time=@second_quarter, reading=rand_helper(10, 90);
    insert into sensor_reading SET sensor_id=@sun_sensor_id, reading_time=@second_quarter, reading=rand_helper(20, 100);
    insert into sensor_reading SET sensor_id=@moisture_sensor_id, reading_time=@second_quarter, reading=@moisture_value_second;
    SET @second_quarter = ADDTIME(@second_quarter, "2:00:00");
    
    SET @moisture_value_third = @moisture_value_third *(((-1+2*(rand()))*0.005)+1);
    SET @temp_value_third = @temp_value_third * (((-1+2*(rand()))*0.01)+1);
    insert into sensor_reading SET sensor_id=@temp_sensor_id, reading_time=@third_quarter, reading=@temp_value_third;
    insert into sensor_reading SET sensor_id=@humidity_sensor_id, reading_time=@third_quarter, reading=rand_helper(10, 90);
    insert into sensor_reading SET sensor_id=@sun_sensor_id, reading_time=@third_quarter, reading=rand_helper(20, 100);
    insert into sensor_reading SET sensor_id=@moisture_sensor_id, reading_time=@third_quarter, reading=@moisture_value_third;
    SET @third_quarter = ADDTIME(@third_quarter, "2:00:00");
    
    ELSE
    LEAVE for_loop;
    
    END IF;
    
    SET @x = @x - 1;
END LOOP for_loop;

END