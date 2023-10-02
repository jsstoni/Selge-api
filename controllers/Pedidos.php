<?php
/**
 *
 */
namespace controllers;

use src\Controller;
use src\View;
use src\Helper;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;
use Dompdf\Dompdf;
use GuzzleHttp\Client;

class Pedidos extends Controller
{
    public function index($request)
    {
    }

    public function allProducts($request)
    {
        $inventario = $this->getModel('Inventario');
        $lista = Helper::rowImage($inventario->todosProductos());
        if (sizeof($lista) < 1) {
            echo json_encode(array('resultado' => array('error' => 'No hay productos')));
        } else {
            echo json_encode(array('resultado' => array('lista' => $lista)));
        }
    }

    public function guardar($request)
    {
        $inventario = $this->getModel('Inventario');
        $npedido = $inventario->ultimaOrden();
        $data = $request->getInputs();

        $fecha = date("Y-m-d");
        $code = Helper::getRandomString(12);
        switch (true) {
            case (sizeof($data['producto']) <= 0):
                echo json_encode(array("resultado" => array('error' => 'No hay productos en la lista')));
                return;
                break;
            case (empty($data['empresa'])):
                echo json_encode(array("resultado" => array('error' => 'Complete la información de delivery')));
                return;
                break;
            case (empty($data['rut'])):
                echo json_encode(array("resultado" => array('error' => 'Seleccione un cliente')));
                return;
                break;
        }

        $sku = array_column($data['producto'], 'ID');
        $opciones = $inventario->obtenerOpciones($sku);
        $list = array_reduce($opciones, function($result, $item) {
            $result[$item['ID']] = json_decode($item['opciones'], true);
            return $result;
        }, array());

        $disponible = 0;
        $pedir = array();

        foreach ($data['producto'] as $key => $item) {
            $enStock = 0;
            $stock = $list[$item['ID']];
            $opcion = $item['opcion'];
            $cantidad = $item['cantidad'];
            $margen = $item['margen'] ?? 0;
            $key = array_search($item['ID'], array_column($opciones, 'ID'));
            $precio = $opciones[$key]['precio'] ?? 0;
            foreach($stock as $n => $value) {
                if ($value['name']  == $opcion) {
                    $precio = $value['precio'] == 0 ? $precio : $value['precio'];
                    $disponible = $value['stock'];
                    $enStock = 1;
                    if ($cantidad > $disponible) {
                        echo json_encode(array("resultado" => array("error" => "La cantidad del producto: {$item['producto']} no esta disponible")));
                        return;
                    }else {
                        $list[$item['ID']][$n]['stock'] = $disponible - $cantidad;
                    }
                }
            }
            $restante[$item['ID']] = json_encode($list[$item['ID']]);
            $pedir[] = array(
                "ID" => $item['ID'],
                "sku" => $item['sku'],
                "producto" => $item['producto'],
                'precio' => $precio,
                "opciones" => $item['opcion'],
                "cantidad" => $item['cantidad'],
                "nota" => $item['nota'],
                "existe" => $enStock,
                "empresa" => $data['empresa'],
                "pago" => $data['pago'],
                "npedido" => $npedido,
                "fecha" => $fecha,
                'order_id' => $code,
                "serial" => Helper::getRandomString(9),
                "rut" => $data['rut'],
                "usuario" => Helper::getAuthorization(),
                "producir" => 1,
                "estado" => 1,
                "restante" => $restante
            );
        }
        if (sizeof($pedir) > 0) {
            if ($inventario->hacerPedido($pedir, $restante)) {
                echo json_encode(array("resultado" => array('mensaje' => $code)));
            } else {
                echo json_encode(array("resultado" => array('error' => 'Error al guardar pedido')));
            }
        } else {
            echo json_encode(array("resultado" => array('error' => 'No puede ser enviado el pedido')));
        }
    }

    public function orden($request)
    {
        $req = $request->getAllParams();
        $id = $req->id;
        if (isset($id)) {
            $inventario = $this->getModel('Inventario');
            $inventario->setData(array('id' => $id));
            $lista = Helper::rowImage($inventario->orden());
            echo json_encode(array('resultado' => array('lista' => $lista, 'orden' => $id)));
        } else {
            echo json_encode(array('resultado' => array('error' => "No hay una id de orden")));
        }
    }

    public function historial($request)
    {
        $req = $request->getAllParams();
        $page = $req->page ?? 1;
        $orden = $req->orden;
        $medio = $req->medio;
        $estado = $req->estado;

        $inventario = $this->getModel('Inventario');
        $lista = $inventario->historialPedidos($page ?? 1);
        $status = $inventario->statusPedidos();

        if (sizeof($lista['result']) > 0) {
            echo json_encode(array('resultado' => array('status' => $status, 'lista' => $lista['result'], 'numeroDePaginas' => $lista['pages'])));
        } else {
            echo json_encode(array('resultado' => array('error' => 'No se encontraron pedidos')));
        }
    }

    public function ordenDetalles($request)
    {
        $req = $request->getAllParams();
        $id = $req->id;
        if (!empty($id)) {
            $inventario = $this->getModel('Inventario');
            $inventario->setData(array('id' => $id));
            $lista = Helper::rowImage($inventario->ordenDetalles());
            if (sizeof($lista) > 0) {
                echo json_encode(array('resultado' => array('lista' => $lista)));
            } else {
                echo json_encode(array('resultado' => array('error' => 'no se encontro resultado')));
            }
        } else {
            echo json_encode(array("resultado" => array('error' => 'No existe orden')));
        }
    }

    public function enstock($request)
    {
        $req = $request->getInputs();
        $id = $req['id'] ?? 0;
        $disponible = $req['disponible'] ?? 0;
        if (isset($id) && !empty($id)) {
            $inventario = $this->getModel('Inventario');
            $inventario->setData(array('id' => $id, 'disponible' => $disponible));
            if ($inventario->pedidoCompletado()) {
                echo json_encode(array('resultado' => array('mensaje' => 'Disponibilidad producto actualizado')));
            }else {
                echo json_encode(array('resultado' => array('error' => 'No se pudo completar')));
            }
        }else {
            echo json_encode(array('resultado' => array('error' => 'No selecciono ningún producto')));
        }
    }

    public function solicitar($request)
    {
        $req = $request->getInputs();
        $code = Helper::getRandomString(12);

        if (sizeof($req['productos']) >= 1) {
            $solicitar = array();
            foreach ($req['productos'] as $k => $v) {
                $solicitar[] = array('id_pedido' => $v['ID'], 'cantidad' => $v['pedir'], 'code' => $code, 'usuario' => Helper::getAuthorization(), 'fecha' => date('Y-m-d'));
            }

            $inventario = $this->getModel('Inventario');
            if ($inventario->solicitarPedido($solicitar)) {
                echo json_encode(array('resultado' => ['mensaje' => 'Se envio la solicitud']));
            } else {
                echo json_encode(array('resultado' => ['error' => 'Hubo un error al enviar la solicitud']));
            }

            /*$ids = array_column($solicitar, 'id_pedido');
            $pedidos = $inventario->informeSolicitado($ids);
            $informe = array_map(function ($p) use ($solicitar) {
                $key = array_search($p['ID'], array_column($solicitar, 'id_pedido'));
                $p['nota'] = $solicitar[$key]['nota'];
                $p['image'] = ($p['sku'] == 'P.E' || $p['image'] == '') ? View::newMedia('image', 'default.jpg') : View::newMedia('upload', $p['image']);
                return $p;
            }, $pedidos);

            /*ob_start();
            $template = View::render('informe', array('lista' => $informe));
            ob_end_clean();
            
            /*$dompdf = new Dompdf(array('enable_remote' => true));
            $dompdf->set_option('isHtml5ParserEnabled', true);
            $dompdf->loadHtml($template);
            $dompdf->render();
            $file = $dompdf->output();

            $mail = new PHPMailer(true);
            $body = '<h1>Nuevo pedido '.date("d-m-y").'</h1>';
            $body .= 'Código del pedido: '.$code.'<br />';
            $body .= 'Accede a <a href="http://localhost:8080">ingresar el código</a>';
            try {
                $mail->IsSMTP();
                $mail->SMTPAuth = true;
                $mail->SMTPSecure = 'ssl';
                $mail->Host = 'smtp.gmail.com';
                $mail->Port = 465;
                $mail->IsHTML(true);
                $mail->Username = 'jsstoniha@gmail.com';
                $mail->Password = 'ddr2hajesus';
                $mail->From = "jsstoniha@gmail.com";
                $mail->Subject = "Nuevo pedido: ".date("d-m-Y");
                $mail->AddAddress($proveedorDatos[0]['email']);
                $mail->Body = $body;
                $mail->addStringAttachment($file, 'Pedidos.pdf');
                $mail->Send();
                //codigo solicitar
            } catch (Exception $e) {
                echo json_encode(array('resultado' => ["error" => "No pudo ser enviado el correo"]));
            }*/
        } else {
            echo json_encode(array('resultado' => ["error" => "Sin productos seleccionados"]));
        }
    }

    public function listarOrdenes($request)
    {
        $req = $request->getAllParams();
        $page = $req->page ?? 1;
        $inventario = $this->getModel('Inventario');
        $resultado = $inventario->listarOrdenes($page);
        $lista = Helper::rowImage($resultado['result']);
        if (sizeof($lista) < 1) {
            echo json_encode(array('resultado' => array('error' => 'No hay ordenes disponibles')));
        } else {
            echo json_encode(array('resultado' => array('lista' => $lista, 'numeroDePaginas' => $resultado['pages'])));
        }
    }

    public function verOrden($request)
    {
        $req = $request->getAllParams();
        $id = $req->id ?? null;
        if ((isset($id) && !empty($id))) {
            $inventario = $this->getModel('Inventario');
            $detalles = $inventario->detallesSolicitud($id);
            if (sizeof($detalles) < 1) {
                echo json_encode(array('resultado' => array('error' => 'No existe orden')));
            }else {
                echo json_encode(array('resultado' => array('lista' => $detalles)));
            }
        }else {
            echo json_encode(array('resultado' => array('error' => 'No se encontro')));
        }
    }

    public function completarSolicitud($request)
    {
        $req = $request->getInputs();
        $id = $req['id']; // array
        if (sizeof($id) > 0) {
            $inventario = $this->getModel('Inventario');
            $completar = $inventario->setData(array('id' => $id))->completarSolicitud();
            if ($completar) {
                echo json_encode(array('resultado' => array('mensaje' => 'Productos confirmados')));
            } else {
                echo json_encode(array('resultado' => array('error' => 'Hubo un error')));
            }
        } else {
            echo json_encode(array('resultado' => array('error' => 'No hay información para completar')));
        }
    }

    public function cancelarProducto($request)
    {
        $req = $request->getAllParams();
        $id = $req->id ?? null;
        if (isset($id) && !empty($id)) {
            $inventario = $this->getModel('Inventario');
            $cancelar = $inventario->setData(array('id' => $id))->cancelarProducto();
            if ($cancelar) {
                echo json_encode(array('resultado' => array('mensaje' => 'el producto para el pedido fue anulado')));
            }else {
                echo json_encode(array('resultado' => array('error' => 'Hubo un error al anular el producto')));
            }
        }else {
            echo json_encode(array('resultado' => array('error' => 'No selecciono ningún producto')));
        }
    }

    public function cambios($request)
    {
        View::assignedMenu(6.4);
        $req = $request->getAllParams();
        $page = $req->page ?? 1;
        $inventario = $this->getModel('Inventario');
        $resultado = $inventario->listaCambios($page);
        if (sizeof($resultado['result']) < 1) {
            echo json_encode(array('resultado' => array('error' => 'No hay cambios realizados')));
        } else {
            echo json_encode(array('resultado' => array('lista' => $resultado['result'], 'numeroDePaginas' => $resultado['pages'])));
        }
    }

    public function despachar($request)
    {
        $req = $request->getAllParams();
        $productos = $req->productos; //array = id
        $empresa = $req->empresa;
        $guia = $req->guia;
        $costo = $req->costo;
        $enviar = array();
        if (!empty($guia) && !empty($empresa) && sizeof($productos) > 0) {
            $inventario = $this->getModel('Inventario');
            foreach ($productos as $key => $value) {
                $enviar[] = array('id_pedido' => $value, 'empresa' => $empresa, 'guia' => $guia, 'costo' => $costo, 'fecha' => date("Y-m-d"), 'usuario' => 1);
            }
            if ($inventario->despacharProductos($enviar)) {
                echo json_encode(array('resultado' => 'Guía enviada'));
            } else {
                echo json_encode(array('error' => 'Hubo un error'));
            }
        } else {
            echo json_encode(array('error' => 'Complete formulario'));
        }
    }

    public function buscarOrden($request)
    {
        $req = $request->getAllParams();
        $search = $req->q ?? null;
        if (isset($search) && !empty($search)) {
            $inventario = $this->getModel('Inventario');
            $busqueda = $inventario->setData(array('busqueda' => $search))->buscarOrden();
            if (sizeof($busqueda) > 0) {
                echo json_encode(array('resultado' => array('lista' => Helper::rowImage($busqueda))));
                return;
            }
        }
        echo json_encode(array('resultado' => array('error' => 'No se encontraron resultados')));
    }

    public function test()
    {
        $url = new Client();
        $resp = $url->request('GET', 'https://gateway.starken.cl/agency/city');
        $json = $resp->getBody();
        $array = json_decode($json, true);
        $items = array_map(function ($a) {
            //var_dump($a);
            return array_intersect_key($a, array_flip(array("code_dls", "name")));
        }, $array);
        echo json_encode($items);
    }

    public function test2($request)
    {
        $req = $request->getAllParams();
        $servicio = $req->servicio;
        $origen = $req->origen;
        $destino = $req->destino;
        $ancho = $req->ancho;
        $largo = $req->largo;
        $alto = $req->alto;
        $peso = $req->peso;
        $data = array('run' => '', 'alto' => $alto, 'ancho' => $ancho, 'kilos' => $peso, 'largo' => $largo, 'destino' => $destino, 'origen' => $origen, "bulto" => "PAQUETE", "servicio" => "NORMAL", "entrega" => "AGENCIA", "caja_tarifa" => true, "descuento" => true);
        $client = new Client();
        $r = $client->request('POST', 'https://gateway.starken.cl/quote/cotizador', ['json' => $data]);
        echo json_encode(json_decode($r->getBody(), true));
    }
}
