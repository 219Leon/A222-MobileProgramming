<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if (isset($_POST['traderid']) && isset($_POST['barterbill'])){
	$traderid = $_POST['traderid'];	
	$barterbill = $_POST['barterbill'];
	$sqlorderdetails = "SELECT * FROM `tbl_orderdetails` INNER JOIN `tbl_items` ON tbl_orderdetails.item_id = tbl_items.item_id WHERE tbl_orderdetails.trader_id = '$traderid' AND tbl_orderdetails.barter_bill = '$barterbill'";
}

//	$sqlcart = "SELECT * FROM `tbl_carts` INNER JOIN `tbl_items` ON tbl_carts.item_id = tbl_items.item_id WHERE tbl_carts.user_id = '$userid'";
//`orderdetail_id`, `barter_bill`, `item_id`, `orderdetail_qty`, `orderdetail_paid`, `user_id`, `trader_id`, `orderdetail_date`

$result = $conn->query($sqlorderdetails);
if ($result->num_rows > 0) {
    $oderdetails["orderdetails"] = array();
	while ($row = $result->fetch_assoc()) {
        $orderdetailslist = array();
        $orderdetailslist['orderdetail_id'] = $row['orderdetail_id'];
        $orderdetailslist['barter_bill'] = $row['barter_bill'];
        $orderdetailslist['item_id'] = $row['item_id'];
        $orderdetailslist['item_name'] = $row['item_name'];
        $orderdetailslist['orderdetail_qty'] = $row['orderdetail_qty'];
        $orderdetailslist['orderdetail_paid'] = $row['orderdetail_paid'];
        $orderdetailslist['user_id'] = $row['user_id'];
        $orderdetailslist['trader_id'] = $row['trader_id'];
        $orderdetailslist['orderdetail_date'] = $row['orderdetail_date'];
        array_push($oderdetails["orderdetails"] ,$orderdetailslist);
    }
    $response = array('status' => 'success', 'data' => $oderdetails);
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