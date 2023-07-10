<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$item_name = $_POST['itemname'];
$item_price = $_POST['itemprice'];
$item_desc = $_POST['itemdesc'];
$item_qty = $_POST['itemqty'];
$item_type = $_POST['type'];
$image_string = $_POST['imagelist'];
$item_imagecount = $_POST['imagecount'];
$item_lat = $_POST['lat'];
$item_long = $_POST['long'];
$item_state = $_POST['state'];
$item_locality = $_POST['locality'];
$item_barterto = $_POST['barterto'];



$sqlinsert = "INSERT INTO `tbl_items`(`user_id`, `item_name`, `item_price`, `item_desc`, `item_type`, `item_imagecount`, `item_qty`, `item_lat`, `item_long`, `item_state`, `item_locality`, `item_barterto`) VALUES ('$user_id','$item_name', '$item_price','$item_desc','$item_type', '$item_imagecount','$item_qty', '$item_lat', '$item_long', '$item_state', '$item_locality', '$item_barterto')";

if ($conn->query($sqlinsert) === TRUE) {
	$filename = mysqli_insert_id($conn);
	$response = array('status' => 'success', 'data' => null);

	// remove unecessary characters from the string
	$image_string = str_replace(array("[", "]", " "), "", $image_string);

	// seperate the elements in string and assign them into array
	$image_list = explode(",",$image_string);

	// decode and save each image into the server
	$int = 1;
	foreach($image_list as $key){
		$decoded_string = base64_decode($key);
		$path = '../assets/items/'.$filename.'-'.$int.'.png';
		file_put_contents($path, $decoded_string);
		$int++;
	}
	
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