<?php
	error_reporting(0);
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	include_once("dbconnect.php");
	$userid = $_POST['userid'];
	$itemid = $_POST['itemid'];
  	$itemname= ucwords(addslashes($_POST['itemname']));
	$itemdesc= ucfirst(addslashes($_POST['itemdesc']));
	$itemprice= $_POST['itemprice'];
  $delivery= $_POST['delivery'];
  $qty= $_POST['qty'];
  
	$sqlupdate = "UPDATE `tbl_items` SET `item_name`='$itemname',`item_desc`='$itemdesc',`item_price`='$itemprice',`item_delivery`='$delivery',`item_qty`='$qty' WHERE `item_id` = '$itemid' AND `user_id` = '$userid'";
	
  try {
		if ($conn->query($sqlupdate) === TRUE) {
			$response = array('status' => 'success', 'data' => null);
			sendJsonResponse($response);
		}
		else{
			$response = array('status' => 'failed', 'data' => null);
			sendJsonResponse($response);
		}
	}
	catch(Exception $e) {
		$response = array('status' => 'failed', 'data' => null);
		sendJsonResponse($response);
	}
	$conn->close();
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type= application/json');
    echo json_encode($sentArray);
	}
?>