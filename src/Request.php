<?php
namespace src;

class Request
{
    public $get;
    public $post;
    public $params;
    public function __construct(array $get, array $post)
    {
        $this->get = $get;
        $this->post = $post;
    }

    public function getAllParams()
    {
        $this->params = array_merge($this->get, $this->post);
        return $this;
    }

    public function getAllPost()
    {
        return $this->post;
    }

    public function getInputs()
    {
        return json_decode(file_get_contents('php://input'), true);
    }
    
    public function __get($key)
    {
        return $this->params[$key] ?? null;
    }
}
