<?php
	if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
	}
	include_once("dbconnect.php");
	$ownerid = $_POST['userid'];
  	$itemname= ucwords(addslashes($_POST['itemname']));
	$itemdesc= ucfirst(addslashes($_POST['itemdesc']));
	$itemprice= $_POST['itemprice'];
  	$delivery= $_POST['delivery'];
  	$qty= $_POST['qty'];
  	$state= addslashes($_POST['state']);
  	$local= addslashes($_POST['local']);
  	$lat= $_POST['lat'];
  	$lng= $_POST['lng'];
  	$image1= $_POST['image1'];
  	$image2= $_POST['image2'];
  	$image3= $_POST['image3'];

	$sqlinsert = "INSERT INTO `tbl_items`
	(`user_id`, `item_name`, `item_desc`, `item_price`, `item_delivery`, `item_qty`, `item_state`, `item_local`, `item_lat`, `item_lng`) 
	VALUES ('$ownerid','$itemname','$itemdesc','$itemprice','$delivery','$qty','$state','$local','$lat','$lng')";
	
  try {
		if ($conn->query($sqlinsert) === TRUE) {
			$item_id = $conn->insert_id;
        
			if (!empty($image1)) {
				$decoded_string = base64_decode($image1);
				$filename = $item_id . '_1.png';
				$path = '../assets/itemimages/' . $filename;
				file_put_contents($path, $decoded_string);
			}
			
			if (!empty($image2)) {
				$decoded_string = base64_decode($image2);
				$filename = $item_id . '_2.png';
				$path = '../assets/itemimages/' . $filename;
				file_put_contents($path, $decoded_string);
			}
			
			if (!empty($image3)) {
				$decoded_string = base64_decode($image3);
				$filename = $item_id . '_3.png';
				$path = '../assets/itemimages/' . $filename;
				file_put_contents($path, $decoded_string);
			}
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