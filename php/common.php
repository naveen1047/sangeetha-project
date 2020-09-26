<?php
include 'constants.php';

function connect() {
    $con=new mysqli(Constants::$DB_SERVER,Constants::$USERNAME,Constants::$PASSWORD,Constants::$DB_NAME);
    if($con->connect_error)
    {
        // echo "Unable To Connect"; - For debug
        return null;
    }else
    {
        //echo "Connected"; - For debug
        return $con;
    }
}
?>