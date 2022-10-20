<?php
/**
 * Controllers
 */
namespace src;

use src\Helper;

abstract class Controller
{
    abstract protected function index($req);

    public function getModel(string $name)
    {
        $model = "models\\{$name}";
        if (class_exists($model)) {
            return new $model;
        }
    }

    public function json_error($text)
    {
        echo json_encode(array('resultado' => array('error' => $text)));
    }

    public function json_response($array  = [])
    {
        echo json_encode(array('resultado' => $array));
    }

    public function fileFormat($img)
    {
        if ($img) {
            $image = explode(",", $img);
            $extension = "";
            switch (true) {
                case strpos($image[0], 'jpeg'):
                    $extension = ".jpeg";
                    break;
                case strpos($image[0], 'jpg'):
                    $extension = ".jpg";
                    break;
                case strpos($image[0], 'png'):
                    $extension = ".png";
                    break;
                case strpos($image[0], 'svg'):
                    $extension = ".svg";
                    break;
                case strpos($image[0], 'tiff'):
                    $extension = ".tiff";
                    break;
                case strpos($image[0], 'webp'):
                    $extension = ".webp";
                    break;
                default:
                    $extension = ".jpeg";
                    break;
            }
            $fileName = Helper::getRandomString(12).$extension;
            $file = ROOT . 'assets' . DS . 'upload' . DS . $fileName;
            if (file_put_contents($file, file_get_contents($img))) {
                return $fileName;
            }
        }
        return "";
    }
}
