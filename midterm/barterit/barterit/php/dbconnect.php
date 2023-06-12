<?php
$servername = "localhost";
$username = "uumitpro_leonewe";
$password = "@I5nE9BCgd!v";
$dbname = "uumitpro_barterit_leon";
$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
die("Connection failed: " . $conn->connect_error);
}
?>