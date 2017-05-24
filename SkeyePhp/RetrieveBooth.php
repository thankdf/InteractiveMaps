<?php

require(dirname(__FILE__) . '/Connect.php');
require(dirname(__FILE__) . '/MySQL.php');

$mysql = new MySQL();
$mysql -> openConnection();

$boothID = htmlentities($_POST["boothID"]);

$returnValue = array();

$sql = "select * from booth where booth_id = " . $boothID;
$result = $mysql -> getConnection() -> query($sql);
if($result != null && (mysqli_num_rows($result) == 1))
{
	$row = $result -> fetch_array(MYSQLI_ASSOC);
	if($row != null)
	{
		$returnValue["status"] = "success";
		$returnValue["booth"] = $row;		
		echo json_encode($returnValue);
	}
}

$mysql -> closeConnection();

?>
