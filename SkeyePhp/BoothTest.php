<?php
	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mapID = 1;
	$user = "hk.at.dang@gmail.com";
	$location_x = 100;
	$location_y = 100;
	$width = 50;
	$height = 50;
	$shape = "square";
	$color = "white";
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

	$mysql -> closeConnection();
?>