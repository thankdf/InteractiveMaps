<?php


	require(dirname(__FILE__) . '/Connect.php');
	require(dirname(__FILE__) . '/MySQL.php');

	 	$mysql = new MySQL();
	 	$mysql -> openConnection();

	 	$returnValue = array();
    $boothID = htmlentities($_POST["booth_id"]);
		$reviewText = htmlentities($_POST["review"]);
		$date = htmlentities($_POST["date"]);

		$username = htmlentities($_POST["username"]);


		//$sql = "insert into review set booth_id = 187, review = 'mehhh', date = '2017.4.3', username = 'yoho@gmail.com'";
		$sql = "insert into review set booth_id = ".$boothID.", review = '".$reviewText."', date = '".$date."', username = '".$username."'";
		$result = $mysql -> getConnection() -> query($sql);

		//to get the latest genearated ID
	$new_review_id = mysqli_insert_id($mysql -> getConnection());


	//save image into reviewImage table
	if(isset($_POST['img1']))
	{
			$returnValue["enterImage1"] = "Yes, it did enter 1 ";
			$img1 = htmlentities($_POST["img1"]);
			//$sqlImage = "insert into reviewImage set review_id = ".$new_review_id.", image = ".$img1;
			$sqlImage = "insert into reviewImage set review_id = ".$new_review_id.", image = '".$img1."'";
			$inserResult = $mysql -> getConnection() -> query($sqlImage);
			$returnValue["insertQuery"] = $sqlImage;
			$returnValue["insertResult"] = $inserResult;
	}
	if(isset($_POST['img2']))
	{
			$returnValue["enterImage2"] = "Yes, it did enter 2 ";
			$img2 = htmlentities($_POST["img2"]);
	}
	if(isset($_POST['img3']))
	{
		$returnValue["enterImage3"] = "Yes, it did enter 3 ";
			$img3 = htmlentities($_POST["img3"]);
	}


	if(!$result)
	{
		throw new Exception($statement -> error);
	}

	if(!empty($result))
	{
		if(!$result)
		{
			$returnValue["status"] = "error";
			$returnValue["message"] = "Review not successfully saved.";
		}
		else
		{
			$returnValue["status"] = "success";
			$returnValue["message"] = "Review is successfully saved.";
		}
	}
	echo json_encode($returnValue);

	$mysql -> closeConnection();

?>
