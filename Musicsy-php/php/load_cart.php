<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT MUSIC.ID, MUSIC.NAME, MUSIC.DESCRIPTION, MUSIC.TYPE, MUSIC.BUDGET, MUSIC.AVAILABLE, CART.CQUANTITY FROM MUSIC INNER JOIN CART ON CART.PRODUCTID = MUSIC.ID WHERE CART.EMAIL = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["cart"] = array();
    while ($row = $result->fetch_assoc())
    {
        $cartlist = array();
        $cartlist["id"] = $row["ID"];
        $cartlist["name"] = $row["NAME"];
        $cartlist["description"] = $row["DESCRIPTION"];
        $cartlist["type"] = $row["TYPE"];
        $cartlist["budget"] = $row["BUDGET"];
        $cartlist["quantity"] = $row["AVAILABLE"];
        $cartlist["cquantity"] = $row["CQUANTITY"];
        $cartlist["yourbudget"] = round(doubleval($row["BUDGET"])*(doubleval($row["CQUANTITY"])),2)."";
        array_push($response["cart"], $cartlist);
    }
    echo json_encode($response);
}
else
{
    echo "Cart Empty";
}
?>