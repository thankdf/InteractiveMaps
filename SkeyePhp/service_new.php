<?php
 
require(dirname(__FILE__) . '/Connect.php');
require(dirname(__FILE__) . '/MySQL.php');

$mysql = new MySQL();
$mysql -> openConnection();
    
    
    //$searchWord = htmlentities($_POST["searchWord"]);
    $searchWord = "SJSU";
    
    $returnValue = array();
    
    $sql = "select * from events where event_name = '".$searchWord."'";
    
    print_r($_REQUEST);
    
    $searchResult = $mysql -> getConnection() -> query($sql);
    
    if($searchResult != null)
    {
        $row = $searchResult -> fetch_array(MYSQLI_ASSOC);
        if(!empty($row))
        {
            $search_event = $row;
        }
    }
    
    if(!empty($search_event))
    {
        $returnValue["event_name"] = $search_event["event_name"];
        $returnValue["username"] = $search_event["username"];

        echo json_encode($returnValue);

        
    }
    

    return $returnValue;
    
    $mysql -> closeConnection();
    
?>
