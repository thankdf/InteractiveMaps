<?php
	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$email = htmlentities($_POST["email"]);
	$password = htmlentities($_POST["password"]);
	$first_name = htmlentities($_POST["first_name"]);
	$last_name = htmlentities($_POST["last_name"]);
	$permissions = htmlentities($_POST["permissions"]);
	$returnValue = array();
	if(!empty($email) && !empty($password) && !empty($first_name) && !empty($last_name) && !empty($permissions))
	{
		$mysql = new MySQL();
		$mysql -> openConnection();
		$emailCheck = $mysql -> getUserDetails($email);
		if(!empty($emailCheck))
		{
			$returnValue["status"] = "error";
			$returnValue["message"] = "User already exists.";
			echo json_encode($returnValue);
			return;
		}

		$secure_password = md5($password); //encryption using MD5
		$result = $mysql -> registerUser($email, $secure_password, $first_name, $last_name, $permissions);

		if($result)
		{
			$returnValue["status"] = "success";
			$returnValue["message"] = "User is successfully registered.";
			echo json_encode($returnValue);
			return;
		}
		else
		{
			$returnValue["status"] = "error";
			$returnValue["message"] = "Not able to register user successfully.";
			echo json_encode($returnValue);
			return;
		}
		$mysql -> closeConnection();
	}
?>