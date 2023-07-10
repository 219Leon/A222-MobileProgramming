<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid']) && isset($_POST['traderid'])) {
    $userid = $_POST['userid'];
    $traderid = $_POST['traderid'];

    $sqlmanage = "INSERT INTO `tbl_followers`(`user_id`, `trader_id`) 
VALUES ('$userid','$traderid')";
} else {
    $userid = $_POST['deleteuserid'];
    $traderid = $_POST['deletetraderid'];

    $sqlmanage = "DELETE FROM `tbl_followers` WHERE `user_id` = '$userid' && `trader_id` = '$traderid'";
}


if ($conn->query($sqlmanage) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>