<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// make connection to database, once means if connection is made once, 
// it wont make the same connection again
include_once("dbconnect.php");

// Obtain data from table using query
// $conn variable is from dbconnect.php
$giveid = $_POST['giveid'];
$takeid = $_POST['takeid'];

$sqlmanage = "DELETE FROM `tbl_offers` WHERE `offer_giveid` = '$giveid' AND `offer_takeid` = '$takeid'";


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