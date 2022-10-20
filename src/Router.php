<?php
/**
 * Router
 */
namespace src;

use src\Request;

final class Router
{
    private $_requestUrl;
    private $_mainFolder;
    private $_requestPost = array();
    private $_requestGet = array();
    private $_subdominio = false;

    public function __construct()
    {
        $this->setUrl($_SERVER['REQUEST_URI']);
        $this->setSubdominio($_SERVER['HTTP_HOST']);
    }

    private function setUrl($request)
    {
        $this->_requestUrl = $request;
    }

    public function getUrl()
    {
        return $this->_requestUrl;
    }

    public function setMain($folder = '/')
    {
        $folder = $folder == '/' ? '.' : ltrim($folder, '/');
        define('URLBASE', $folder);
        $this->_mainFolder = $folder;
    }

    public function setSubdominio($server)
    {
        $url = explode(".", $server);
        $this->_subdominio = sizeof($url) > 2 ? $url[0] != 'www' ? $url[0] : false : false;
    }

    private function _getMain()
    {
        $this->_mainFolder = (!empty($this->_mainFolder)) ? $this->_mainFolder : '/';
        return $this->_mainFolder;
    }

    private function setPost($str, $key)
    {
        $this->_requestPost[$key] = $str ?: false;
    }

    private function setGet($str, $key)
    {
        $this->_requestGet[$key] =  $str ?: false;
    }

    private function _call(string $ctr, string $method, Request $args)
    {
        $controller = "controllers\\{$ctr}"; //el controlador a cargar
        if (class_exists($controller)) {
            if (method_exists(new $controller, $method)) {
                call_user_func_array(array(new $controller, $method), array($args));
            } else {
                echo "NO existe {$method} en el controlador '{$controller}'";
            }
        } else {
            echo "NO existe el controlador '{$controller}'";
        }
    }

    public function run()
    {
        $url = str_replace('/'.$this->_getMain().'/', '/', $this->getUrl());
        array_walk($_POST, array(&$this, 'setPost'));
        $query = parse_url($url, PHP_URL_QUERY);
        if ($query) {
            foreach (explode('&', $query) as $key => $value) {
                list($name, $value) = explode('=', $value, 2);
                $this->setGet($value, $name);
            }
        }
        $url = str_replace('?'.$query, "", $url); //quitar parametros de la url
        $component = explode("/", ltrim($url, '/')); // 0 = class, 1 = metodo
        $control = ($url == '/' || $url == '') ? 'Defecto' : ucwords($component[0]); // controlador inicio
        $method = (!empty($component[1])) ? $component[1] : 'Index'; // metodo
        $this->_call($control, $method, new Request($this->_requestGet, $this->_requestPost));
    }
}
