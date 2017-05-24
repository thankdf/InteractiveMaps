<?php
 

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mysql = new MySQL();
	$mysql -> openConnection();

	$searchWord = htmlentities($_POST["searchWord"]);
    
    $returnValue = array();
   
	$sql = "select * from events where event_name like '%".$searchWord."%'";
    
	$result = $mysql -> getConnection() -> query($sql);
	if($result != null)
	{
		$row = $result -> fetch_array(MYSQLI_ASSOC);
		if(!empty($row))
		{
			$search_event = $row;
			echo json_encode($search_event);
		}
	}
	
	$mysql -> closeConnection();

?>