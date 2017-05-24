<?php

	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	 $mysql = new MySQL();
	 $mysql -> openConnection();

    $boothID = htmlentities($_POST["booth_id"]);
    $returnValue = array();

		//$sql = "select * from review where booth_id = ".$boothID;
		$sql = "select review_id, booth_id, review, date, first_name, last_name  from user, review where user.username = review.username
						and booth_id = ".$boothID;

	  $review = $mysql -> getConnection() -> query($sql);


		if($review != null)
		{
					$row = array();
					for($x = 0; $x < mysqli_num_rows($review); $x++)
					{
						$row[$x] = $review -> fetch_array(MYSQLI_ASSOC);
					}
					$returnValue["status"] = "success";
					$returnValue["reviews"] = $row;
		}
		else
		{
					$returnValue["status"] = "error";
					$returnValue["message"] = "Was not able to retrieve Review detail";
		}

		echo json_encode($returnValue);

	$mysql -> closeConnection();

?>
