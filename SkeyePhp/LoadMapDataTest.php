<?php

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mysql = new MySQL();
	$mysql -> openConnection();
	$map = 1;
	$returnValue = array();

	$sql = "select * from events where event_id = " . $map;
	$result = $mysql -> getConnection() -> query($sql);
	if($result != null  && (mysqli_num_rows($result) == 1))
	{
		$row = $result -> fetch_array(MYSQLI_ASSOC);
		if(!empty($row))
		{
			$sql = "select * from address where address_id = " . $row["address_id"];
			$result = $mysql -> getConnection() -> query($sql);
			if($result != null  && (mysqli_num_rows($result) == 1))
			{
				$row2 = $result -> fetch_array(MYSQLI_ASSOC);
				if(!empty($row))
				{
					$returnValue["status"] = "success";
					$returnValue["map"] = $row;
					$returnValue["address"] = $row2;
					echo(json_encode($returnValue));
				}
			}
		}
	}

	$mysql -> closeConnection();
?>