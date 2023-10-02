<?php
/**
 * Usuario
 */

namespace controllers;

use src\Controller;
use src\View;
use src\Helper;

class Usuario extends Controller
{
    public function index($req)
    {
    }

    public function seleccionarUsuario($request)
    {
        $data = $request->getInputs();
        $usuario = $this->getModel('Usuario');
        $usuario->setData(array('id' => $data['id'], 'table' => $data['tipo']));
        $cliente = $usuario->seleccionarUsuario();
        if (sizeof($cliente) > 0) {
            echo json_encode(array('resultado' => array('usuario' => $cliente[0])));
        } else {
            echo json_encode(array('resultado' => array('error' => 'No existe')));
        }
    }

    public function buscar($request)
    {
        $data = $request->getInputs();
        $busqueda = $data['busqueda'];
        $tipo = $data['tipo'];
        $usuario = $this->getModel('Usuario');
        $usuario->setData(array('id' => $busqueda));
        echo json_encode(array('resultado' => $usuario->buscar($tipo)));
    }

    public function buscarUsuarios($request)
    {
        $data = $request->getInputs();
        $rut = $data['rut'];
        $tipo = $data['tipo'];
        $usuarios = $this->getModel('Usuario');
        $usuarios->setData(array('rut' => $rut));
        $cliente = $usuarios->buscarUsuarios($tipo);
        if (sizeof($cliente) > 0) {
            echo json_encode(array('resultado' => array('cliente' => $cliente[0])));
        } else {
            echo json_encode(array('resultado' => array('error' => 'No existe')));
        }
    }

    public function nuevoUsuarios($request)
    {
        $data = $request->getInputs();
        $nombre = $data['nombre'] ?? null;
        $rut = $data['rut'] ?? null;
        $phone = $data['phone'] ?? null;
        $email = $data['email'] ?? null;
        $direccion = $data['direccion'] ?? null;
        $tipo = $data['tipo'] ?? null;

        $post = (isset($nombre) && !empty($nombre)) &&
                (isset($rut) && !empty($rut)) &&
                (isset($phone) && !empty($phone)) &&
                (isset($email) && !empty($email)) &&
                (isset($direccion) && !empty($direccion));
        if ($post) {
            $usuario = $this->getModel('Usuario');
            $data = array(
                'usuario' => Helper::getAuthorization(),
                'nombre' => $nombre,
                'rut' => $rut,
                'phone' => $phone,
                'email' => $email,
                'direccion' => $direccion
            );
            if ($usuario->nuevo($tipo, $data)) {
                echo json_encode(array('resultado' => array('mensaje' => 'Cliente actualizado')));
            } else {
                echo json_encode(array('resultado' => array('error' => 'Hubo un error al agregar')));
            }
        } else {
            echo json_encode(array('resultado' => array('error' => 'Complete el formulario')));
        }
    }

    public function actualizarUsuarios($request)
    {
        $data = $request->getInputs();
        $nombre = $data['nombre'] ?? null;
        $rut = $data['rut'] ?? null;
        $phone = $data['phone'] ?? null;
        $email = $data['email'] ?? null;
        $direccion = $data['direccion'] ?? null;
        $tipo = $data['tipo'] ?? null;
        $id = $data['ID'] ?? null;

        $post = (isset($nombre) && !empty($nombre)) &&
                (isset($rut) && !empty($rut)) &&
                (isset($phone) && !empty($phone)) &&
                (isset($email) && !empty($email)) &&
                (isset($direccion) && !empty($direccion));
        if ($post) {
            $usuario = $this->getModel('Usuario');
            $data = array(
                'usuario' => Helper::getAuthorization(),
                'nombre' => $nombre,
                'rut' => $rut,
                'phone' => $phone,
                'email' => $email,
                'direccion' => $direccion
            );
            if ($id) {
                $result = $usuario->actualizar($tipo, $data, $id);
            }else {
                $result = $usuario->nuevo($tipo, $data);
            }
            if ($result) {
                echo json_encode(array('resultado' => array('mensaje' => 'Cliente actualizado')));
            } else {
                echo json_encode(array('resultado' => array('error' => 'Hubo un error al agregar')));
            }
        } else {
            echo json_encode(array('resultado' => array('error' => 'Complete el formulario')));
        }
    }

    public function borrar($request)
    {
        $data = $request->getAllParams();
        $id = $data->id;
        $tipo = $data->tipo;
        $usuario = $this->getModel('Usuario');
        if ($usuario->borrar($id, $tipo)) {
            echo json_encode(array('resultado' => array("mensaje" => "Usuario eliminado")));
        } else {
            echo json_encode(array('resultado' => array('error' => "Hubo un error al eliminar")));
        }
    }

    public function clientes($request)
    {
        $req = $request->getAllParams();
        $page = $req->page ?? 1;
        $usuarios = $this->getModel('Usuario');
        $lista = $usuarios->misClientes($page ?? 1);
        if (sizeof($lista['result']) < 1) {
            echo json_encode(array('resultado' => array('error' => 'No hay clientes registrados')));
        } else {
            echo json_encode(array('resultado' => array('lista' => $lista['result'], 'numeroDePaginas' => $lista['pages'])));
        }
    }

    public function proveedores($request)
    {
        $req = $request->getAllParams();
        $page = $req->page ?? 1;
        $usuarios = $this->getModel('Usuario');
        $lista = $usuarios->misProveedores($page ?? 1);
        if (sizeof($lista['result']) < 1) {
            echo json_encode(array('resultado' => array('error' => 'No hay proveedores registrados')));
        } else {
            echo json_encode(array('resultado' => array('lista' => $lista['result'], 'numeroDePaginas' => $lista['pages'])));
        }
    }

    public function login($request)
    {
        $data = $request->post;
        $user = $data['usuario'];
        $pass = $data['password'];
        $usuarios = $this->getModel('Usuario');
        if (!empty($user) and !empty($pass)) {
            $usuarios->setData(array(
                'usuario' => $user,
                'password' => $pass
            ));
            echo json_encode(array('resultado' => $usuarios->login()));
        } else {
            echo json_encode(array('resultado' => array('error' => 'Complete el formulario')));
        }
    }

    public function buscarFormulario($request)
    {
        $req = $request->getAllParams();
        $search = $req->q ?? null;
        $tipo = $req->tipo ?? 'clientes';
        if (isset($search) && !empty($search)) {
            $inventario = $this->getModel('Usuario');
            $busqueda = $inventario->setData(array('busqueda' => $search, 'tipo' => $tipo))->formularioBusqueda();
            if (sizeof($busqueda) > 0) {
                echo json_encode(array('resultado' => array('lista' => $busqueda)));
                return;
            }
        }
        echo json_encode(array('resultado' => array('error' => 'No se encontraron resultados')));
    }

    public function miData()
    {
        $usuario = $this->getModel("Usuario");
        $data = $usuario->miData();
        if (sizeof($data) > 0) {
            $info = $data[0];
            $info['logo'] = View::newMedia('upload', $info['logo']);
            $info['header'] = View::newMedia('upload', $info['header']);
            echo json_encode(array('resultado' => array('lista' => $info)));
            return;
        }
        echo json_encode(array('resultado' => array('error' => 'No se encontraron resultados')));
    }

    public function datosTienda($request)
    {
        $data = $request->getInputs();
        $header = $data['file_header'] ?? null;
        $logo = $data['file_logo'] ?? null;
        $nombre = $data['nombre'] ?? null;
        $rut = $data['rut'] ?? null;
        $phone = $data['phone'] ?? null;
        $email = $data['email'] ?? null;
        $direccion = $data['direccion'] ?? null;
        $destino = $data['destino'] ?? null;
        $banco = $data['banco'] ?? null;
        $tipo = $data['tipo'] ?? null;
        $cuenta = $data['cuenta'] ?? null;

        $post = (isset($nombre) && !empty($nombre)) &&
                (isset($rut) && !empty($rut)) &&
                (isset($phone) && !empty($phone)) &&
                (isset($email) && !empty($email));
        if ($post) {
            $usuario = $this->getModel('Usuario');
            $dblogo = $this->fileFormat($logo);
            $dbheader = $this->fileFormat($header);
            $data = array(
                'email' => $email,
                'nombre' => $nombre,
                'rut' => $rut,
                'phone' => $phone,
                'direccion' => $direccion,
                'destino' => $destino,
                'banco' => $banco,
                'tipo' => $tipo,
                'cuenta' => $cuenta,
            );
            if ($logo) {
                $data['logo'] = $dblogo;
            }
            if ($header) {
                $data['header'] = $dbheader;
            }
            if ($usuario->actualizarDatosTienda($data)) {
                echo json_encode(array('resultado' => array('mensaje' => 'Datos de tienda actualizada')));
            }else {
                echo json_encode(array('resultado' => array('error' => 'Hubo un error')));
            }
        }else {
            echo json_encode(array('resultado' => array('error' => 'Complete los campos obligatorios')));
        }
    }
}
