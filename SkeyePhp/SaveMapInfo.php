 <?php

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$event_id = htmlentities($_POST["event_id"]);
	$address_id = htmlentities($_POST["address_id"]);
	$event_name = htmlentities($_POST["event_name"]);
	$street_address = htmlentities($_POST["street_address"]);
	$city = htmlentities($_POST["city"]);
	$state = htmlentities($_POST["state"]);
	$zipcode = htmlentities($_POST["zipcode"]);
	$startDate = htmlentities($_POST["start_date"]);
	$endDate = htmlentities($_POST["end_date"]);
	$startTime = htmlentities($_POST["start_time"]);
	$endTime = htmlentities($_POST["end_time"]);
	$username = htmlentities($_POST["username"]);

	$mysql = new MySQL();
	$mysql -> openConnection();

	$returnValue = array();

	if($event_id == 0)
	{
		$sql = "insert into address set street_address = '".$street_address."', city = '".$city."', state = '".$state."', zipcode = '".$zipcode."'";
		$statement = $mysql -> getConnection() -> prepare($sql);
		if(!$statement)
		{
			throw new Exception($statement -> error);
		}
		$result = $statement->execute();
		if($result != null)
		{
			$last_inserted = mysqli_insert_id($mysql -> getConnection());
			$sql = "insert into events set event_name = '".$event_name."', start_date = '".$startDate."', end_date = '".$endDate."', start_time = '".$startTime."', end_time = '".$endTime."', username = '".$username."', address_id = " . $last_inserted;
			$statement = $mysql -> getConnection() -> prepare($sql);
			if(!$statement)
			{
				throw new Exception($statement -> error);
			}
			$result = $statement->execute();
			if($result != null)
			{
				$returnValue["status"] = "success";
				$returnValue["message"] = "Created map successfully.";
				$returnValue["mapID"] = mysqli_insert_id($mysql -> getConnection());
				echo(json_encode($returnValue));
			}
			else
			{
				$returnValue["status"] = "error";
				$returnValue["message"] = "Was not able to create map.";
				echo(json_encode($returnValue));
			}
		}
	}
	else if($event_id != 0)
	{
		$sql = "update events set event_name = '".$event_name."', start_date = '".$startDate."', end_date = '".$endDate."', start_time = '".$startTime."', end_time = '".$endTime."' where event_id = " . $event_id;
		$statement = $mysql -> getConnection() -> prepare($sql);
		if(!$statement)
		{
			throw new Exception($statement -> error);
		}
		$result = $statement->execute();
		if($result != null)
		{
			$sql = "update address set street_address = '".$street_address."', city = '".$city."', state = '".$state."', zipcode = '".$zipcode."' where address_id = '" . $address_id. "'";
			$statement = $mysql -> getConnection() -> prepare($sql);
			if(!$statement)
			{
				throw new Exception($statement -> error);
			}
			$result = $statement->execute();
			if($result != null)
			{
				$returnValue["status"] = "success";
				$returnValue["message"] = "Updated map info successfully.";
				echo(json_encode($returnValue));
			}
			else
			{
				$returnValue["status"] = "error";
				$returnValue["message"] = "Was not able to update map.";
				echo(json_encode($returnValue));
			}
		}
	}

	$mysql -> closeConnection();
?>