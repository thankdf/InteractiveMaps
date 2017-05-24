<?php


	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	 $mysql = new MySQL();
	 $mysql -> openConnection();

    $reviewID = htmlentities($_POST["review_id"]);

		$returnValue = array();

		$sql = "delete from review where review_id = ".$reviewID;

		$returnValue["sql"] = $sql;

	$result = $mysql -> getConnection() -> query($sql);

 if(!empty($result))
 {
 	if(!$result)
 	{
 		$returnValue["status"] = "error";
 		$returnValue["message"] = "Review not successfully deleted.";
 	}
 	else
 	{
 		$returnValue["status"] = "success";
 		$returnValue["message"] = "Review is successfully deleted.";

	}
 }
 echo json_encode($returnValue);

	$mysql -> closeConnection();

?>
