<?php
	if (!isset($_GET['userid'])) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	$userid = $_GET['userid'];
	include_once("dbconnect.php");
	$sqlloaditem = "SELECT * FROM tbl_items WHERE user_id = '$userid'";
	$result = $conn->query($sqlloaditem);
	if ($result->num_rows > 0) {
		$itemsarray["items"] = array();
		while ($row = $result->fetch_assoc()) {
			$tolist = array();
			$tolist['item_id'] = $row['item_id'];
			$tolist['user_id'] = $row['user_id'];
			$tolist['item_name'] = $row['item_name'];
			$tolist['item_desc'] = $row['item_desc'];
			$tolist['item_price'] = $row['item_price'];
			$tolist['item_delivery'] = $row['item_delivery'];
			$tolist['item_qty'] = $row['item_qty'];
			$tolist['item_state'] = $row['item_state'];
			$tolist['item_local'] = $row['item_local'];
			$tolist['item_lat'] = $row['item_lat'];
			$tolist['item_lng'] = $row['item_lng'];
			$tolist['item_date'] = $row['item_date'];
			array_push($itemsarray["items"],$tolist);
		}
		$response = array('status' => 'success', 'data' => $itemsarray);
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