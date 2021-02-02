<?php
error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$productid = $_POST['productid'];
$quantity = $_POST['quantity'];

$sqlupdate = "UPDATE CART SET CQUANTITY = '$quantity' WHERE EMAIL = '$email' AND PRODUCTID = '$productid'";

if ($conn->query($sqlupdate) === true)
{
    echo "success";
}
else
{
    echo "failed";
}
    
$conn->close();
?>