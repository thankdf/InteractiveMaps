<?php
     require(dirname(__FILE__) . '/Connect.php');
     require(dirname(__FILE__) . '/MySQL.php');
     $email = htmlentities($_POST["email"]);
     $password = htmlentities($_POST["password"]);
     $returnValue = array();
     
     if(empty($email) || empty($password))
     {
         $returnValue["status"] = "error";
         $returnValue["message"] = "Missing required field";
         echo json_encode($returnValue);
         return;
     }
    $mysql = new MySQL();
    $mysql -> openConnection();
    

    $sql = "update user set password = '".md5($password)."' where username = '" . $email ."'";
    $result = $mysql -> getConnection() -> query($sql);
    if($result)
    {
        $returnValue["status"] = "success";
        $returnValue["message"] = "User is updated";
        echo json_encode($returnValue);
    }
    else{
        $returnValue["status"] = "error";
        $returnValue["message"] = "User is not found";
        echo json_encode($returnValue);
    }
    $mysql -> closeConnection();

     //$sql = "update user set password='".md5($password)."' where username='".$email."'";
    
     /*$statement = $dao->getConnection()->prepare($sql);
     if(!$statement){
         throw new Exception($statement->error);
     }
     $statement->bind_param("ss", md5($password), $email);
     $statement->execute();*/
    
     
     //$userInfo = settingUser($email,$secure_password);
     
     //if(!empty($userInfo))
     //if($statement->rowCount() > 0)
     /*if($conn->query($sql) === TRUE)
     {
         echo("success");
         $returnValue["status"] = "success";
         $returnValue["message"] = "User is updated";
         echo json_encode($returnValue);
     }
     else{
         echo("failed");
         $returnValue["status"] = "error";
         $returnValue["message"] = "User is not found";
         echo json_encode($returnValue);
     }
    //conn -> close();
    //$statement->close();
    //$mysql->closeConnection();*/
?>

