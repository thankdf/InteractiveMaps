<?php

class MySQL
{
	var $host = null;
	var $user = null;
	var $pass = null;
	var $connection = null;
	var $database = null;
	var $result = null;

	function __construct()
	{
		$this -> host = Connect::$host;
		$this -> user = Connect::$user;
		$this -> pass = Connect::$pass;
		$this -> database = Connect::$database;
	}

	public function openConnection()
	{
		$this -> connection = new mysqli($this -> host, $this -> user, $this -> pass, $this -> database);
		if(mysqli_connect_errno())
		{
			echo new Exception("Could not establish connection with database");
		}
	}

	public function getConnection()
	{
		return $this -> connection;
	}

	public function closeConnection() 
	{
		if ($this->connection != null)
		{
			$this->connection->close();
		}
	}

	public function getUserDetails($email)
	{
		$returnValue = array();
		$sql = "select * from user where username = '".$email."'";
		$result = $this -> connection -> query($sql);
		if(!empty($result) && (mysqli_num_rows($result) >= 1))
		{
			$row = $result -> fetch_array(MYSQLI_ASSOC);
			if(!empty($row))
			{
				$returnValue = $row;
			}
		}
		return $returnValue;
	}

	public function getUserDetailsWithPassword($email, $password)
	{
		$returnValue = array();
		$sql = "select * from user where username ='".$email."' and password ='".$password."'";
		$result = $this -> connection -> query($sql);
		if($result != null && (mysqli_num_rows($result) == 1))
		{
			$row = $result -> fetch_array(MYSQLI_ASSOC);
			if(!empty($row))
			{
				$returnValue = $row;
			}
		}
		return $returnValue;
	}

	public function registerUser($email, $password, $first_name, $last_name, $permissions)
	{
		$sql = "insert into user set username=?, password=?, first_name=?, last_name=?, permissions=?";
		$statement = $this-> connection ->prepare($sql);

		if (!$statement)
		{
			throw new Exception($statement->error);
		}

		$statement->bind_param("ssssi", $email, $password, $first_name, $last_name, $permissions);
		$returnValue = $statement->execute();

		return $returnValue;
	}
	
	public function saveMap($mapID, $user)
	{
		$sql = "select * from events where event_id = '".$mapID."'";
		$result = $this -> connection-> query($sql);
		if(empty($result))
		{
			$sql2 = "insert into events set username = '".$user."'";
			$statement = $this -> connection -> prepare($sql);
			if(!$statement)
			{
				throw new Exception($statement -> error);
			}				
			$returnValue = $statement -> execute();
		}
		else
		{
			$sql2 = "update events set hours =  where event_id = '".$mapID."'";
			$statement = $this -> connection -> prepare($sql);
			if(!$statement)
			{
				throw new Exception($statement -> error);
			}
			$returnValue = $statement -> execute();
		}
		return $returnValue;
	}

	public function saveBooths($booths)
	{
		foreach($booths as $key => $value)
		{
			$sql = "select * from booth where booth_id = ".$key."";
			$result = $this -> connection-> query($sql);
			if($result == nil || mysqli_num_rows($result) < 1)
			{
				$sql2 = "insert into booth set booth_id = ".$key.", username = '".$value["username"]."', location_x = ".$value["location_x"].", location_y = ".$value["location_y"].", width = ".$value["width"].", height = ".$value["height"].", shape = '".$value["shape"]."', color = '".$value["color"]."'";
				$statement = $this -> connection -> prepare($sql2);
				if(!$statement)
				{
					throw new Exception($statement -> error);
				}
				$statement->bind_param("isffffss", $key, $value["username"], $value["location_x"], $value["location_y"], $value["width"], $value["height"], $value["shape"], $value["color"]);
				$returnValue = $statement -> execute();
			}
			else
			{
				$sql2 = "update booth set username = '".$value["username"]."', location_x = ".$value["location_x"].", location_y = ".$value["location_y"].", width = ".$value["width"].", height = ".$value["height"].", shape = '".$value["shape"]."', color = '".$value["color"]."' where booth_id = ".$key."";
				$statement = $this -> connection -> prepare($sql2);
				if(!$statement)
				{
					throw new Exception($statement -> error);
				}
				$statement->bind_param("sffffssi", $value["username"], $value["location_x"], $value["location_y"], $value["width"], $value["height"], $value["shape"], $value["color"], $key);
				$returnValue = $statement -> execute();
			}
		}
		return $returnValue;
	}
}

?>