<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$phone = $_POST['phone'];
$comment = $_POST['comment'];
date_default_timezone_set("Asia/Kuala_Lumpur");
$date = date('Y/m/d H:i:s');
// $imageid = 'null';


echo $name;
echo $comment;

$sqlinsert = "INSERT INTO COMMENT(USERNAME,COMMENT,DATE,IMAGEID,PHONE) VALUES ('$name','$comment','$date',NULL,'$phone')";

if ($conn->query($sqlinsert) === true)
{
    echo "success";
}else{
    echo "failed";
    
}

?>
