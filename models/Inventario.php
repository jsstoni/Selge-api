<?php
/**
 * InventarioModel
 */
namespace models;

use src\Model;
use src\Helper;

class Inventario extends Model
{
    private $token;
    public function __construct()
    {
        $this->token = Helper::getAuthorization();
    }
    public function buscarProducto()
    {
        $id = $this->getData('id');
        return self::getResult("SELECT p.ID, p.sku, p.producto, p.stock, p.web, p.atributos, p.opciones, p.categoria, p.image, p.precio, p.descuento FROM productos AS p WHERE p.usuario = '{$this->token}' AND p.ID = '{$id}' LIMIT 1");
    }

    public function buscarSku()
    {
        $id = urldecode($this->getData('id'));
        return self::getResult("SELECT p.sku, p.producto, p.image, (CASE p.descuento WHEN 0 THEN p.precio ELSE p.precio * (1 - p.descuento / 100) END) AS precio, (CASE p.descuento WHEN 0 THEN p.precio ELSE p.precio * (1 - p.descuento / 100) END) AS precioreal, p.descuento, '' AS opciones, '' AS opcion, p.opciones AS options, 1 AS cantidad, '' AS nota, p.atributos FROM productos AS p WHERE p.sku = '{$id}' AND p.usuario = '{$this->token}' LIMIT 1");
    }

    public function borrarProducto()
    {
        $id = $this->getData('id');
        return $this->Remove("productos", "ID = '{$id}' AND usuario = '{$this->token}'");
    }

    public function editarProducto($data)
    {
        unset($data['id']);
        return self::Update('productos', $data, "sku = '{$data['sku']}' AND proveedor = '{$this->token}'");
    }

    public function guardarProducto($data)
    {
        $data['usuario'] = $this->token;
        $data['proveedor'] = $this->token;
        return $this->Insert('productos', $data);
    }

    public function importarProductos($data)
    {
        return self::Insert('productos', $data, 'REPLACE');
    }

    public function listaProducto($page = 1, $rows = 20)
    {
        return self::queryPaginate("SELECT ID, sku, image, producto, categoria, atributos, opciones, precio, descuento, web, 1 AS cantidad, '' AS opcion, '' AS nota FROM (SELECT * FROM productos WHERE usuario = '{$this->token}' UNION ALL SELECT pr.* FROM subs s INNER JOIN productos pr ON (s.producto_id = pr.ID) WHERE s.usuario = '{$this->token}' AND pr.web = 'true') productos", $page, $rows);
    }

    public function buscadorProducto($page, $rows = 20)
    {
        $busqueda = urldecode($this->getData('buscar'));
        return self::queryPaginate("SELECT * FROM productos WHERE usuario = '{$this->token}' AND (producto LIKE '%{$busqueda}%' OR sku LIKE '%{$busqueda}%' OR sku = '{$busqueda}')", $page, $rows);
    }

    public function existencia()
    {
        return self::getResult("SELECT * FROM productos AS p WHERE p.usuario = '{$this->token}' AND opciones != '[]' ORDER BY id ASC");
    }

    public function obtenerOpciones($sku)
    {
        $in = array();
        foreach ($sku as $key => $id) {
            $in[] = "('{$id}')";
        }
        $in = array_unique($in);
        $sql = "SELECT ID, sku, opciones FROM productos WHERE ID IN (".implode(", ", $in).")";
        return self::getResult($sql);
    }

    public function hacerPedido($data, $restante)
    {
        $fecha = date("Y-m-d");
        $sql = "INSERT INTO pedidos (id_producto, sku, producto, precio, descuento, opcion, cantidad, nota, existe, empresa, pago, npedido, fecha, order_id, serial, rut, estado, usuario, proveedor)";

        $keys_id = array_keys($restante);
        $updateStock = "UPDATE productos SET opciones = (CASE ";
        $whenList = array_map(function($id) use($restante) {
            return "WHEN ID = '{$id}' THEN '{$restante[$id]}'";
        }, $keys_id);
        $updateStock .= implode(" ", $whenList)." END) WHERE ID IN (".implode(", ", $keys_id).") AND (usuario = '{$this->token}' OR proveedor = '{$this->token}')";

        $sql_values = array();
        foreach ($data as $key => $item) {
            $precio = $item['precio'] ?? 'precio';
            $sql_values[] = " SELECT '{$item['ID']}', '{$item['sku']}', '{$item['producto']}', {$precio}, descuento, '{$item['opciones']}', '{$item['cantidad']}', '{$item['nota']}', '{$item['existe']}', '{$item['empresa']}', '{$item['pago']}', '{$item['npedido']}', '{$fecha}', '{$item['order_id']}', '{$item['serial']}', '{$item['rut']}', '{$item['estado']}', '{$this->token}', proveedor FROM productos WHERE ID = '{$item['ID']}'";
        }

        $sql .= implode(" UNION ", $sql_values); //insertar ventas pedido
        /*echo $sql;
        echo "\n\n\n\n\n\n";
        echo $updateStock;*/

        $pedido = self::Query($sql);
        if ($pedido) {
            self::Query($updateStock);
            return self::Query("UPDATE order_id SET order_id = order_id + 1 WHERE usuario = '{$this->token}'");
        }
    }

    public function solicitarPedido($data)
    {
        $sql = "INSERT INTO solicitar (id_pedido, cantidad, code, usuario, proveedor, fecha)";
        $sqlValues = array();
        $whenId = "";
        foreach ($data as $k => $v) {
            $sqlValues[] = "SELECT '{$v['id_pedido']}', '{$v['cantidad']}', '{$v['code']}', '{$this->token}', proveedor, '{$v['fecha']}' FROM pedidos WHERE ID = '{$v['id_pedido']}' AND (usuario = '{$this->token}' OR proveedor = '{$this->token}')";
            $whenId .= " WHEN id_pedido = '{$v['id_pedido']}' THEN taller + '{$v['cantidad']}'";
        }
        $sql .= implode(" UNION ", $sqlValues);
        $solicitar = self::Query($sql);
        if ($solicitar) {
            $ids = array_column($data, 'id_pedido');
            return self::Query("UPDATE control_pedido SET taller = (CASE {$whenId} END) WHERE id_pedido IN (".implode(", ", $ids).")");
        }
    }

    public function actualizarPedido($data)
    {
        $id = $this->getData('id');
        $r = self::Remove('pedidos', "npedido = '{$id}' AND estado = 1 AND usuario = {1}");
        if (sizeof($data) >= 1) {
            return self::Insert('pedidos', $data, 'IGNORE');
        }
        return false;
    }

    public function listarOrdenes($page = 1, $rows = 20)
    {
        return self::queryPaginate("SELECT * FROM (SELECT s.id_pedido, s.ID, p.sku, p.producto, p.precio, p.opcion, p.nota, p.npedido, s.estado, pr.image, pr.atributos, p.cantidad, p.existe, p.fecha, p.serial, IF(pr.proveedor = '{$this->token}', 'true', 'false') AS editar, s.cantidad AS pedido FROM solicitar AS s LEFT JOIN pedidos AS p ON (s.id_pedido = p.ID) LEFT JOIN productos AS pr ON (p.id_producto = pr.ID) WHERE s.usuario = '{$this->token}' OR s.proveedor = '{$this->token}' UNION ALL SELECT 1, p.ID, p.sku, p.producto, p.precio, p.opcion, p.nota, p.npedido, p.estado, pr.image, pr.atributos, p.cantidad, p.existe, p.fecha, p.serial, IF(pr.proveedor = '{$this->token}', 'true', 'false') AS editar, 0 AS pedido FROM pedidos AS p LEFT JOIN productos AS pr ON (p.id_producto = pr.ID ) WHERE p.estado IN (3,4,5,6) AND (p.usuario = '{$this->token}' OR p.proveedor = '{$this->token}') GROUP BY p.order_id) pedidos ORDER BY pedidos.estado ASC, pedidos.ID ASC", $page, $rows);
    }

    public function detallesSolicitud($id)
    {
        return self::getResult("SELECT c.nombre, c.rut, c.phone, c.email, c.direccion, p.empresa FROM solicitar AS s LEFT JOIN pedidos AS p ON (s.id_pedido = p.ID AND p.usuario = s.usuario) LEFT JOIN productos AS pr ON (p.id_producto = pr.sku AND pr.proveedor = '{$this->token}' AND s.usuario = pr.usuario) LEFT JOIN clientes AS c ON (p.rut = c.rut AND c.usuario = s.usuario) WHERE s.ID = '{$id}' AND pr.proveedor = '{$this->token}'");
    }

    public function completarSolicitud()
    {
        $id = $this->getData('id');
        $ids = implode(',', $id);
        self::Query("UPDATE solicitar SET estado = 1 WHERE ID IN (".$ids.")");
        return self::Query("UPDATE control_pedido AS cp, (SELECT id_pedido, cantidad FROM solicitar WHERE ID IN (".$ids.")) AS data SET cp.terminado = cp.terminado + data.cantidad WHERE cp.id_pedido = data.id_pedido");
    }

    public function cancelarProducto()
    {
        $id = $this->getData('id');
        return self::Query("UPDATE pedidos t1 LEFT JOIN pedidos AS t2 ON (t2.ID = '{$id}' AND (t2.usuario = '{$this->token}' OR t2.proveedor = '{$this->token}')) LEFT JOIN productos t3 ON (t1.sku = t3.sku AND (t3.proveedor = '{$this->token}' OR t3.usuario = '{$this->token}')) SET t1.estado = 6 WHERE t1.ID = '{$id}' AND (t3.proveedor = '{$this->token}' OR t3.usuario = '{$this->token}') AND t1.estado = 2");
    }

    public function statusPedidos()
    {
        return self::getResult("SELECT lista.estado, IF(T1.total, T1.total, 0) AS total FROM
		(SELECT 1 as idEstado , 'En espera' as estado UNION
		SELECT 2 as idEstado , 'Completados' as estado UNION
        SELECT 3 as idEstado , 'Enviados' as estado) lista
		LEFT JOIN (SELECT estado, COUNT(ID) total FROM pedidos WHERE usuario = '{$this->token}' OR proveedor = '$this->token' GROUP BY estado) T1 ON T1.estado = lista.idEstado");
    }

    public function historialPedidos($page = 1, $rows = 20)
    {
        return self::queryPaginate("SELECT p.ID, p.empresa, p.npedido, p.fecha, p.order_id, c.nombre, SUM(p.precio * p.cantidad) AS total, SUM(p.cantidad) AS cantidad, SUM(cp.terminado) AS terminado, u.nombre AS vendedor FROM pedidos AS p LEFT JOIN productos AS pr ON (p.id_producto = pr.ID AND pr.usuario = '{$this->token}') LEFT JOIN control_pedido AS cp ON (cp.id_pedido = p.ID) LEFT JOIN clientes AS c ON (p.rut = c.ID AND c.usuario = p.usuario) LEFT JOIN usuarios AS u ON (p.usuario = u.ID) WHERE p.usuario = '{$this->token}' OR p.proveedor = '{$this->token}' GROUP BY p.order_id ORDER BY p.ID DESC", $page, $rows);
    }

    public function filtrarOrden($page = 1, $rows = 20)
    {
        $medio = $this->getData('medio');
        $estado = $this->getData('estado');
        (empty($medio)) ? null : $where[] = "p.medio = '{$medio}'";
        (empty($estado)) ? null : $where[] = " p.estado = '{$estado}'";
        $w = implode("AND", $where);
        return self::queryPaginate("SELECT p.*, pr.image, c.nombre, SUM(p.precio) AS total, SUM(p.valor) AS cantidad FROM pedidos AS p LEFT JOIN productos AS pr ON (p.id_producto = pr.sku AND pr.usuario = '{$this->token}') LEFT JOIN clientes AS c ON (p.rut = c.rut AND c.usuario = p.usuario) WHERE p.usuario = '{$this->token}' AND {$w} GROUP BY p.npedido ORDER BY p.ID DESC", $page, $rows);
    }

    public function orden()
    {
        $id = $this->getData('id');
        return self::getResult("SELECT p.npedido, p.producto, p.precio, p.cantidad, p.opcion, p.empresa, p.pago, p.sku, pr.image, pr.atributos, c.nombre, c.phone, c.email, c.direccion, 0 AS total, p.cantidad FROM pedidos AS p LEFT JOIN productos AS pr ON (p.id_producto = pr.ID) LEFT JOIN clientes AS c ON (p.rut = c.ID) WHERE p.order_id = '{$id}' AND (p.usuario = '{$this->token}' OR p.proveedor = '{$this->token}') ORDER BY p.npedido ASC");
    }

    public function ordenDetalles()
    {
        $id = $this->getData('id');
        return self::getResult("SELECT p.ID, p.sku, p.producto, p.precio, p.opcion, p.nota, p.npedido, p.order_id, p.estado, pr.image, pr.atributos, p.cantidad, p.existe, IF(pr.proveedor = '{$this->token}', 'true', 'false') AS editar, 1 AS pedir, (cp.taller + cp.disponible) AS disponible, cp.terminado FROM pedidos AS p LEFT JOIN control_pedido AS cp ON (p.ID = cp.id_pedido) LEFT JOIN productos AS pr ON (p.id_producto = pr.ID) WHERE p.order_id = '{$id}' AND (p.usuario = '{$this->token}' OR p.proveedor = '{$this->token}') ORDER BY p.ID ASC");
    }

    public function ordenProductos()
    {
        $id = $this->getData('id');
        return self::getResult("SELECT p.producto, p.id_producto, p.precio, p.opcion, p.valor, pr.image, c.nombre, p.rut, p.empresa, p.pago, pr.atributos, o.opcion AS options FROM pedidos AS p LEFT JOIN productos AS pr ON (p.id_producto = pr.sku AND pr.usuario = '{$this->token}') LEFT JOIN opciones AS o ON (o.usuario = '{$this->token}') LEFT JOIN clientes AS c ON (p.rut = c.rut AND c.usuario = '{$this->token}') WHERE p.npedido = '{$id}' AND p.usuario = '{$this->token}'");
    }

    public function ultimaOrden()
    {
        $id = self::getResult("SELECT order_id FROM order_id WHERE usuario = '{$this->token}'");
        if (sizeof($id) > 0) {
            return $id[0]['order_id'] + 1;
        }
        return Helper::getRandomString(9);
    }

    public function informeSolicitado($data = array())
    {
        $ids = implode(",", $data);
        return self::getResult("SELECT p.ID, p.id_producto, p.producto, p.opcion, p.valor, p.npedido, pr.image, pr.atributos FROM pedidos AS p LEFT JOIN productos AS pr ON (p.id_producto = pr.sku AND pr.usuario = '{$this->token}') WHERE p.ID IN({$ids})");
    }

    public function pedidoCompletado()
    {
        $id = $this->getData('id');
        $disponible = $this->getData('disponible');
        return self::Query("UPDATE control_pedido SET disponible = (disponible + '{$disponible}'), terminado = (terminado + '{$disponible}') WHERE id_pedido = '{$id}' AND (usuario = '{$this->token}' OR proveedor = '{$this->token}')");
    }

    public function despacharProductos($data)
    {
        return self::Insert("despacho", $data);
    }

    public function pedidosCompletados($page = 1, $rows = 20)
    {
        return self::queryPaginate("SELECT p.ID, p.id_producto, p.producto, p.precio, p.opcion, p.cantidad, p.npedido, p.estado, pr.image, pr.sku FROM pedidos AS p LEFT JOIN productos AS pr ON (p.id_producto = pr.ID) WHERE p.estado = 2 AND p.proveedor = '{$this->token}' ORDER BY p.ID ASC", $page, $rows);
    }

    public function opciones()
    {
    	return self::getResult("SELECT opcion FROM opciones WHERE usuario = '$this->token'");
    }

    public function formularioBusqueda()
    {
        $s = $this->getData("busqueda");
        $q = "SELECT p.ID, p.sku, p.image, p.producto, p.categoria, p.atributos, p.precio, p.descuento, CASE WHEN u.nombre IS NULL THEN 'Sin proveedor' ELSE u.nombre END AS proveedor FROM productos AS p LEFT JOIN usuarios AS u ON (p.proveedor = u.ID) WHERE (p.producto LIKE '%{$s}%' OR p.sku = '{$s}') AND p.usuario = '{$this->token}'";
        return self::getResult($q);
    }

    public function buscarOrden() {
        $s = $this->getData('busqueda');
        $q = "SELECT s.ID, p.npedido, p.producto, p.precio, p.opcion, p.cantidad, pr.atributos, pr.image, p.id_producto, c.nombre, s.fecha, s.estado, s.id_pedido FROM solicitar AS s LEFT JOIN pedidos AS p ON (s.id_pedido = p.ID) LEFT JOIN productos AS pr ON (p.id_producto = pr.sku AND pr.proveedor = '{$this->token}' AND s.usuario = pr.usuario) LEFT JOIN usuarios AS c ON (pr.proveedor = c.ID) WHERE p.npedido = '{$s}' AND pr.proveedor = '{$this->token}' ORDER BY s.estado ASC, p.npedido ASC";
        return self::getResult($q);
    }

    public function retirarProducto()
    {
        $ids = $this->getData('id');
        $proveedor = $this->getData('proveedor');
        $code = Helper::getRandomString(9);
        $data = array_map(function($id) use ($proveedor, $code) {
            return array('id_pedido' => $id, 'proveedor' => $proveedor, 'fecha' => date("Y-m-d H:i:s"), 'code' => $code, 'usuario' => $this->token);
        }, $ids);
        return self::Insert('retiros', $data);
    }

    public function listaRetiros()
    {
        return self::getResult("SELECT p.npedido, p.empresa, r.fecha, c.nombre FROM retiros AS r LEFT JOIN pedidos AS p ON (r.id_pedido = p.ID) LEFT JOIN proveedores AS c ON (r.proveedor = c.ID) WHERE r.usuario = '{$this->token}' GROUP BY r.code");
    }

    public function downloadRetiro()
    {
        $retiros = self::getResult("SELECT p.npedido, pr.image, p.sku, p.producto, p.precio, p.cantidad, p.empresa, c.nombre, c.rut, c.phone, c.email, c.direccion FROM retiros AS r LEFT JOIN pedidos AS p ON (r.id_pedido = p.ID) LEFT JOIN productos AS pr ON (p.id_producto = pr.ID) LEFT JOIN clientes AS c ON (p.rut = c.ID) WHERE r.usuario = '{$this->token}'");
        $res = array();
        foreach ($retiros as $key => $value) {
            $res[$value['npedido']][] = $value;
        }
        return $res;
    }

    public function importMarketplace()
    {
        $id = $this->getData('id');
        $producto = self::getResult("SELECT producto_id FROM subs WHERE producto_id = '{$id}' AND usuario = '{$this->token}'");
        if (sizeof($producto) > 0) {
            return false;
        }
        return self::Insert('subs', array('producto_id' => $id, 'usuario' => $this->token));
    }

    public function reportes()
    {
        $fecha = date("Y");
        $q = "SELECT TMeses.Mes,T1.total_mes FROM
        (SELECT 1 as IdMes , 'Enero'    as Mes UNION
        SELECT 2 as IdMes , 'Febrero'  as Mes UNION
        SELECT 3 as IdMes , 'Marzo'  as Mes UNION
        SELECT 4 as IdMes , 'Abril'  as Mes UNION
        SELECT 5 as IdMes , 'Mayo'    as Mes UNION
        SELECT 6 as IdMes , 'Junio'  as Mes UNION
        SELECT 7 as IdMes , 'Julio'  as Mes UNION
        SELECT 8 as IdMes , 'Agosto'    as Mes UNION
        SELECT 9 as IdMes , 'Septiembre' as Mes UNION
        SELECT 10 as IdMes, 'Octubre'    as Mes UNION
        SELECT 11 as IdMes, 'Noviembre'  as Mes UNION
        SELECT 12 as IdMes, 'Diciembre'  as Mes) TMeses
        LEFT JOIN (SELECT MONTH(fecha) Mes, SUM(cantidad) total_mes FROM pedidos WHERE YEAR(fecha) = '{$fecha}' AND proveedor = '{$this->token}' GROUP BY Mes) T1 ON T1.Mes = TMeses.idMes";
        return self::getResult($q);
    }
}
