<?php
 

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mysql = new MySQL();
	$mysql -> openConnection();

	$searchWord = "SJSU";
    
    $returnValue = array();
    
   
	$search_event = $mysql -> searchResults($searchWord);
	if(!empty($search_event))
	{

		$returnValue["event_name"] = $search_event["event_name"];
		$returnValue["status"] = "Success";
		$returnValue["username"] = $search_event["username"];
		echo json_encode($returnValue);

	}
	
	$mysql -> closeConnection();

?>

