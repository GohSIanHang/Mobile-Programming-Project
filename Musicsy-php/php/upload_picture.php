<?php
error_reporting(0);
include_once ("dbconnect.php");
$imageid = rand(1000,9999);
$comment = $_POST['comment'];
$name = $_POST['name'];
date_default_timezone_set("Asia/Kuala_Lumpur");
$date = date('Y/m/d H:i:s');
$path = '../chatimages/'.$imageid.'.jpg';
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);
$sqlinsert = "INSERT INTO COMMENT(USERNAME,COMMENT,DATE,IMAGEID) VALUES ('$name','$comment','$date','$imageid')";
$sqlsearch = "SELECT * FROM MUSIC WHERE ID='$imageid'";
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