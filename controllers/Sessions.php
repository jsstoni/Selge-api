<?php
namespace controllers;

use src\View;

class Sessions
{
    public function index()
    {
        echo 404;
    }

    public function finish()
    {
        session_unset();
        session_destroy();
        header('Location: '.View::newUrl('/'));
        die();
    }
}
