<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

$barterto = $_POST['barterto'];
$userid = $_POST['userid'];

// Remove the square brackets at the beginning and end of the string
$barterto = trim($barterto, "[]");

// Seperate each elements of the string into array
$bartertoList = explode(", ", $barterto);

// Now, construct a dynamic IN conditions
$conditions = array();
foreach ($bartertoList as $itemtype) {
    $condition = "'" . $itemtype . "'";

    // Can use this as well:
    // $conditions[] = $condition;
    array_push($conditions, $condition);
}

// Combining the OR conditions using implode()
$conditionString = implode(", ", $conditions);

// Construct sql query
$sqlloadusers = "SELECT * FROM tbl_items WHERE user_id = '$userid' AND item_type IN (" . $conditionString . ")";


$result = $conn->query($sqlloadusers);
if ($result->num_rows > 0) {
    $items["items"] = array();
    $row_count = mysqli_num_rows($result);

    while ($row = $result->fetch_assoc()) {
        $itemlist = array();
        $itemlist['item_id'] = $row['item_id'];
        $itemlist['user_id'] = $row['user_id'];
        $itemlist['item_name'] = $row['item_name'];
        $itemlist['item_price'] = $row['item_price'];
        $itemlist['item_type'] = $row['item_type'];
        $itemlist['item_imagecount'] = $row['item_imagecount'];
        $itemlist['item_desc'] = $row['item_desc'];
        $itemlist['item_qty'] = $row['item_qty'];
        $itemlist['item_lat'] = $row['item_lat'];
        $itemlist['item_long'] = $row['item_long'];
        $itemlist['item_state'] = $row['item_state'];
        $itemlist['item_locality'] = $row['item_locality'];
        $itemlist['item_datereg'] = $row['item_datereg'];
        $itemlist['item_barterto'] = $row['item_barterto'];
        array_push($items["items"], $itemlist);
    }
    $response = array('status' => 'success', 'data' => $items, 'posts' => $row_count);
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