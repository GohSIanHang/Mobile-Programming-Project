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
$path = '../images/'.$productid.'.jpg';

$sqlupdate = "UPDATE MUSIC SET NAME ='$name', DESCRIPTION = '$description', TYPE = '$type', BUDGET = '$budget', AVAILABLE = '$quantity' WHERE ID = '$productid'";
$sqlsearch = "SELECT * FROM MUSIC WHERE ID='$productid'";
$resultsearch = $conn->query($sqlsearch);

if ($conn->query($sqlupdate) === true)
{
    if (isset($encode_string)){
        file_put_contents($path,$decoded_string);
    }
    echo "success";
}
else
{
    echo "failed";
}    

$conn->close();
?>