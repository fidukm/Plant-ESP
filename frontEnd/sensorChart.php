<!DOCTYPE html>
<html>
	<head>
	<title>Sunlight: 24 Hours</title>
	<link rel = "stylesheet" type="text/css" href="style.css">
	<style>
	.chart{
	vertical-align: middle;
	width: auto;
	margin: auto
	}
	</style>
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
	<script src="https://ajax.aspnetcdn.com/ajax/jquery/jquery-1.9.0.js"></script>
	<script type="text/javascript">
		google.charts.load('current', {packages: ['corechart', 'bar']});
		google.charts.setOnLoadCallback(drawChart);
		google.charts.setOnLoadCallback(drawDailyChart);

		<?php 
			echo "sensorID = " . $_POST["sensor_id"] . ";\nsensorName = \"" .$_POST["sensor"] . "\";";
		?>
		var sensorNameCased = sensorName[0].toUpperCase() + sensorName.substring(1);
		
		function drawChart() {


			var tableData = $.ajax({
				type: "POST",
				url: "getSensorData.php",
				dataType: "json",
				data: {"sensor_id": sensorID},
				async: false
			}).responseText;

			var tableData = JSON.parse(tableData);

			console.log(tableData);

			var data = new google.visualization.DataTable();
			data.addColumn('date', 'Time of Day');
			data.addColumn('number', 'Sensor Reading');

			for(var i = 0; i < Object.keys(tableData).length-1; i++){

				reading_time = Object.keys(tableData)[i];

				reading_time_begin = new Date(Object.keys(tableData)[i] * 1000);

				reading_value = tableData[reading_time];

				data.addRows([[ reading_time_begin, reading_value ]]);

			}

			var options = {
				title: 'Most Recent 24 Hours Average ' + sensorNameCased + ' Readings',
				legend: { position: 'none' },
				hAxis: {
					title: 'Time',
					format: 'h:mm a',
				},
				vAxis: {
					title: sensorName + ' Level'
				}
			};

			var materialChart = new google.visualization.LineChart(document.getElementById('chart_div'));
			materialChart.draw(data, options);
		}
		function drawDailyChart() {


			var tableData = $.ajax({
				type: "POST",
				url: "getDailySensorData.php",
				dataType: "json",
				data: {"sensor_id": sensorID},
				async: false
			}).responseText;

			var tableData = JSON.parse(tableData);

			console.log(tableData);

			var data = new google.visualization.DataTable();
			data.addColumn('date', 'Date');
			data.addColumn('number', 'Sensor Reading');

			for(var i = 0; i < Object.keys(tableData).length-1; i++){

				reading_date = Object.keys(tableData)[i];

				reading_date_begin = new Date(new Date(Object.keys(tableData)[i] * 1000).toDateString());

				reading_value = tableData[reading_date];

				data.addRows([[ reading_date_begin, reading_value ]]);

			}
			var options = {
				title: 'Daily Average ' + sensorNameCased + ' Readings',
				legend: { position: 'none' },
				hAxis: {
					title: 'Date',
					format: 'MMM dd',

				},
				vAxis: {
					title: sensorName + ' Level'
				}
			};

			var materialChart = new google.visualization.LineChart(document.getElementById('dailyChart_div'));
			materialChart.draw(data, options);
		}

	</script>
	</head>
	<body class="mainBody">
		<h1 class="header">
			<script>
				document.write(sensorNameCased + ":");
			</script>
			Average Readings</h1>
		<div class="outerBox" style="width: 900px; height: 500px; padding-top: 100px; padding-bottom: 100px;">
			<div class="chart" id="chart_div" style="width: 75%; height: 48%;"></div>
			<div class="chart" id="dailyChart_div" style="width: 75%; height: 48%; padding-top: 25px;"></div>
		</div>
	</body>
</html>