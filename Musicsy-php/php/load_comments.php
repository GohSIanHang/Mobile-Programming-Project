<?php
error_reporting(0);
include_once ("dbconnect.php");
$comment = $_POST['comment'];
$name = $_POST['name'];
// $imageid = $_POST['imageid'];

$sql = "SELECT * FROM COMMENT";
$count = 1;
$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["datas"] = array();
    while ($row = $result->fetch_assoc())
    {
        $list["rank"] = $count++;
        $list["row"] = $row;
        $list["name"] = $row["USERNAME"];
        $list["comment"] = $row["COMMENT"];
        $list["date"] = $row["DATE"];
        $list["imageid"] = $row["IMAGEID"];
        $list["phone"] = $row["PHONE"];
        array_push($response["datas"], $list);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}
?>