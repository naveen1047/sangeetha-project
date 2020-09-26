<?php
include "common.php";
include "constants.php";

class DB {
    public function select(){
        $con = connect();
        if($con != null)
        {
            $result=$con->query(Constants::$FETCH_ALL_FROM_DETAIL);
            if($result->num_rows>0)
            {
                $names=array();
                while($row=$result->fetch_array())
                {
                    array_push($names, array(
                        "name"=>$row['name'],
                    ));
                }
                print(json_encode(array_reverse($names)));
            }else
            {
                print(json_encode(array("PHP EXCEPTION : CAN'T RETRIEVE FROM MYSQL. ")));
            }
            $con->close();

        }else{
            print(json_encode(array("PHP EXCEPTION : CAN'T CONNECT TO MYSQL. NULL CONNECTION.")));
        }
    }
}
$db = new DB();
$db ->select();

?>