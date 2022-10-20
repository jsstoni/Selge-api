<?php
namespace src;

class Helper
{
    private static $method = "aes-256-ecb";
    private static $clave = "cE&ED#24=BE&C937E.=8";
    public static function rowImage($list)
    {
        return array_map(function ($i) {
            $i['image'] = ($i['sku'] == 'P.E' || $i['image'] == '') ? View::newMedia('image', 'default.jpg') : View::newMedia('upload', $i['image']);
            return $i;
        }, $list);
    }

    public static function codificar($id)
    {
        $iv = base64_encode(openssl_random_pseudo_bytes(openssl_cipher_iv_length(self::$method)));
        return base64_encode(openssl_encrypt(
            $id, //string a codificar
            self::$method,
            self::$clave,
            true,
            $iv
        ));
    }

    public static function descodificar($code)
    {
        $iv = base64_encode(openssl_random_pseudo_bytes(openssl_cipher_iv_length(self::$method)));
        $valor = base64_decode($code);
        return openssl_decrypt($valor, self::$method, self::$clave, true, $iv);
    }

    public static function getAuthorization()
    {
        $headers = apache_request_headers();
        if (isset($headers['Authorization'])) {
            return self::descodificar($headers['Authorization']);
        }
        return false;
    }

    public static function getAuthorizationNoDecode()
    {
        $headers = apache_request_headers();
        if (isset($headers['Authorization'])) {
            return $headers['Authorization'];
        }
        return false;
    }

    public static function getRandomString($lng = 12)
    {
        $charset = '0123456789ABCDEFabcdef';
        $randString = "";

        while (strlen($randString) < $lng) {
            $randChar = substr(str_shuffle($charset), mt_rand(0, strlen($charset)), 1);
            $randString .= $randChar;
        }
        return $randString;
    }

    public static function newResource($fname)
    {
        $path = ROOT . 'assets' . DS . 'vendor' . DS . $fname;
        if (file_exists($path)) {
            require_once $path;
        }
    }

    public static function generatePagination($currentPage, $totalPages, $pageLinks = 8, $urlPage = '')
    {
        if ($totalPages <= 1) {
            return null;
        }
        $html = '';
        $leeway = floor($pageLinks / 2);
        $firstPage = $currentPage - $leeway;
        $lastPage = $currentPage + $leeway;
        if ($firstPage < 1) {
            $lastPage += 1 - $firstPage;
            $firstPage = 1;
        }
        if ($lastPage > $totalPages) {
            $firstPage -= $lastPage - $totalPages;
            $lastPage = $totalPages;
        }
        if ($firstPage < 1) {
            $firstPage = 1;
        }

        $linkPage = strpos($urlPage, '?') ? "{$urlPage}&page=" : "{$urlPage}?page=";
        
        if ($firstPage != 1) {
            $html .= '<li class="page-item"><a href="'.View::newUrl("{$linkPage}1").'" class="page-link">1</a></li>';
            $html .= '<li class="page-item"><a href="#" class="page-link">...</a></li>';
        }
        for ($i = $firstPage; $i <= $lastPage; $i++) {
            if ($i == $currentPage) {
                $html .= '<li class="page-item"><a href="'.View::newUrl("{$linkPage}{$i}").'" class="page-link">' . $i . '</a></li>';
            } else {
                $html .= '<li class="page-item"><a href="'.View::newUrl("{$linkPage}{$i}").'" class="page-link">' . $i . '</a></li>';
            }
        }
        if ($lastPage != $totalPages) {
            $html .= '<li class="page-item"><a href="#" class="page-link">...</a></li>';
            $html .= '<li class="page-item"><a href="'.View::newUrl("{$linkPage}{$totalPages}").'" class="page-link">' . $totalPages . '</a></li>';
        }
        $html .= '';
        return $html;
    }
}
