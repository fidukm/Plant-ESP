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

		<?php 
			echo "sensorID = " . $_POST["sensor_id"] . ";\nsensorName = \"" .$_POST["sensor"] . "\";";
		?>

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
				title: 'Most Recent 24 Hours Average ' + sensorName + ' Readings',
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

	</script>
	</head>
	<body class="mainBody">
		<h1 class="header">
			<script>
				document.write(sensorName + ":");
			</script>
			Most Recent 24 Hours Average Readings</h1>
		<div class="outerBox" style="width: 900px; height: 300px; padding-top: 100px; padding-bottom: 100px">
			<div class="chart" id="chart_div" style="width: 700px; height: 300px;"></div>
		</div>
	</body>
</html>