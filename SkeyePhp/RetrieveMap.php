<?php

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mysql = new MySQL();
	$mysql -> openConnection();
	$map = htmlentities($_POST["eventID"]);
	$returnValue = array();

	$sql = "select * from events where event_id = " . $map;
	$result = $mysql -> getConnection() -> query($sql);
	if($result != null)
	{
		if(mysqli_num_rows($result) > 1)
		{
			throw new Exception("More than one event in the database with the same ID. Please take a look at the data again.");
		}
		else
		{
			$row = $result -> fetch_array(MYSQLI_ASSOC);
			if(!empty($row))
			{
				$sql = "select * from booth where event_id = " . $map;
				$result2 = $mysql -> getConnection() -> query($sql);
				if($result2 != null)
				{
					$row2 = array();
					for($x = 0; $x < mysqli_num_rows($result2); $x++)
					{
						$row2[$x] = $result2 -> fetch_array(MYSQLI_ASSOC);
					}
					$returnValue["status"] = "success";
					$returnValue["map"] = $row;
					$returnValue["booths"] = $row2;
				}
				else
				{
					$returnValue["status"] = "error";
					$returnValue["message"] = "Was not able to retrieve booths from the database";
				}
				// $returnValue["booths"] = $result2;
				echo json_encode($returnValue);
			}
		}
	}
	else
	{
		$returnValue["mapID"] = $map;
		$returnValue["status"] = "error2";
		$returnValue["message"] = "Was not able to retrieve map from the database";
		echo json_encode($returnValue);
	}


	$mysql -> closeConnection();
?>
