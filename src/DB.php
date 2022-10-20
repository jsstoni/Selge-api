<?php
namespace src;

use PDO;

trait DB
{
    private static $connect;
    public static function connect()
    {
        if (!(self::$connect instanceof self)) {
            $drive = sprintf("mysql:host=%s;dbname=%s", HOST, DBNAME);
            self::$connect = new PDO($drive, USER, PASS, array(
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8",
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
            ));
            self::$connect->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
        }
        return self::$connect;
    }
}
