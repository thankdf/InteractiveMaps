<?php

require(dirname(__FILE__) . '/Connect.php');
require(dirname(__FILE__) . '/MySQL.php');

$mysql = new MySQL();
$mysql -> openConnection();

$boothID = 258;
$booth_info = "This is Skeye, a map framework!";
$booth_name = "Skeye";
$booth_abbrev = "SK";
$start_time = "1:00 PM";
$end_time = "4:00 PM";

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
