
<?php

//var_dump($_FILES);
ini_set('display_errors',1);
error_reporting(E_ALL);

$finalResult = array();

// for database upload

require(dirname(__FILE__) . '/Connect.php');
require(dirname(__FILE__) . '/MySQL.php');

$mysql = new MySQL();
$mysql -> openConnection();

$returnValue = array();
$boothID = htmlentities($_POST["booth_id"]);
$reviewText = htmlentities($_POST["review"]);
$date = htmlentities($_POST["date"]);
$username = htmlentities($_POST["username"]);
$images = $_FILES;


$sql = "insert into review set booth_id = ".$boothID.", review = '".$reviewText."', date = '".$date."', username = '".$username."'";
$result = $mysql -> getConnection() -> query($sql);

$new_review_id = mysqli_insert_id($mysql -> getConnection());

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

//echo json_encode($returnValue);

$mysql -> closeConnection();




// for image upload

$keyCounter = 0;

foreach ($images as $key )
{
  //$target_dir = "images/". basename($_FILES["file".$keyCounter]["name"]);
  //$target_dir = "images/review" . $new_review_id . $key["name"];
  $target_dir = "images/review" . $new_review_id . "img" . $keyCounter .".jpg" ;

  if (move_uploaded_file($_FILES["file".$keyCounter]["tmp_name"], $target_dir))
  {
    // echo json_encode([
    //   "Message" => "The file ". $new_review_id .".jpg". " has been uploaded.",
    //   "Status" => "OK",
    // ]);


  } else {

    // echo json_encode([
    //   "Message" => "Sorry, there was an error uploading your file.",
    //   "Status" => "Error",
    //   "error" => $_FILES["file"]["error"]
    // ]);

  }
  $keyCounter++;

}
echo json_encode($finalResult);

?>
