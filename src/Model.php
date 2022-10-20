<?php
/**
 * Model
 */
namespace src;

use src\DataBase;

class Model extends DataBase
{
    public $data;

    public function getData($key)
    {
        return isset($this->data[$key]) ? $this->data[$key] : null;
    }

    public function setData($values = array())
    {
        foreach ($values as $key => $value) {
            $this->$key = $value;
        }
        return $this;
    }

    public function __get($key)
    {
        return $this->data[$key];
    }

    public function __set($key, $value)
    {
        $this->data[$key] = $value;
    }
}
