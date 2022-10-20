<?php
namespace models;

use src\Model;
use src\Helper;
class Marketplace extends Model
{
	private $token;
    public function __construct()
    {
        $this->token = Helper::getAuthorization();
    }
	public function dropshipping()
    {
        return self::getResult("SELECT p.ID, p.sku, p.image, p.producto, p.atributos, p.opciones, p.precio, u.nombre AS proveedor FROM productos AS p LEFT JOIN usuarios AS u ON (p.proveedor = u.ID) WHERE p.web = 'true' AND proveedor <> '{$this->token}'");
    }
}