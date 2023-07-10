<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// make connection to database, once means if connection is made once, 
// it wont make the same connection again
include_once("dbconnect.php");

// Obtain data from table using query
// $conn variable is from dbconnect.php
if (isset($_POST['takeid']) && isset($_POST['userid'])) {
    $takeid = $_POST['takeid'];
    $userid = $_POST['userid'];
    $sqllogin = "SELECT * FROM `tbl_offers` INNER JOIN `tbl_items` ON `tbl_offers`.`offer_giveid` = `tbl_items`.`item_id` WHERE `offer_takeid` = '$takeid' AND `user_id` = '$userid'";
} else if (isset($_POST['userid'])) {
    $userid = $_POST['userid'];
    $sqllogin = "SELECT * FROM `tbl_offers` INNER JOIN `tbl_items` ON `tbl_offers`.`offer_giveid` = `tbl_items`.`item_id` WHERE `user_id` = '$userid'";
} else if (isset($_POST['useridreceived'])) {
    $userid = $_POST['useridreceived'];
    $sqllogin = "SELECT * FROM `tbl_offers` INNER JOIN `tbl_items` ON `tbl_offers`.`offer_takeid` = `tbl_items`.`item_id` WHERE `user_id` = '$userid'";
}

$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    if (isset($_POST['takeid']) && isset($_POST['userid'])) {
        $offerlist = array();
        while ($row = $result->fetch_assoc()) {
            $offerlist[] = $row['offer_giveid'];
        }
        $response = array('status' => 'success', 'data' => $offerlist);
        sendJsonResponse($response);
    } else if (isset($_POST['userid']) || isset($_POST['useridreceived'])) {
        $offers['offers'] = array();
        while ($row = $result->fetch_assoc()) {
            $offerlist = array();
            $offerlist['offer_giveid'] = $row['offer_giveid'];
            $offerlist['offer_takeid'] = $row['offer_takeid'];
            array_push($offers["offers"], $offerlist);
        }
        $response = array('status' => 'success', 'data' => $offers);
        sendJsonResponse($response);
    }

} else {
    $response = array('status' => 'failed', 'data' => "false");
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>