<?php
	error_reporting(0);
	include_once("dbconnect.php");
	$search  = $_GET["search"];
	$results_per_page = 10;
	$pageno = (int)$_GET['pageno'];
	$page_first_result = ($pageno - 1) * $results_per_page;
	
	if ($search =="all"){
			$sqlloaditem = "SELECT * FROM tbl_items ORDER BY item_date DESC";
	}else{
		$sqlloaditem = "SELECT * FROM tbl_items WHERE item_name LIKE '%$search%' ORDER BY item_date DESC";
	}
	
	$result = $conn->query($sqlloaditem);
	$number_of_result = $result->num_rows;
	$number_of_page = ceil($number_of_result / $results_per_page);
	$sqlloaditem = $sqlloaditem . " LIMIT $page_first_result , $results_per_page";
	$result = $conn->query($sqlloaditem);
	
	if ($result->num_rows > 0) {
		$itemsarray["items"] = array();
		while ($row = $result->fetch_assoc()) {
			$tolist = array();
			$tolist['item_id'] = $row['item_id'];
			$tolist['user_id'] = $row['user_id'];
			$tolist['item_name'] = $row['item_name'];
			$tolist['item_desc'] = $row['item_desc'];
			$tolist['item_rent_price'] = $row['item_rent_price'];
			$tolist['item_delivery'] = $row['item_delivery'];
			$tolist['item_qty'] = $row['item_qty'];
			$tolist['item_state'] = $row['item_state'];
			$tolist['item_local'] = $row['item_local'];
			$tolist['item_lat'] = $row['item_lat'];
			$tolist['item_lng'] = $row['item_lng'];
			$tolist['item_date'] = $row['item_date'];
			array_push($itemsarray["items"],$tolist);
		}
		$response = array('status' => 'success', 'numofpage'=>"$number_of_page",'numberofresult'=>"$number_of_result",'data' => $itemsarray);
    sendJsonResponse($response);
		}else{
		$response = array('status' => 'failed','numofpage'=>"$number_of_page", 'numberofresult'=>"$number_of_result",'data' => null);
    sendJsonResponse($response);
	}
	
	function sendJsonResponse($sentArray)
	{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
	}
?>