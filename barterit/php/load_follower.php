<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");

if(isset($_POST['userid']) && isset($_POST['traderid'])){
    $userid = $_POST['userid'];
    $traderid = $_POST['traderid'];
    $sqlloadfollows = "SELECT * FROM `tbl_followers` WHERE user_id = '$userid' AND trader_id = '$traderid'";
} else if(isset($_POST['traderid'])){
    $traderid = $_POST['traderid'];
    $sqlloadfollows = "SELECT * FROM `tbl_followers` WHERE trader_id = '$traderid'";
} else if(isset($_POST['userid'])){
    $userid = $_POST['userid'];
    $sqlloadfollows = "SELECT * FROM `tbl_followers` WHERE user_id = '$userid'";
} else if(isset($_POST['list_traderid'])){
    // Find the list of followers
    $traderid = $_POST['list_traderid'];
    $sqlloadfollows = "SELECT * FROM `tbl_users` INNER JOIN `tbl_followers` 
    ON `tbl_followers`.`user_id` = `tbl_users`.`user_id` 
    WHERE `tbl_followers`.trader_id = '$traderid'";
} else if(isset($_POST['list_userid'])){
    // Find the list of followers
    $userid = $_POST['list_userid'];
    $sqlloadfollows = "SELECT tbl_followers.trader_id, tbl_users.user_name, tbl_users.user_phone, tbl_users.user_hasavatar, tbl_users.user_email FROM `tbl_users` INNER JOIN `tbl_followers` 
    ON `tbl_followers`.`trader_id` = `tbl_users`.`user_id` 
    WHERE `tbl_followers`.user_id = '$userid'";
}


$result = $conn->query($sqlloadfollows);
if ($result->num_rows > 0) {
    $row_count = mysqli_num_rows($result);
    $users['users'] = array();

    if(isset($_POST['list_traderid'])){
        while($row = $result->fetch_assoc()){
            $userlist = array();
            $userlist['id'] = $row['user_id'];
            $userlist['name'] = $row['user_name'];
            $userlist['phone'] = $row['user_phone'];
            $userlist['hasavatar'] = $row['user_hasavatar'];
            $userlist['email'] = $row['user_email'];
            $userlist['password'] = "na";
            $userlist['otp'] = "na";
            $userlist['datereg'] = "na";
            array_push($users["users"],$userlist);
        }
    }

    if(isset($_POST['list_userid'])){
        while($row = $result->fetch_assoc()){
            $userlist = array();
            $userlist['id'] = $row['trader_id'];
            $userlist['name'] = $row['user_name'];
            $userlist['phone'] = $row['user_phone'];
            $userlist['hasavatar'] = $row['user_hasavatar'];
            $userlist['email'] = $row['user_email'];
            $userlist['password'] = "na";
            $userlist['otp'] = "na";
            $userlist['datereg'] = "na";
            array_push($users["users"],$userlist);
        }
    }
	
    $response = array('status' => 'success', 'data' => $users, 'follow' => $row_count);
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