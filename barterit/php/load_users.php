<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");



$searchname = $_POST['searchname'];
$username = $_POST['username'];
$sqlloadusers = "SELECT * FROM `tbl_users` WHERE user_name LIKE '%$searchname%' AND user_name != '$username'";


$result = $conn->query($sqlloadusers);
if ($result->num_rows > 0) {
    $users["users"] = array();
    $row_count = mysqli_num_rows($result);

    while ($row = $result->fetch_assoc()) {
        $userarray = array();
        $userarray['id'] = $row['user_id'];
        $userarray['name'] = $row['user_name'];
        $userarray['phone'] = $row['user_phone'];
        $userarray['hasavatar'] = $row['user_hasavatar'];
        $userarray['email'] = "na";
        $userarray['password'] = "na";
        $userarray['otp'] = "na";
        $userarray['datereg'] = "na";

        array_push($users["users"], $userarray);
    }
    $response = array('status' => 'success', 'data' => $users, 'posts' => $row_count);
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