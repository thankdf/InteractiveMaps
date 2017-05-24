<?php
    require(dirname(__FILE__) . '/Connect.php');
    require(dirname(__FILE__) . '/MySQL.php');
    $email = html_entity_decode($_POST["email"]);
    $newPassword = html_entity_decode($_POST["newPassword"]);
    $currPassword = html_entity_decode($_POST["currPassword"]);
    $returnValue = array();
     
    if(empty($email) || empty($newPassword) || empty($currPassword))
    {
        $returnValue["status"] = "error";
        $returnValue["message"] = "Missing required field";
        echo json_encode($returnValue);
        return;
    }
    
    $secure_currPassword = md5($currPassword);
    $secure_newPassword = md5($newPassword);
    $mysql = new MySQL();
    $mysql -> openConnection();
    $conn = $mysql -> getConnection();
    $sql = "select * from user where username = '".$email."' and password = '".$secure_currPassword."'";
    $result = $conn -> query($sql);
    
    if(mysqli_num_rows($result) == 1){
        $sql = "update user set password = '".$secure_newPassword."' where username = '".$email."'";
        $result = $conn -> query($sql);
        if($result)
        {
            $returnValue["status"] = "success";//$sql
            $returnValue["message"] = "Password has been changed";//$password
            echo json_encode($returnValue);
        }
        else{
            $returnValue["status"] = "error";
            $returnValue["message"] = "User is not found";
            echo json_encode($returnValue);
        }

    }
    else{
        $returnValue["status"] = "error";
        $returnValue["message"] = "Current password does not exist";
        echo json_encode($returnValue);
    }

    $mysql -> closeConnection();
    
    /*require(dirname(__FILE__) . '/Connect.php');
    require(dirname(__FILE__) . '/MySQL.php');
    $email = html_entity_decode($_POST["email"]);
    $password = html_entity_decode($_POST["password"]);
    $returnValue = array();
    
    if(empty($email) || empty($password))
    {
        $returnValue["status"] = "error";
        $returnValue["message"] = "Missing required field";
        echo json_encode($returnValue);
        return;
    }
    
    $
    $secure_password = md5($password);
    $mysql = new MySQL();
    $mysql -> openConnection();
    $sql = "update user set password = '".$secure_password."' where username = '".$email."'";
    $result = $mysql -> getConnection() -> query($sql);
    if($result)
    {
        $returnValue["status"] = "success";//$sql
        $returnValue["message"] = "Password has been changed";//$password
        echo json_encode($returnValue);
    }
    else{
        $returnValue["status"] = "error";
        $returnValue["message"] = "User is not found";
        echo json_encode($returnValue);
    }
    $mysql -> closeConnection();*/
?>

