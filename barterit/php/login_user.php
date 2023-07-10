<?php
// If $_POST is not set, sends json response with status of failed and data of null
// Then terminate the script execution
// 感觉是看有没有data过来这个file，没有的话就不用做东西了
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

// fetch 拿来的$_POST file然后assign email 和 password
// 不过password是encrypted的
if (isset($_POST['email'])) {
    $email = $_POST['email'];
    $pass = sha1($_POST['user_password']);
}

// make connection to database, once means if connection is made once, 
// it wont make the same connection again
include_once("dbconnect.php");

// Obtain data from table using query
// $conn variable is from dbconnect.php
if (isset($_POST['user_id'])) {
    $userid = $_POST['user_id'];
    $sqllogin = "SELECT `user_id`, `user_name`, `user_phone`, `user_hasavatar` FROM `tbl_users` WHERE user_id = '$userid'";
} else if (isset($_POST['search'])) {
    $search = $_POST['search'];
    $sqllogin = "SELECT `user_id`, `user_name`, `user_phone`, `user_hasavatar` FROM `tbl_users` WHERE user_name LIKE '%$search%'";
} else {
    $sqllogin = "SELECT * FROM `tbl_users` WHERE user_email = '$email' AND user_password =++ '$pass'";
}

$result = $conn->query($sqllogin);
if ($result->num_rows > 0) {
    while ($row = $result->fetch_assoc()) {
        $userarray = array();
        $userarray['id'] = $row['user_id'];
        $userarray['name'] = $row['user_name'];
        $userarray['phone'] = $row['user_phone'];
        $userarray['hasavatar'] = $row['user_hasavatar'];

        if (isset($_POST['user_id']) || isset($_POST['search'])) {
            $userarray['email'] = "na";
            $userarray['password'] = "na";
            $userarray['otp'] = "na";
            $userarray['datereg'] = "na";
            $userarray['credit'] = "na";
        } else {
            $userarray['email'] = $row['user_email'];
            $userarray['password'] = $_POST['user_password'];
            $userarray['otp'] = $row['user_otp'];
            $userarray['datereg'] = $row['user_datereg'];
            $userarray["credit"] = $row["user_credit"];
        }
        $response = array('status' => 'success', 'data' => $userarray);
        sendJsonResponse($response);
    }
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>