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
		$req = $request->getAllParams();
		$page = $req->page ?? 1;

		$resultado = $inventario->listaProducto($page);

		$lista = Helper::rowImage($resultado['result']);
		// $e = apache_request_headers();
		// var_dump($e['token']);
		if (sizeof($lista) < 1) {
			$this->json_error('No se encontraron productos');
		} else {
			$this->json_response(array('lista' => $lista, 'numeroDePaginas' => $resultado['pages']));
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

	public function buscarSku($request)
	{
		$req = $request->getAllParams();
		$id = $req->id;
		if (strtolower($id) == 'p.e') {
			echo json_encode(array("resultado" => array('lista' => array('sku' => 'P.E', 'producto' => 'P.E - ', 'image' => View::newMedia('image', 'default.jpg'), 'precio' => 0, 'precioreal' => 0, 'descuento' => 0, 'opciones' => '', 'options' => '[]', 'cantidad' => 1, 'producir' => 1, 'atributos' => '[]', 'nota' => ''))));
		} else {
			$inventario = $this->getModel('Inventario');
			$inventario->setData(array('id' => $id));
			$lista = Helper::rowImage($inventario->buscarSku());
			if (sizeof($lista) > 0) {
				echo json_encode(array('resultado' => array("lista" => $lista[0])));
			} else {
				echo json_encode(array("resultado" => array('error' => 'No se encontro el producto')));
			}
		}
	}

	public function ImportarProductos($request)
	{
		Helper::newResource('nuovo/spreadsheet-reader/php-excel-reader/excel_reader2.php');
		Helper::newResource('nuovo/spreadsheet-reader/SpreadsheetReader.php');
		$allowedFileType = ['application/vnd.ms-excel','text/xls','text/xlsx','application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'application/octet-stream', 'text/csv'];
		if (isset($_FILES['archivo']['type'])) {
			if (in_array($_FILES["archivo"]["type"], $allowedFileType)) {
				$path = ROOT . 'assets' . DS . 'CSV';
				$targetPath = $path.'/'.$_FILES['archivo']['name'];
				move_uploaded_file($_FILES['archivo']['tmp_name'], $targetPath);
				@$reader = new \SpreadsheetReader($targetPath);
				$req = $request->getAllParams();
				$col_sku = $req->sku;
				$col_producto = $req->producto;
				$col_precio = $req->precio;
				$col_categoria = $req->categoria;
				$col_image = $req->image;
				$fila = $req->fila ?? 0;

				if ((!empty($col_sku)) && (!empty($col_producto)) && (!empty($col_precio)) && (!empty($col_categoria)) && (!empty($col_image))) {
					$resultado = array();
					foreach ($reader as $key => $row) {
						if ($key == 0) {
							if ($fila == "true") {
								continue;
							}
						}
						$sku = $row[$col_sku - 1] ?? Helper::getRandomString(8);
						$producto = $row[$col_producto - 1] ?? '';
						$categoria = $row[$col_categoria - 1] ?? 'Sin Categoría';
						$precio = $row[$col_precio - 1] ?? 0;
						$image = $row[$col_image - 1] ?? '';
						$resultado[] = array('usuario' => 1,'sku' => $sku, 'image' => $image, 'producto' => $producto, 'categoria' => $categoria, 'precio' => $precio, 'atributos' => '[]', 'activo' => 1, 'fecha' => date("Y-m-d"));
					}
					$categorias = array_map(function ($e) {
						return ['nombre' => $e['categoria'], 'usuario' => $e['usuario']];
					}, $resultado);
					$dataCategoria = array_unique($categorias, SORT_REGULAR);
					$inventario = $this->getModel('Inventario');
					if ($inventario->agregarCategoria($dataCategoria)) {
						if ($inventario->importarProductos($resultado)) {
							echo json_encode(array('success' => "Productos importados"));
						} else {
							echo json_encode(array('error' => "Error al subir productos"));
						}
					} else {
						echo json_encode(array('error' => 'Error para generar las categorías'));
					}
				} else {
					echo json_encode(array("error" => "Complete el orden de las columnas"));
				}
			} else {
				echo json_encode(array('error' => "Tipo de archivo no permitido"));
			}
		} else {
			echo json_encode(array('error' => 'Seleccione archivo a subir'));
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
		$categoria = $data['categoria'] ?? null;
		$precio = $data['precio'] ?? null;
		$descuento = $data['descuento'] ?? null;
		$stock = $data['stock'] ?? 'false';
		$web = $data['web'] ?? 'false';

		$post = (isset($sku) && !empty($sku)) &&
				(isset($producto) && !empty($producto)) &&
				(isset($precio) && !empty($precio)) &&
				(isset($categoria) && !empty($categoria));
		if ($post) {
			if (sizeof($data['opciones']) > 0) {
				$inventario = $this->getModel('Inventario');
				$dbImage = $this->fileFormat($image);
				$data = array('sku' => $sku, 'producto' => $producto, 'image' => $dbImage, 'atributos' => $atributos, 'opciones' => $opciones, 'categoria' => $categoria, 'precio' => $precio, 'descuento' => $descuento, 'stock' => $stock, 'web' => $web, 'fecha' => date("Y-m-d"));
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
		$image = $data['file'] ?? null;
		$id = $data['ID'] ?? null;
		$sku = $data['sku'] ?? null;
		$producto = $data['producto'] ?? null;
		$atributos = json_encode($data['atributos']) ?? '[]';
		$opciones = json_encode($data['opciones']) ?? '[]';
		$categoria = $data['categoria'] ?? null;
		$precio = $data['precio'] ?? null;
		$descuento = $data['descuento'] ?? 0;
		$web = $data['web'] ?? 'false';
		$stock = $data['stock'] ?? 'false';

		$post = (isset($id) && !empty($id)) &&
				(isset($sku) && !empty($sku)) &&
				(isset($producto) && !empty($producto)) &&
				(isset($precio) && !empty($precio)) &&
				(isset($categoria) && !empty($categoria));
		if ($post) {
			$inventario = $this->getModel('Inventario');
			$dbImage = $this->fileFormat($image);
			$data = array('id' => $id,'sku' => $sku, 'producto' => $producto, 'atributos' => $atributos, 'opciones' => $opciones, 'categoria' => $categoria, 'precio' => $precio, 'descuento' => $descuento, 'stock' => $stock, 'web' => $web);
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

	public function existencia()
	{
		$inventario = $this->getModel('Inventario');
		$lista = Helper::rowImage($inventario->existencia());
		if (sizeof($lista) < 1) {
			echo json_encode(array('resultado' => ['error' => 'No hay existencia de productos']));
		} else {
			echo json_encode(array('resultado' => ['lista' => $lista]));
		}
	}

	public function verExistencia($request)
	{
		$req = $request->getAllParams();
		$inventario = $this->getModel('Inventario');
		$inventario->setData(array('id' => $req->id));
		$existencia = $inventario->verExistencia();
		if (sizeof($existencia) > 0) {
			echo json_encode(array('resultado' => array('lista' => $existencia[0])));
		} else {
			echo json_encode(array('resultado' => array('error' => 'no existe')));
		}
	}

	private function _checkDuplicateOpcion($arr)
	{
		$checkList = array();
		$listRepeat = array();
		foreach ($arr as $keys) {
			if (in_array($keys, $checkList)) {
				$listRepeat[] = $keys;
			}
			$checkList[] = $keys;
		}
		return $listRepeat;
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
