<?php
if(!isset($_POST)){
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// make connection to database, once means if connection is made once, 
// it wont make the same connection again
include_once("dbconnect.php");

// Obtain data from table using query
// $conn variable is from dbconnect.php
$manage = $_POST['manage_favorite'];
$userid = $_POST['user_id'];
$itemid = $_POST['item_id'];
if($manage == "addFavorite"){
    $sqlmanage = "INSERT INTO `tbl_favorites`(`user_id`, `item_id`) 
    VALUES ('$userid','$itemid')";
}else{
    $sqlmanage = "DELETE FROM `tbl_favorites` WHERE `user_id` = '$userid' AND `item_id` = '$itemid'";
}

if ($conn->query($sqlmanage) === TRUE) {
	$response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
}else{
	$response = array('status' => 'failed', 'data' => null);
	sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>