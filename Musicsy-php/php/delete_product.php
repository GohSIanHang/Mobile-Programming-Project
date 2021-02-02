<?php
error_reporting(0);
include_once ("dbconnect.php");
$productid = $_POST['productid'];
$name  = ucwords($_POST['name']);
$description = $_POST['description'];
$type  = $_POST['type'];
$budget  = $_POST['budget'];
$quantity  = $_POST['quantity'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sold = '0';
$path = '../images/'.$productid.'.jpg';

if (isset($_POST['productid'])){
    $sqldelete = "DELETE FROM MUSIC WHERE ID ='$productid'";
}else{
    
}
    
    if ($conn->query($sqldelete) === TRUE){
       echo "success";
    }else {
        echo "failed";
    }
?>