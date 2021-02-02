<?php
error_reporting(0);
include_once ("dbconnect.php");
$type = $_POST['type'];
$name = $_POST['name'];
$productid = $_POST['productid'];

if (isset($type)){
    if ($type == "Recent"){
        $sql = "SELECT * FROM MUSIC ORDER BY ID lIMIT 25";    
    }else{
        $sql = "SELECT * FROM MUSIC WHERE TYPE = '$type'";    
    }
}else{
    $sql = "SELECT * FROM MUSIC ORDER BY ID lIMIT 25";    
}
if (isset($name)){
   $sql = "SELECT * FROM MUSIC WHERE NAME LIKE  '%$name%'";
}

if (isset($productid)){
   $sql = "SELECT * FROM MUSIC WHERE ID = '$productid'";
}


$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["datas"] = array();
    while ($row = $result->fetch_assoc())
    {
        $list = array();
        $list["id"] = $row["ID"];
        $list["name"] = $row["NAME"];
        $list["description"] = $row["DESCRIPTION"];
        $list["type"] = $row["TYPE"];
        $list["budget"] = $row["BUDGET"];
        $list["quantity"] = $row["AVAILABLE"];
        $list["date"] = $row["DATE"];
        $list["sold"] = $row["SOLD"];
        array_push($response["datas"], $list);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>