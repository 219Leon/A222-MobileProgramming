<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$user_id = $_POST['userid'];
$item_id = $_POST['itemid'];
$imagecount = 0;

$sqlloaditem = "SELECT item_imagecount FROM `tbl_items` WHERE item_id = '$item_id'";
$sqldelete = "DELETE FROM `tbl_items` WHERE `item_id` = '$item_id'";

// Access to find out the amount of image consisted with the item 
$result = $conn->query($sqlloaditem);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()){
        $imagecount = $row['item_imagecount'];
    }

    if ($conn->query($sqldelete) === TRUE) { 
        $response = array('status' => 'success', 'data' => null);

        // use the image count to delete them accordingly
        for($x = 1; $x<=$imagecount; $x++){
            $path = '../assets/items/' . $item_id . '-' . $x . '.png';
            unlink($path);
        }
        sendJsonResponse($response);
    } else {
        $response = array('status' => 'failed', 'data' => null);
        sendJsonResponse($response);
    }
}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>