<?php
$servername = "localhost";
$username   = "gohactio_musicsyadmin";
$password   = "o5eh-4SIbJEd";
$dbname     = "gohactio_musicsy";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>