<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$item_id = $_POST['itemid'];
$item_name = $_POST['itemname'];
$item_price = $_POST['itemprice'];
$item_desc = $_POST['itemdesc'];
$item_qty = $_POST['itemqty'];
$item_type = $_POST['type'];
$item_barterto = $_POST['barterto'];


$sqlinsert = "UPDATE `tbl_items` SET `item_name` = '$item_name', `item_price` = '$item_price', `item_desc` = '$item_desc', `item_type` = '$item_type', `item_qty` = '$item_qty', `item_barterto` = '$item_barterto' WHERE `item_id` = '$item_id'";

if ($conn->query($sqlinsert) === TRUE) {
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