<?php
	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mapID = htmlentities($_POST["event_id"]);
	$user = htmlentities($_POST["username"]);
	$location_x = htmlentities($_POST["location_x"]);
	$location_y = htmlentities($_POST["location_y"]);
	$width = htmlentities($_POST["width"]);
	$height = htmlentities($_POST["height"]);
	$shape = htmlentities($_POST["shape"]);
	$color = htmlentities($_POST["color"]);
	$returnValue = array();

	$mysql = new MySQL();
	$mysql -> openConnection();
	
	$sql = "insert into booth set username=?, location_x=?, location_y=?, width=?, height=?, shape=?, color=?, event_id=?";
	$statement = $mysql -> getConnection() -> prepare($sql);
	$statement->bind_param("sddddssi", $user, $location_x, $location_y, $width, $height, $shape, $color, $mapID);
	if(!$statement)
	{			
		throw new Exception($statement -> error);
	}
	$result = $statement->execute();
	if($result != 0)
	{
		$returnValue["status"] = "success";
		$returnValue["message"] = mysqli_insert_id($mysql -> getConnection());
		echo json_encode($returnValue);
	}
	else
	{
		$returnValue["status"] = "error";
		$returnValue["message"] = "Was not able to insert booth";
		echo json_encode($returnValue);
	}

	$mysql -> closeConnection();
?>