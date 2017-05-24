<?php

require(dirname(__FILE__) . '/Connect.php');
require(dirname(__FILE__) . '/MySQL.php');

$mysql = new MySQL();
$mysql -> openConnection();

$boothID = htmlentities($_POST["boothID"]);
$booth_info = htmlentities($_POST["booth_info"]);
$booth_name = htmlentities($_POST["booth_name"]);
$booth_abbrev = htmlentities($_POST["booth_abbrev"]);
$start_time = htmlentities($_POST["start_time"]);
$end_time = htmlentities($_POST["end_time"]);

$sql = "update booth set booth_info = '".$booth_info."', booth_name = '".$booth_name."', booth_abbrev = '".$booth_abbrev."', start_time = '".$start_time."', end_time = '".$end_time."' where booth_id = " . $boothID;
$statement = $mysql -> getConnection() -> prepare($sql);
if(!$statement)
{
	throw new Exception($statement -> error);
}
$result = $statement->execute();
if($result != 0)
{
	$returnValue["status"] = "success";
	$returnValue["message"] = "Updated booth successfully.";		
	echo json_encode($returnValue);
}

$mysql -> closeConnection();

?>
