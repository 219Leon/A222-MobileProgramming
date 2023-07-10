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
if(isset($_POST['user_id']) && isset($_POST['item_id'])){
    $userid = $_POST['user_id'];
    $itemid = $_POST['item_id'];
    $sqllogin = "SELECT * FROM `tbl_favorites` WHERE `user_id` = '$userid' AND `item_id` = '$itemid'";
}else{
    $sqllogin = "SELECT * FROM `tbl_users`";
}

$result = $conn->query($sqllogin);
if($result -> num_rows > 0){
    while($row = $result->fetch_assoc()){
		$response = array('status' => 'success', 'data' => "true");
		sendJsonResponse($response);
    }
}else{
	$response = array('status' => 'failed', 'data' => "false");
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>