<?php
namespace controllers;
use src\Controller;
class Colecciones extends Controller
{
	public function index($request)
	{
		$colecciones = $this->getModel('Colecciones');
		$lista = $colecciones->lista();
		if (sizeof($lista) > 0) {
			echo json_encode(array('resultado' => array('lista' => $lista)));
		}else {
			echo json_encode(array('resultado' => array('error' => 'No se encontraron colecciones')));
		}
	}

	public function crear($request)
	{
		$data = $request->getInputs();
		$tags = $data['tags'] ?? '';
		$id = $data['id'] ?? false;
		if (!empty($tags)) {
			$colecciones = $this->getModel('Colecciones');
			$colecciones->setData(array('tags' => $tags, 'id' => $id));
			if ($colecciones->crear()) {
				echo json_encode(array('resultado' => array('mensaje' => 'Colecciones actualizadas')));
			}else {
				echo json_encode(array('resultado' => array('error' => 'Error al crear la colección')));
			}
		}else {
			echo json_encode(array('resultado' => array('error' => 'Añade un nombre')));
		}
	}

	public function borrar($request)
	{
		$data = $request->getInputs();
		$id = $data['id'] ?? false;
		if (!empty($id)) {
			$colecciones = $this->getModel('Colecciones');
			$colecciones->setData(array('id' => $id));
			if ($colecciones->borrar()) {
				echo json_encode(array('resultado' => array('mensaje' => 'Eliminado con éxito')));
			}else {
				echo json_encode(array('resultado' => array('error' => 'hubo un error')));
			}
		}else {
			echo json_encode(array('resultado' => array('error' => 'No es posible eliminar')));
		}
	}
}