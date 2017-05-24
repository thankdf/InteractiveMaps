<?php
 

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mysql = new MySQL();
	$mysql -> openConnection();

	$searchWord = htmlentities($_POST["searchWord"]);
    
    $returnValue = array();
   
	$sql = "select * from events join address on events.address_id=address.address_id where events.event_name like '%".$searchWord."%'";
    
	$result = $mysql -> getConnection() -> query($sql);
	if($result != null)
	{
		$max = 10;
		if(mysqli_num_rows($result) < 10)
		{
			$max = mysqli_num_rows($result);
		}
		for($x = 0; $x < $max; $x++)
		{
			$row = $result -> fetch_array(MYSQLI_ASSOC);
			$returnValue[$x] = $row;
		}
	}
	echo json_encode($returnValue);
	
	$mysql -> closeConnection();

?>
