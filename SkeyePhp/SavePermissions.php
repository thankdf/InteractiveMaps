<?php

require(dirname(__FILE__) . '/Connect.php');
require(dirname(__FILE__) . '/MySQL.php');

$mysql = new MySQL();
$mysql -> openConnection();

$newPermissions = htmlentities($_POST["newPermissionsText"]);
$boothID = htmlentities($_POST["boothID"]);

$returnValue = array();

$sql = "update booth set username = '".$newPermissions."' where booth_id = " . $boothID;
$result = $mysql -> getConnection() -> query($sql);
if($result)
{
	$returnValue["status"] = "success";
	$returnValue["message"] = "Booth successfully assigned to '".$newPermissions."'.";
	echo json_encode($returnValue);
}

$mysql -> closeConnection();

?>
