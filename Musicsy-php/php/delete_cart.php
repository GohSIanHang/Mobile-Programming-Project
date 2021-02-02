<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$productid = $_POST['productid'];


if (isset($_POST['productid'])){
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email' AND PRODUCTID='$productid'";
}else{
    $sqldelete = "DELETE FROM CART WHERE EMAIL = '$email'";
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>