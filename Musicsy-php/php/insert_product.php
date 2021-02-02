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

$sqlinsert = "INSERT INTO MUSIC(ID,NAME,DESCRIPTION,TYPE,BUDGET,AVAILABLE,SOLD) VALUES ('$productid','$name','$description','$type','$budget','$quantity','$sold')";
$sqlsearch = "SELECT * FROM MUSIC WHERE ID='$productid'";
$resultsearch = $conn->query($sqlsearch);
if ($resultsearch->num_rows > 0)
{
    echo 'found';
}else{
if ($conn->query($sqlinsert) === true)
{
    if (file_put_contents($path, $decoded_string)){
        echo 'success';
    }else{
        echo 'failed';
    }
}
else
{
    echo "failed";
}    
}


?>