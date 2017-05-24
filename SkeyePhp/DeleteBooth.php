<?php

require(dirname(__FILE__) . '/Connect.php');
require(dirname(__FILE__) . '/MySQL.php');

$mysql = new MySQL();
$mysql -> openConnection();

$boothID = htmlentities($_POST["boothID"]);

$returnValue = array();

$sql = "delete from booth where booth_id = " . $boothID;
$result = $mysql -> getConnection() -> query($sql);

if($result == 1)
{
$returnValue["status"] = "success";
$returnValue["message"] = "Requested booth is deleted.";
echo json_encode($returnValue);
} 
else 
{
$returnValue["status"] = "error";
$returnValue["message"] = "Was not able to delete booth.";
echo json_encode($returnValue);
}

$mysql -> closeConnection();

?>
