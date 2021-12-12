<?php
	$DatabaseAccess = parse_ini_file('database.ini');
	$serverName = $DatabaseAccess['serverName'];
	$connectionOptions = array (
		"database" => $DatabaseAccess['database'],
		"uid" => $DatabaseAccess['uid'],
		"pwd" => $DatabaseAccess['pwd']
	);
        
	$conn = sqlsrv_connect($serverName, $connectionOptions);
	if ($conn === false) {
		echo "Could not connect.\n";
		die(print_r(sqlsrv_errors(), true));
	}

	/* Set up and execute the query. */
	$sensor_id = $_POST["sensor_id"];
	$sql = "SELECT reading_date, avg_reading
			FROM daily_reading
			WHERE reading_date > DATEADD(DAY, -6, CURRENT_TIMESTAMP) AND reading_date < DATEADD(DAY, 2, CURRENT_TIMESTAMP) AND sensor_id = ? 
			ORDER BY reading_date;";
	$params = array("$sensor_id");
	$stmt = sqlsrv_query($conn, $sql, $params);

	$table_data = array();

	# Loop through all results one row at a time
	while ($result = sqlsrv_fetch_array($stmt, SQLSRV_FETCH_ASSOC)) 
	{
		$reading_date = $result["reading_date"]->format('U');
		$reading_data = $result["avg_reading"];
		$table_data[$reading_date] = $reading_data;
	}

	echo json_encode($table_data);

	sqlsrv_free_stmt($stmt);
	sqlsrv_close($conn);

?>