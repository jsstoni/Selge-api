<?php
namespace src;

/**
* @author jsstoni
* script by jsstoni
* Secure
*/
class Secure
{
    public $type = '';

    public function __construct()
    {
        array_walk($_POST, array(&$this, 'requestPost'));
        array_walk($_GET, array(&$this, 'requestGet'));
    }

    private function _clean($str)
    {
        if (!empty($str)) {
            $str = is_array($str) ? array_map('self::_clean', $str) : str_replace('\\', '&bsol;', htmlspecialchars($str, ENT_QUOTES, 'UTF-8'));
            return $str;
        }
        return null;
    }

    public function requestGet($str, $key)
    {
        $_GET[$key] = $this->_clean($str);
        return $_GET[$key];
    }

    public function requestPost($str, $key)
    {
        $_POST[$key] = $this->_clean($str);
        return $_POST[$key];
    }
}
