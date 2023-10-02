<?php
/**
 * Inventario
 */

namespace controllers;

use src\Controller;
use src\View;
use src\Helper;
use GuzzleHttp\Client;

class Inventario extends Controller
{
	public function index($request)
	{
		$inventario = $this->getModel('Inventario');
		$colecciones = $this->getModel('Colecciones');
		$categorias = $colecciones->lista();
		$req = $request->getAllParams();
		$page = $req->page ?? 1;

		$resultado = $inventario->listaProducto($page);

		$lista = Helper::rowImage($resultado['result']);
		// $e = apache_request_headers();
		// var_dump($e['token']);
		if (sizeof($lista) < 1) {
			$this->json_error('No se encontraron productos');
		} else {
			$this->json_response(array('categorias' => $categorias, 'lista' => $lista, 'numeroDePaginas' => $resultado['pages']));
		}
	}

	public function buscarProducto($request)
	{
		$req = $request->getAllParams();
		$inventario = $this->getModel('Inventario');
		$inventario->setData(array('id' => $req->id));
		$producto = $inventario->buscarProducto();
		if (sizeof($producto) > 0) {
			$lista = Helper::rowImage($producto);
			$this->json_response(array('lista' => $lista[0]));
		} else {
			$this->json_error('No es posible hacer esto');
		}
	}

	public function nuevoProducto($request)
	{
		$data = $request->getInputs();
		$image = $data['file'] ?? null;
		$sku = $data['sku'] ?? null;
		$producto = $data['producto'] ?? null;
		$atributos = json_encode($data['atributos']) ?? '[]';
		$opciones = json_encode($data['opciones']) ?? '[]';
		$categoria = $data['categoria'] ?? '';
		$precio = $data['precio'] ?? 0;
		$valor = $data['valor'] ?? 0;
		$stock = $data['stock'] ?? 'false';
		$web = $data['web'] ?? 'false';

		$post = (isset($sku) && !empty($sku)) &&
				(isset($producto) && !empty($producto)) &&
				(isset($precio) && !empty($precio));
		if ($post) {
			if (sizeof($data['opciones']) > 0) {
				$inventario = $this->getModel('Inventario');
				$dbImage = $this->fileFormat($image);
				$data = array('sku' => $sku, 'producto' => $producto, 'image' => $dbImage, 'atributos' => $atributos, 'opciones' => $opciones, 'categoria' => $categoria, 'precio' => $precio, 'valor' => $valor, 'stock' => $stock, 'web' => $web, 'fecha' => date("Y-m-d"));
				if ($inventario->guardarProducto($data)) {
					echo json_encode(array('resultado' => array('mensaje' => 'Producto agregado')));
				} else {
					echo json_encode(array('resultado' => array('error' => 'Error para agregar producto')));
				}
			}else {
				echo json_encode(array('resultado' => array('error' => 'Falta por agregar variantes')));
			}
		} else {
			echo json_encode(array('resultado' => array('error' => 'Complete formulario')));
		}
	}

	public function editarProducto($request)
	{
		$data = $request->getInputs();
		$image = $data['image'] ?? null;
		$id = $data['ID'] ?? null;
		$sku = $data['sku'] ?? null;
		$producto = $data['producto'] ?? null;
		$atributos = json_encode($data['atributos']) ?? '[]';
		$opciones = json_encode($data['opciones']) ?? '[]';
		$categoria = $data['categoria'] ?? '';
		$precio = $data['precio'] ?? null;
		$valor = $data['valor'] ?? null;
		$web = $data['web'] ?? 'false';
		$stock = $data['stock'] ?? 'false';

		$post = (isset($id) && !empty($id)) &&
				(isset($sku) && !empty($sku)) &&
				(isset($producto) && !empty($producto)) &&
				(isset($precio) && !empty($precio));
		if ($post) {
			$inventario = $this->getModel('Inventario');
			$dbImage = $this->fileFormat($image);
			$data = array('id' => $id,'sku' => $sku, 'producto' => $producto, 'atributos' => $atributos, 'opciones' => $opciones, 'categoria' => $categoria, 'precio' => $precio, 'valor' => $valor, 'stock' => $stock, 'web' => $web);
			if ($image) {
				$data['image'] = $dbImage;
			}
			if ($inventario->editarProducto($data)) {
				echo json_encode(array('resultado' => array('mensaje' => 'Producto actualizado')));
			} else {
				echo json_encode(array('resultado' => array('error' => 'No se puede actualizar')));
			}
		} else {
			echo json_encode(array('resultado' => array('error' => 'Complete formulario')));
		}
	}

	public function borrarProducto($request)
	{
		$req = $request->getAllParams();
		$id = $req->id ?? null;
		if ($id) {
			$inventario = $this->getModel('Inventario');
			$inventario->setData(array('id' => $id));
			if ($inventario->borrarProducto()) {
				echo json_encode(array('resultado' => array('mensaje' => 'Borrado con éxito')));
			} else {
				echo json_encode(array('resultado' => array('error' => 'Hubo un error al borrar')));
			}
		} else {
			echo json_encode(array('resultado' => array('error' => 'no existe el id')));
		}
	}

	public function categoria()
	{
		$inventario = $this->getModel('Inventario');
		$categorias = $inventario->categoria();
		echo json_encode(array('resultado' => $categorias));
	}

	public function cudCategoria($request) //crear, actualizar, eliminar
	{
		$req = $request->getAllParams();
		$name = $req->categoria;
		$tipo = $req->tipo;
		$inventario = $this->getModel('Inventario');
		switch ($tipo) {
			case 'nuevo':
				$success = $inventario->agregarCategoria(array('nombre' => $name, 'usuario' => 1));
				break;
			case 'editar':
				$id = $req->id;
				$success = $inventario->editarCategoria(array('nombre' => $name), $id);
				break;
			case 'borrar':
				$id = $req->id;
				$success = $inventario->eliminarCategoria($id);
				break;
		}
		if ($success) {
			echo json_encode(array('resultado' => 'Cambios actualizados'));
		} else {
			echo json_encode(array('error' => 'Error al realizar los cambios'));
		}
	}

	public function buscarInventario($request)
	{
	}

	public function subirImage()
	{
		$url = "https://api.imgbb.com/1/upload?key=ae403fe6ae8222192faf40f4c26afdec";
		$image = base64_encode(file_get_contents($_FILES['image']['tmp_name']));
		$client = new Client();
		$res = $client->request('POST', $url, [
			"form_params" => [
				"image" => $image
			]
		]);
		echo $res->getBody();
	}

	public function buscarFormulario($request)
	{
		$req = $request->getAllParams();
		$search = $req->q ?? null;
		if (isset($search) && !empty($search)) {
			$inventario = $this->getModel('Inventario');
			$busqueda = $inventario->setData(array('busqueda' => $search))->formularioBusqueda();
			if (sizeof($busqueda) > 0) {
				echo json_encode(array('resultado' => array('lista' => Helper::rowImage($busqueda))));
				return;
			}
		}
		echo json_encode(array('resultado' => array('error' => 'No se encontraron resultados')));
	}

	public function buscarStock($request)
	{
		$req = $request->getAllParams();
		$search = $req->q ?? null;
		if (isset($search) && !empty($search)) {
			$inventario = $this->getModel('Inventario');
			$busqueda = $inventario->setData(array('busqueda' => $search))->buscarStock();
			if (sizeof($busqueda) > 0) {
				echo json_encode(array('resultado' => array('lista' => Helper::rowImage($busqueda))));
				return;
			}
		}
		echo json_encode(array('resultado' => array('error' => 'No se encontraron resultados')));
	}

	public function obtenerProducto($request)
	{
		echo json_encode(array('nuevo' => 12));
	}
}
