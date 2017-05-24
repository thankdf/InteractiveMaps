<?php
	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');
	
	$json = json_decode(file_get_contents('php://input'), true);
	$id = htmlentities($json["mapID"]);
	$user = htmlentities($json["user"]);
	$booths = $json["booths"];
	$mysql = new MySQL();
	$mysql -> openConnection();

	if(!empty($user))
	{
		$result = $mysql -> saveMap($id, $user);
		if(!$result)
		{
			$returnValue["status"] = "error";
			$returnValue["message"] = "Map not successfully saved.";
			echo json_encode($returnValue);
		}
		else
		{
			if(!empty($booths))
			{
				$result = $mysql -> saveBooths($booths);
				if(!$result)
				{
					$returnValue["status"] = "error";
					$returnValue["message"] = "Booths not successfully saved.";
					echo json_encode($returnValue);
				}
				else
				{
					$returnValue["status"] = "success";
					$returnValue["message"] = "Map and booths are successfully saved.";
					echo json_encode($returnValue);
				}
			}
		}
	}

	$mysql -> closeConnection();
?>