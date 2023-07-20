<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['userid'])){
	$userid = $_POST['userid'];	
	$sqlorder = "SELECT * FROM `tbl_transactios` WHERE user_id = '$userid'";
}


$result = $conn->query($sqlorder);
if ($result->num_rows > 0) {
    $oderitems["orders"] = array();
	while ($row = $result->fetch_assoc()) {
        $orderlist = array();
        $orderlist['transaction_id'] = $row['transaction_id'];
        $orderlist['barter_bill'] = $row['barter_bill'];
        $orderlist['order_paid'] = $row['order_paid'];
        $orderlist['user_id'] = $row['user_id'];
        $orderlist['trader_id'] = $row['trader_id'];
        $orderlist['order_date'] = $row['order_date'];
        $orderlist['order_status'] = $row['order_status'];
         $orderlist['order_lat'] = $row['order_lat'];
          $orderlist['order_lng'] = $row['order_lng'];
        array_push($oderitems["orders"] ,$orderlist);
    }
    $response = array('status' => 'success', 'data' => $oderitems);
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