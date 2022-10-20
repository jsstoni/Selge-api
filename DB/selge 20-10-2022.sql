-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-10-2022 a las 19:41:22
-- Versión del servidor: 10.4.19-MariaDB
-- Versión de PHP: 7.3.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `selge`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `clientes`
--

CREATE TABLE `clientes` (
  `ID` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `rut` varchar(12) NOT NULL,
  `phone` varchar(16) NOT NULL,
  `email` text NOT NULL,
  `direccion` text NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `clientes`
--

INSERT INTO `clientes` (`ID`, `nombre`, `rut`, `phone`, `email`, `direccion`, `usuario`) VALUES
(1, 'Jesus Antonio Perez Araujo', '27481532-9', '945692310', 'jsstoniha@gmail.com', 'Valparaíso, Cerro Placeres, San Luis 595', 1),
(2, 'jesus perez', '44204200-4', '945692310', 'hackjp14@hotmail.com', 'quintero', 2),
(4, 'Teresa Araujo', '27666156-6', '945692310', 'araujoteresa1966@gmail.com', 'Quintero', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `control_pedido`
--

CREATE TABLE `control_pedido` (
  `ID` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `taller` int(11) NOT NULL,
  `disponible` int(11) NOT NULL,
  `terminado` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `proveedor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `control_pedido`
--

INSERT INTO `control_pedido` (`ID`, `id_pedido`, `cantidad`, `taller`, `disponible`, `terminado`, `usuario`, `proveedor`) VALUES
(1, 1, 1, 0, 1, 1, 1, 1),
(2, 2, 2, 0, 2, 2, 2, 1),
(3, 3, 1, 0, 0, 0, 1, 1),
(4, 4, 1, 0, 0, 0, 2, 1);

--
-- Disparadores `control_pedido`
--
DELIMITER $$
CREATE TRIGGER `control_estado` AFTER UPDATE ON `control_pedido` FOR EACH ROW UPDATE pedidos SET estado = CASE WHEN OLD.cantidad = NEW.terminado THEN 2 ELSE 1 END WHERE ID = NEW.id_pedido
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `movimientos`
--

CREATE TABLE `movimientos` (
  `ID` int(11) NOT NULL,
  `sku` varchar(24) NOT NULL,
  `opcion` text NOT NULL,
  `cantidad` int(11) NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `proveedor` int(11) NOT NULL,
  `nota` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`ID`, `usuario`, `proveedor`, `nota`) VALUES
(1, 2, 1, 'Tienes un nuevo pedido');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `order_id`
--

CREATE TABLE `order_id` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `order_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `order_id`
--

INSERT INTO `order_id` (`ID`, `usuario`, `order_id`) VALUES
(1, 1, 105),
(2, 2, 68);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `ID` int(11) NOT NULL,
  `id_producto` int(16) NOT NULL,
  `sku` varchar(16) NOT NULL,
  `producto` text NOT NULL,
  `precio` double NOT NULL,
  `descuento` int(11) NOT NULL,
  `opcion` varchar(156) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `nota` text NOT NULL,
  `existe` varchar(26) NOT NULL,
  `empresa` text NOT NULL,
  `pago` int(11) NOT NULL DEFAULT 0,
  `npedido` int(9) DEFAULT NULL,
  `fecha` date NOT NULL,
  `order_id` varchar(12) NOT NULL,
  `serial` varchar(9) NOT NULL,
  `rut` varchar(11) NOT NULL,
  `producir` int(11) NOT NULL DEFAULT 1,
  `estado` int(11) NOT NULL DEFAULT 1,
  `usuario` int(11) NOT NULL,
  `proveedor` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`ID`, `id_producto`, `sku`, `producto`, `precio`, `descuento`, `opcion`, `cantidad`, `nota`, `existe`, `empresa`, `pago`, `npedido`, `fecha`, `order_id`, `serial`, `rut`, `producir`, `estado`, `usuario`, `proveedor`) VALUES
(1, 1, '1273-34', 'Lucias', 59000, 0, 'Talla: 34', 1, '', '1', 'Starken', 1, 104, '2022-10-04', '887BcefD7309', 'F31f634Fa', '1', 1, 3, 1, 1),
(2, 1, '1273-34', 'Lucias', 59000, 0, 'Talla: 34', 2, '', '1', 'Starken', 1, 67, '2022-10-10', 'c25b5cAD904e', '3A47A5F68', '2', 1, 3, 2, 1),
(3, 1, '1273-34', 'Lucias', 59000, 0, 'Talla: 34', 1, '', '1', 'Starken', 1, 105, '2022-10-19', 'cE6AA9e5f9d8', 'D64ADBC14', '1', 1, 1, 1, 1),
(4, 1, '1273', 'Lucias', 59000, 0, 'Talla: 37', 1, '', '1', 'Correos De Chile', 1, 68, '2022-10-19', '8dEeF4b2Ceee', 'ECEf70B93', '2', 1, 1, 2, 1);

--
-- Disparadores `pedidos`
--
DELIMITER $$
CREATE TRIGGER `control_inventario` AFTER INSERT ON `pedidos` FOR EACH ROW INSERT INTO control_pedido (id_pedido, cantidad, usuario, proveedor) VALUES (NEW.ID, NEW.cantidad, NEW.usuario, NEW.proveedor)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `notificar` AFTER INSERT ON `pedidos` FOR EACH ROW BEGIN
    IF NEW.usuario != NEW.proveedor THEN BEGIN
        INSERT INTO notificaciones (usuario, proveedor, nota)
        VALUES (NEW.usuario, NEW.proveedor, 'Tienes un nuevo pedido');
    END; END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos`
--

CREATE TABLE `productos` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `sku` varchar(36) NOT NULL,
  `image` text NOT NULL,
  `producto` text NOT NULL,
  `categoria` text NOT NULL,
  `atributos` text NOT NULL DEFAULT '[]',
  `opciones` text NOT NULL DEFAULT '[]',
  `precio` decimal(10,0) DEFAULT 0,
  `descuento` int(11) DEFAULT 0,
  `stock` set('true','false') NOT NULL DEFAULT 'false',
  `web` set('true','false') NOT NULL DEFAULT 'false',
  `activo` int(11) NOT NULL DEFAULT 1,
  `proveedor` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `f_actualizado` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`ID`, `usuario`, `sku`, `image`, `producto`, `categoria`, `atributos`, `opciones`, `precio`, `descuento`, `stock`, `web`, `activo`, `proveedor`, `fecha`, `f_actualizado`) VALUES
(1, 1, '1273', '7dBc1DE6eC5D.jpeg', 'Lucias', 'C13', '[{\"opcion\":\"Talla\",\"opciones\":[{\"valor\":\"34\"},{\"valor\":\"35\"},{\"valor\":\"36\"},{\"valor\":\"37\"},{\"valor\":\"38\"},{\"valor\":\"39\"},{\"valor\":\"40\"}]}]', '[{\"name\":\"Talla: 34\",\"precio\":\"59000\",\"stock\":3,\"sku\":\"1273-34\"},{\"name\":\"Talla: 35\",\"sku\":\"1273\",\"precio\":\"59000\",\"stock\":10},{\"name\":\"Talla: 36\",\"sku\":\"1273\",\"precio\":\"59000\",\"stock\":7},{\"name\":\"Talla: 37\",\"sku\":\"1273\",\"precio\":\"59000\",\"stock\":10}]', '59000', 0, 'false', 'true', 1, 1, '2022-09-06', NULL),
(2, 1, '1276', '4F4cD66e3dE1.jpeg', 'Botin Rossi', 'C13', '[{\"opcion\":\"Talla\",\"opciones\":[{\"valor\":\"34\"},{\"valor\":\"35\"},{\"valor\":\"36\"},{\"valor\":\"37\"},{\"valor\":\"38\"},{\"valor\":\"39\"},{\"valor\":\"40\"}]}]', '[{\"name\":\"Talla: 34\",\"sku\":\"1276\",\"precio\":\"69000\",\"stock\":7},{\"name\":\"Talla: 35\",\"sku\":\"1276\",\"precio\":\"69000\",\"stock\":8}]', '69000', 0, 'true', 'true', 1, 1, '2022-09-06', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proveedores`
--

CREATE TABLE `proveedores` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `rut` varchar(11) NOT NULL,
  `phone` varchar(16) NOT NULL,
  `email` text NOT NULL,
  `direccion` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `proveedores`
--

INSERT INTO `proveedores` (`ID`, `usuario`, `nombre`, `rut`, `phone`, `email`, `direccion`) VALUES
(1, 1, 'Envios', '27481532-9', '948977182', 'jsstoniha@gmail.com', 'Valparaíso San Luis 595');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `retiros`
--

CREATE TABLE `retiros` (
  `ID` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `proveedor` int(11) NOT NULL,
  `fecha` datetime NOT NULL,
  `code` varchar(9) NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `retiros`
--

INSERT INTO `retiros` (`ID`, `id_pedido`, `proveedor`, `fecha`, `code`, `usuario`) VALUES
(1, 1, 1, '2022-10-11 06:14:21', '59BD8431C', 1),
(2, 2, 1, '2022-10-11 06:14:21', '59BD8431C', 1);

--
-- Disparadores `retiros`
--
DELIMITER $$
CREATE TRIGGER `estado_retiro` AFTER INSERT ON `retiros` FOR EACH ROW UPDATE pedidos SET estado = 3 WHERE ID = NEW.id_pedido
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitar`
--

CREATE TABLE `solicitar` (
  `ID` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `nota` text NOT NULL,
  `estado` int(11) NOT NULL,
  `code` text NOT NULL,
  `usuario` int(11) NOT NULL,
  `proveedor` int(11) NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `subs`
--

CREATE TABLE `subs` (
  `ID` int(11) NOT NULL,
  `producto_id` int(11) NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `subs`
--

INSERT INTO `subs` (`ID`, `producto_id`, `usuario`) VALUES
(1, 1, 2),
(2, 2, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID` int(11) NOT NULL,
  `email` text NOT NULL,
  `password` varchar(46) NOT NULL,
  `nombre` text NOT NULL,
  `rut` varchar(11) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `direccion` text NOT NULL,
  `destino` varchar(12) NOT NULL,
  `banco` varchar(4) NOT NULL,
  `tipo` varchar(4) NOT NULL,
  `cuenta` varchar(20) NOT NULL,
  `logo` text NOT NULL,
  `header` text NOT NULL,
  `text_color` varchar(7) NOT NULL,
  `color` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID`, `email`, `password`, `nombre`, `rut`, `phone`, `direccion`, `destino`, `banco`, `tipo`, `cuenta`, `logo`, `header`, `text_color`, `color`) VALUES
(1, 'jsstoniha@gmail.com', '1515', 'Zapatostop', '27481532-9', '945692310', '', '', '', '', '', 'df51f5b309Ad.jpeg', '81E7CE1019D7.jpeg', '', ''),
(2, 'tilby@gmail.com', '1515', 'SHOP', '44204200-4', '945692310', '', '', '', '', '', 'bdcB856f6d8f.png', 'Ebee18DBB52A.jpeg', '', '');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `rut` (`rut`,`usuario`);

--
-- Indices de la tabla `control_pedido`
--
ALTER TABLE `control_pedido`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `order_id`
--
ALTER TABLE `order_id`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `pedidos` (`id_producto`,`opcion`,`usuario`,`proveedor`,`order_id`) USING BTREE;

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `productos` (`usuario`,`sku`) USING BTREE;

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `retiros`
--
ALTER TABLE `retiros`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `solicitar`
--
ALTER TABLE `solicitar`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `subs`
--
ALTER TABLE `subs`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `producto_id` (`producto_id`,`usuario`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `control_pedido`
--
ALTER TABLE `control_pedido`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `order_id`
--
ALTER TABLE `order_id`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `retiros`
--
ALTER TABLE `retiros`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `solicitar`
--
ALTER TABLE `solicitar`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subs`
--
ALTER TABLE `subs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
