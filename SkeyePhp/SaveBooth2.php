<?php


 // ini_set('display_errors',1);
 // error_reporting(E_ALL);

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
$images = $_FILES;



$returnValue = array();

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
	//echo json_encode($returnValue);
}

$mysql -> closeConnection();


// for image upload

$keyCounter = 0;
foreach ($images as $key )
{
  //$target_dir = "images/". basename($_FILES["file".$keyCounter]["name"]);
  //$target_dir = "images/review" . $new_review_id . $key["name"];
  $target_dir = "images/booth" . $boothID . "img" . $keyCounter .".jpg" ;

  if (move_uploaded_file($_FILES["file".$keyCounter]["tmp_name"], $target_dir))
  {
    // echo json_encode([
    //   "Message" => "The file ". $new_review_id .".jpg". " has been uploaded.",
    //   "Status" => "OK",
    // ]);
		$returnValue["photoUpload"] = "photo succeess";

  } else {

    // echo json_encode([
    //   "Message" => "Sorry, there was an error uploading your file.",
    //   "Status" => "Error",
    //   "error" => $_FILES["file"]["error"]
    // ]);
		$returnValue["photoUpload"] = "photo fail";
  }
  $keyCounter++;

}
$returnValue["photoCounter"] = $keyCounter-1;

echo json_encode($returnValue);
?>
