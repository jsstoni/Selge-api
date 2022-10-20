<?php
namespace models;

use src\Helper;
use src\Model;

class Imagen extends Model
{
    public function uploadImage()
    {
        $target_dir = ROOT . 'assets' . DS . 'upload' . DS;
        $uploadok = 0;
        if (isset($_FILES['file'])) {
            $target_file = $target_dir . basename($_FILES['file']['name']);
            $imageType = strtolower(pathinfo($target_file, PATHINFO_EXTENSION));
            @$check = getimagesize($_FILES['file']['tmp_name']);
            if ($check !== false) {
                $uploadok = 1;
            } else {
                $uploadok = 0;
            }

            if ($imageType != 'jpg' && $imageType != 'png' && $imageType != 'jpeg' && $imageType != 'gif') {
                $uploadok = 0;
            }
            if ($uploadok == 1) {
                $imageUpload = Helper::getRandomString().".".$imageType;
                $fileUplad = $target_dir . $imageUpload;
                if (move_uploaded_file($_FILES['file']['tmp_name'], $fileUplad)) {
                    chmod($fileUplad, 0755);
                    return $imageUpload;
                }
            }
        }
    }
}
