<?php

require(dirname(__FILE__) . '/Connect.php');
require(dirname(__FILE__) . '/MySQL.php');

$mysql = new MySQL();
$mysql -> openConnection();

$email = htmlentities($_POST["email"]);
$password = htmlentities($_POST["password"]);

$returnValue = array();

$secure_password = md5($password);

$userDetails = $mysql -> getUserDetailsWithPassword($email,$secure_password);

if(!empty($userDetails))
{
$returnValue["status"] = "success";
$returnValue["user"] = $email;
$returnValue["usertype"] = $userDetails["permissions"];
$returnValue["first_name"] = $userDetails["first_name"];
$returnValue["last_name"] = $userDetails["last_name"];
$returnValue["message"] = "'".$email."' is logged in.";
echo json_encode($returnValue);
} 
else 
{
$returnValue["status"] = "error";
$returnValue["message"] = "Incorrect username/password combination.";
echo json_encode($returnValue);
}

$mysql -> closeConnection();

?>
