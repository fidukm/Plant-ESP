<?php
    $serverName = "fall2021iot.database.windows.net";
    $connectionOptions = array (
        "database" => "NonProductionESPTelemetry",
        "uid" => "Replace With Username",
        "pwd" => "Replace With Password"
    );

    $conn = sqlsrv_connect($serverName, $connectionOptions);
    if ($conn === false) {
        echo "Could not connect.\n";
        die(print_r(sqlsrv_errors(), true));
    }

    /* Set up and execute the query. */
    $sql = "SELECT * FROM sensor_reading;";
    $stmt = sqlsrv_query($conn, $sql);

    # Create CSV to download
    header("Content-type: text/x-csv");
    header("Content-Disposition: attachment; filename=testcsv.csv");

    # Write all readings to csv
    echo "sensor_reading_id,sensor_id,reading_time,reading\n";
    while ($result = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) 
    {
        print_r($result["sensor_reading_id"].",".$result["sensor_id"].","
            .$result["reading_time"]->format('Y-m-d H:i:s')
            .",".$result["reading"].",\n");
    }

    sqlsrv_free_stmt($stmt);
    sqlsrv_close($conn);

?>