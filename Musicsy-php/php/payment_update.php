<?php
error_reporting(0);
include_once("dbconnect.php");
$userid = $_GET['userid'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$orderid = $_GET['orderid'];
date_default_timezone_set("Asia/Kuala_Lumpur");

$data = array(
    'id' =>  $_GET['billplz']['id'],
    'paid_at' => $_GET['billplz']['paid_at'] ,
    'paid' => $_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature']
);

$paidstatus = $_GET['billplz']['paid'];
if ($paidstatus=="true"){
    $paidstatus = "Success";
}else{
    $paidstatus = "Failed";
}
$receiptid = $_GET['billplz']['id'];
$signing = '';
foreach ($data as $key => $value) {
    $signing.= 'billplz'.$key . $value;
    if ($key === 'paid') {
        break;
    } else {
        $signing .= '|';
    }
}
 

$signed= hash_hmac('sha256', $signing, 'S-d5LJkQ8KokrW4EP35VJOSw');
if ($signed === $data['x_signature']) {

    if ($paidstatus == "Success"){ //payment success
        
        $sqlcart ="SELECT CART.PRODUCTID, CART.CQUANTITY, MUSIC.BUDGET FROM CART INNER JOIN MUSIC ON CART.PRODUCTID = MUSIC.ID WHERE CART.EMAIL = '$userid'";
        $cartresult = $conn->query($sqlcart);
        if ($cartresult->num_rows > 0)
        {
        while ($row = $cartresult->fetch_assoc())
        {
            $productid = $row["PRODUCTID"];
            $cq = $row["CQUANTITY"]; //cart qty
            $sqlinsertcarthistory = "INSERT INTO CARTHISTORY(EMAIL,ORDERID,BILLID,PRODUCTID,CQUANTITY) VALUES ('$userid','$orderid','$receiptid','$productid','$cq')";
            $conn->query($sqlinsertcarthistory);
            
            $selectproduct = "SELECT * FROM MUSIC WHERE ID = '$productid'";
            $productresult = $conn->query($selectproduct);
             if ($productresult->num_rows > 0){
                  while ($rowp = $productresult->fetch_assoc()){
                    $prquantity = $rowp["AVAILABLE"];
                    $prevsold = $rowp["SOLD"];
                    $newquantity = $prquantity - $cq; //quantity in store - quantity ordered by user
                    $newsold = $prevsold + $cq;
                    $sqlupdatequantity = "UPDATE MUSIC SET AVAILABLE = '$newquantity', SOLD = '$newsold' WHERE ID = '$productid'";
                    $conn->query($sqlupdatequantity);
                  }
             }
        }
        
       $sqldeletecart = "DELETE FROM CART WHERE EMAIL = '$userid'";
       $sqlinsert = "INSERT INTO PAYMENT(ORDERID,BILLID,USERID,TOTAL) VALUES ('$orderid','$receiptid','$userid','$amount')";
       
       $conn->query($sqldeletecart);
       $conn->query($sqlinsert);
    }
        echo '<br><br><style>body{background-image: url("http://gohaction.com/musicsy/profileimages/grey.jpg");}</style><body><div><h2><br><br><center>Receipt</center></h1><table border=1 width=80% align=center><tr><td>Order id</td><td>'.$orderid.'</td></tr><tr><td>Receipt ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td><td>'.$userid. ' </td></tr><td>Amount </td><td>RM '.$amount.'</td></tr><tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr><tr><td>Date </td><td>'.date("d/m/Y").'</td></tr><tr><td>Time </td><td>'.date("h:i:s a").'</td></tr></table><br><p><center>Press back button to return to Music</center></p></div></body>';
        //echo $sqlinsertcarthistory;
    } 
        else 
    {
    echo 'Payment Failed!';
    }
}

?>