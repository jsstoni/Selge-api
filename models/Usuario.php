<?php
/**
 * UsuariosModel
 */
namespace models;

use src\Model;
use src\Helper;

class Usuario extends Model
{
    private $token;
    public function __construct()
    {
        $this->token = Helper::getAuthorization();
    }
    public function buscar($tipo)
    {
        $id = $this->getData('id');
        return self::getResult("SELECT * FROM {$tipo} WHERE (rut LIKE '%{$id}%' OR nombre LIKE '%{$id}%' OR phone LIKE '%{$id}%') AND usuario = '{$this->token}'");
    }

    public function guardar($data = array(), $tabla, $saved)
    {
        if ($saved == 1) {
            $id = $data['id'];
            $usuario = $data['usuario'];
            return self::Update($tabla, $data, "ID = '{$id}' AND usuario = '{$usuario}'");
        } elseif ($saved == 2) {
            return self::Insert($tabla, $data);
        }
        return false;
    }

    public function nuevo($tabla, $data)
    {
        return self::Insert($tabla, $data);
    }

    public function actualizar($tabla, $data, $id)
    {
        return self::Update($tabla, $data, "ID = '{$id}' AND usuario = '{$this->token}'");
    }

    public function borrar($id, $tabla)
    {
        return self::Remove($tabla, "ID = '{$id}' AND usuario = '{$this->token}'");
    }

    public function login()
    {
        $usuario = $this->getData('usuario');
        $password = $this->getData('password');
        $r = self::getResult("SELECT ID, nombre, password FROM usuarios WHERE email = '{$usuario}'");
        if (sizeof($r) > 0) {
            $usuario = $r[0];
            if ($usuario['password'] == $password) {
                $token = Helper::codificar($usuario['ID']);
                return array("mensaje" => "Bienvenido", "token" => $token, "nombre" => $usuario['nombre']);
            } else {
                return array("error" => "Correo o contraseña incorrecto");
            }
        } else {
            return array("error" => "Usuario no existe, {$usuario}, {$password}");
        }
    }

    public function buscarUsuarios($table)
    {
        $rut = $this->getData('rut');
        return self::getResult("SELECT * FROM {$table} WHERE rut = '{$rut}' AND usuario = '{$this->token}'");
    }

    public function misClientes($page = 1, $rows = 20)
    {
        return self::queryPaginate("SELECT * FROM clientes WHERE usuario = '{$this->token}'", $page, $rows);
    }

    public function misProveedores($page = 1, $rows = 20)
    {
        return self::queryPaginate("SELECT * FROM proveedores WHERE usuario = '{$this->token}'", $page, $rows);
    }

    public function todosProveedores()
    {
        return self::getResult("SELECT * FROM proveedores WHERE usuario = '{$this->token}'");
    }

    public function proveedorDatos()
    {
        $id = $this->getData('id');
        return self::getResult("SELECT * FROM proveedores WHERE usuario = '{$this->token}' AND ID = '{$id}'");
    }

    public function seleccionarUsuario()
    {
        $id = $this->getData('id');
        $table = $this->getData('table');
        return self::getResult("SELECT * FROM {$table} WHERE usuario = '{$this->token}' AND ID = '{$id}'");
    }

    public function formularioBusqueda()
    {
        $s = $this->getData("busqueda");
        $table = $this->getData('tipo');
        return self::getResult("SELECT * FROM {$table} WHERE (nombre LIKE '%{$s}%' OR rut = '{$s}' OR phone = '{$s}' OR email = '{$s}') AND usuario = '{$this->token}'");
    }

    public function miData()
    {
        return self::getResult("SELECT * FROM usuarios WHERE ID = '{$this->token}'");
    }

    public function actualizarDatosTienda($data)
    {
        return self::Update('usuarios', $data, "ID = '{$this->token}'");
    }

    public function checkUser()
    {
        $user = $this->getData('user');
        return self::getResult("SELECT ID, nombre, header, logo FROM usuarios WHERE nombre = '{$user}'");
    }
}
