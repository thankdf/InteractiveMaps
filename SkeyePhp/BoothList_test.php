<?php
 

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mysql = new MySQL();
	$mysql -> openConnection();

	$searchWord = "ken@gmail.com";
    
    $returnValue = array();
   
	$sql = "select * from events join booth on events.event_id = booth.event_id where booth.username = '".$searchWord."'";
    
	$result = $mysql -> getConnection() -> query($sql);
	if($result != null)
	{
		for($x = 0; $x < mysqli_num_rows($result); $x++)
		{
			$row = $result -> fetch_array(MYSQLI_ASSOC);
			$returnValue[$x] = $row;
		}
	}
	echo json_encode($returnValue);
	
	$mysql -> closeConnection();

?>