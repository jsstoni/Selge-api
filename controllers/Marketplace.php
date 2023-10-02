<?php
/**
 * 
 */
namespace controllers;
use src\Controller;
use src\Helper;
class Marketplace extends Controller
{
	public function index($request)
	{
		$inventario = $this->getModel('Marketplace');
		$req = $request->getAllParams();
		$page = $req->page ?? 1;
		$productos = $inventario->dropshipping($page, 16);
		if (sizeof($productos['result']) > 0) {
			echo json_encode(array('resultado' => array('lista' => Helper::rowImage($productos['result']))));
			return;
		}
		echo json_encode(array('resultado' => array('error' => 'No se encontraron resultados')));
	}

	public function importar($request)
	{
		$data = $request->getInputs();
		$id = $data['id'] ?? null;
		if (isset($id) && !empty($id)) {
			$inventario = $this->getModel('Inventario');
			$import = $inventario->setData(array('id' => $id))->importMarketplace();
			if ($import) {
				echo json_encode(array('resultado' => array('mensaje' => 'Producto importado')));
			}else {
				echo json_encode(array('resultado' => array('error' => "Producto no puede ser importado")));
			}
		}
	}
}