<?php
error_reporting(0);
include_once ("dbconnect.php");
$name = $_POST['name'];
$email = $_POST['email'];
$phone = $_POST['phone'];
$password = sha1($_POST['password']);
$otp = rand(1000,9999);
date_default_timezone_set("Asia/Kuala_Lumpur");
$date = date('Y/m/d H:i:s');

$sqlinsert = "INSERT INTO USER(NAME,EMAIL,PASSWORD,PHONE,CREDIT,VERIFY,DATEREG) VALUES ('$name','$email','$password','$phone','0','$otp', '$date')";

if ($conn->query($sqlinsert) === true)
{
    sendEmail($otp,$email);
    echo "success";
}else{
    echo "failed";
}

function sendEmail($otp,$useremail) {
    $to      = $useremail; 
    $subject = 'Verification for Musicsy'; 
    $message = 'Use the following link to verify your account : http://gohaction.com/musicsy/php/verify.php?email='.$useremail."&key=".$otp; 
    $headers = 'From: norely@musicsy.com' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}

?>
