<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");


if (isset($_POST['userid'])) {
    $userid = $_POST['userid'];
    $offset = $_POST['offset'];
    $limit = $_POST['limit'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE user_id = '$userid' LIMIT $limit OFFSET $offset";

} else if (isset($_POST['itemid'])) {
    $itemid = $_POST['itemid'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE item_id = '$itemid'";

} else if (isset($_POST['favorite_userid'])) {
    $userid = $_POST['favorite_userid'];
    $sqlloaditems = "SELECT `tbl_items`.`user_id`, `tbl_items`.`item_id`, `tbl_items`.`item_name`, `tbl_items`.`item_price`, `tbl_items`.`item_type`, `tbl_items`.`item_imagecount`, `tbl_items`.`item_desc`, `tbl_items`.`item_qty`, `tbl_items`.`item_lat`, `tbl_items`.`item_long`, `tbl_items`.`item_state`, `tbl_items`.`item_locality`, `tbl_items`.`item_datereg`, `tbl_items`.`item_barterto` 
                    FROM `tbl_items` 
                    INNER JOIN `tbl_favorites` ON `tbl_favorites`.`item_id` = `tbl_items`.`item_id` 
                    WHERE `tbl_favorites`.`user_id` = '$userid'";

} else if (isset($_POST['search'])) {
    $search = $_POST['search'];
    $offset = $_POST['offset'];
    $limit = $_POST['limit'];
    $sqlloaditems = "SELECT * FROM `tbl_items` WHERE `item_name` LIKE '%$search%' OR `item_type` LIKE '%$search%'OR `item_desc` LIKE '%$search%' LIMIT $limit OFFSET $offset";

} else if (isset($_POST['interest'])) {
    $interest = $_POST['interest'];
    $offset = $_POST['offset'];
    $limit = $_POST['limit'];

    // Remove the square brackets at the beginning and end of the string
    $interest = trim($interest, "[]");

    // Seperate each elements of the string into array
    $interestList = explode(", ", $interest);

    // Now, construct a dynamic 'CASE' statement
    $condition = "";
    foreach ($interestList as $index => $itemType) {
        $condition .= "WHEN item_type = '$itemType' THEN $index + 1 ";
    }

    // Build the query
    $sqlloaditems = "SELECT * FROM tbl_items ORDER BY CASE $condition ELSE " . (count($interestList) + 1) . " END LIMIT $limit OFFSET $offset";
} else if (isset($_POST['itemIdList'])) {
    $itemIdList = $_POST['itemIdList'];

    // Remove the square brackets at the beginning and end of the string
    $itemIdList = trim($itemIdList, "[]");

    // Seperate each elements of the string into array
    $itemIdArray = explode(", ", $itemIdList);

    // Now, construct a dynamic IN conditions to add '' for each itemId
    $conditions = array();
    foreach ($itemIdArray as $itemId) {
        $condition = "'" . $itemId . "'";

        array_push($conditions, $condition);
    }

    // Combining the OR conditions using implode()
    $conditionString = implode(", ", $conditions);

    // Construct sql query
    $sqlloaditems = "SELECT * FROM tbl_items WHERE item_id IN (" . $conditionString . ")";

} else {
    $offset = $_POST['offset'];
    $limit = $_POST['limit'];
    $sqlloaditems = "SELECT * FROM `tbl_items` LIMIT $limit OFFSET $offset";
}

$result = $conn->query($sqlloaditems);
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