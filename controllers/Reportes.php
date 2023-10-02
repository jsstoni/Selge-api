<?php
/**
 * reportes
 */

namespace controllers;

use src\Controller;
use src\View;
use src\Helper;
use GuzzleHttp\Client;
use Dompdf\Dompdf;

class Reportes extends Controller
{
    public function index($request)
    {
        $inventario = $this->getModel('Inventario');
        $reportes = array_map(function($n) {
            return $n['total_mes'] == '' ? 0 : $n['total_mes'];
        }, $inventario->reportes());
        $gp = $inventario->gananciaspromedio();
        echo json_encode(array('resultado' => array('data' => $reportes, 'ganancias' => $gp)));
    }

    public function widget($request)
    {
        $id = 'acc_5G9jo9MTX1MoOP8r';
        $link = 'link_oObKGalij73XP8y5_token_-7n-pyVy4zSB9nztk43y6tmn';
        $url = "https://api.fintoc.com/v1/accounts/{$id}/movements?link_token={$link}";
        $client = new Client();
        $response = $client->request('GET', $url, [
            'headers' => [
                'Accept' => 'application/json',
                'Authorization' => 'sk_test_H5XwhzG-FciM8Wt2Eyz7g_BPQz4tNzcx'
            ]
        ]);
        echo $response->getBody();
    }
}
