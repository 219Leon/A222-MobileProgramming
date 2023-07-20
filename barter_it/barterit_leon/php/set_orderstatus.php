<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$transactionid = $_POST['transactionid'];
$status = $_POST['status'];
$lat = $_POST['lat'];
$lng = $_POST['lng'];

$sqlupdate = "UPDATE `tbl_transactions` SET `order_status`='$status', `order_lng` = '$lng', `order_lat` = '$lat' WHERE transaction_id = '$transactionid'";

if ($conn->query($sqlupdate) === TRUE) {
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