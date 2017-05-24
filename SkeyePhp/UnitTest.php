<?php

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');
	
	$mysql = new MySQL();
	$mysql -> openConnection();

	$array = array("color" => "red", "height" => 25.0, "shape" => "square", "width" => 25.0, "location_x" => 100.100, "username" => "hk.at.dang@gmail.com", "location_y" => 100.100);
	$arrayJSON = json_encode($array);
	$json = array("booths" => array(97 => $arrayJSON), "user" => "hk.at.dang@gmail.com", "mapID"=> 1);
	$id = $json["mapID"];
	$user = $json["user"];
	$booths = $json["booths"];
	
	$returnValue = array();

	$result = $mysql -> saveMap($id, $user);
	if(!$result)
	{
		$returnValue["status"] = "error";
		$returnValue["message"] = "Map not successfully saved.";
		echo json_encode($returnValue);
	}
	else
	{
		$result = $mysql -> saveBooths($booths);
		if(!$result)
		{
			$returnValue["status"] = "error";
			$returnValue["message"] = "Booths not successfully saved.";
		}
		else
		{
			$returnValue["status"] = "success";
			$returnValue["message"] = "Map and booths are successfully saved.";
		}
	}
	echo json_encode($returnValue);

	$mysql -> closeConnection();
?>