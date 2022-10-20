<?php
namespace controllers;

use src\Controller;
use src\View;
use src\Helper;
use Automattic\WooCommerce\Client;

class Aplicaciones extends Controller
{
    public function index($req)
    {
    }

    public function woocommerce() {
        $woocommerce = new Client(
          'http://localhost/wp/',
          'ck_6df2de4d2829fe35f29e4c7888ee66e83a0dfbed',
          'cs_f41a3ea2442f55f83deca15e341903dbb6a3be7c',
          [
            'version' => 'wc/v3',
          ]
        );
        $result = $woocommerce->get('products');
        $a = array();
        foreach ($result as $key => $value) {
          $sku = $value->sku;
          $precio = $value->price;
          $producto = $value->name;
          $a[$key] = array('producto' => $producto,'sku' => $sku, 'precio' => $precio);
          foreach($value->attributes as $atributos) {
            $a[$key]['atributos'][] = array('opcion' => $atributos->name, 'opciones' => array_map(function($n) {
              return array('valor' => $n);
            }, $atributos->options));
          }
          /*$variants = $woocommerce->get("products/{$value->id}/variations");
          $opciones = array();
          foreach ($variants as $variante) {
            foreach ($variante->attributes as $varAtribute) {
              $opciones[] = array('name' => "{$varAtribute->name}: {$varAtribute->option}", 'precio' => isset($variante->price) ?? $variante->price, 'stock' => $variante->stock_quantity, 'sku' => $variante->sku);
            }
          }
          $a[$key]['opciones'][] = json_encode($opciones);*/
        }
        var_dump($result);
    }
}
