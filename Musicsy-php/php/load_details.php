<?php
error_reporting(0);
include_once ("dbconnect.php");

$sql = "SELECT * FROM CLASSIC";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["datas"] = array();
    while ($row = $result->fetch_assoc())
    {
        $list = array();
        $list["intro"] = $row["INTRODUCTION"];
        
        array_push($response["datas"], $list);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>