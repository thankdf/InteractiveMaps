<?php
	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	$mysql = new MySQL();
	$mysql -> openConnection();

	if($mysql)
	{
		echo("Success");
	}
    
    echo("Test today is successful!!!");
?>
