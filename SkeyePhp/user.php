<?php
    
    require(dirname(__FILE__) . '/Connect.php');
    require(dirname(__FILE__) . '/MySQL.php');
    
    $mysql = new MySQL();
    $mysql -> openConnection();
    echo("Kevin");
    // $boothID = htmlentities($_POST["boothID"]);
    $boothID = 187;
    
    $returnValue = array();
    
    $sql = "select * from booth where booth_id = " . $boothID;
    $result = $mysql -> getConnection() -> query($sql);
    if($result)
    {
        $row = $result -> fetch_array(MYSQLI_ASSOC);
        $returnValue["status"] = "success";
        $returnValue["booth"] = $row;
        echo json_encode($returnValue);
    }
    else
    {
        $returnValue["status"] = "error";
        $returnValue["message"] = "Was not able to retrieve booth from the database";
        echo json_encode($returnValue);
    }
    
    $mysql -> closeConnection();
    
    ?>
