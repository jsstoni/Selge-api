-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-10-2023 a las 05:08:19
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
(1, 'Jesus Perez', '27481532-9', '+56945692310', 'jsstoniha@gmail.com', 'Quintero', 2),
(4, 'jesus', '27481532-9', '+56948977182', 'jsstoniha@gmail.com', 'quintero', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `colecciones`
--

CREATE TABLE `colecciones` (
  `ID` int(11) NOT NULL,
  `categoria` varchar(150) NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `colecciones`
--

INSERT INTO `colecciones` (`ID`, `categoria`, `usuario`) VALUES
(10, 'Zapatos', 1),
(11, 'Zapatos', 2);

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
(1, 1, 1, 0, 1, 1, 2, 1),
(2, 2, 1, 0, 1, 1, 1, 1),
(3, 3, 1, 0, 1, 1, 1, 1),
(4, 5, 1, 0, 1, 1, 2, 1),
(5, 6, 1, 0, 1, 1, 2, 1),
(6, 7, 1, 0, 1, 1, 2, 2),
(7, 8, 1, 0, 1, 1, 2, 2),
(8, 9, 1, 0, 1, 1, 1, 1),
(9, 10, 1, 0, 1, 1, 1, 1),
(10, 11, 1, 0, 1, 1, 1, 1),
(11, 12, 1, 0, 1, 1, 1, 1);

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
(1, 2, 1, 'Tienes un nuevo pedido'),
(2, 2, 1, 'Tienes un nuevo pedido'),
(3, 2, 1, 'Tienes un nuevo pedido');

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
(1, 1, 119),
(2, 2, 81),
(3, 2, 13);

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
  `ganas` double NOT NULL,
  `opcion` varchar(156) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 1,
  `nota` text NOT NULL,
  `existe` varchar(26) NOT NULL,
  `empresa` text NOT NULL,
  `pago` int(11) NOT NULL DEFAULT 0,
  `npedido` int(9) DEFAULT NULL,
  `fecha` datetime NOT NULL,
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

INSERT INTO `pedidos` (`ID`, `id_producto`, `sku`, `producto`, `precio`, `ganas`, `opcion`, `cantidad`, `nota`, `existe`, `empresa`, `pago`, `npedido`, `fecha`, `order_id`, `serial`, `rut`, `producir`, `estado`, `usuario`, `proveedor`) VALUES
(1, 1, 'B001', 'Babucha modelo B001', 45000, 6750, 'Talla: 34', 1, '', '1', 'Correos De Chile', 1, 78, '2022-11-22 00:00:00', '7ea68e107d1B', '3d9BA196d', '1', 1, 2, 2, 1),
(2, 2, 'O02', 'Oxford modelo O02', 55000, 0, 'Talla: 34', 1, '', '1', 'Starken', 1, 117, '2022-11-22 00:00:00', '8Fc751Eb6ead', '4d85ea001', '4', 1, 2, 1, 1),
(3, 3, 'M01', 'Mocasin modelo M01', 65000, 0, 'Talla: 34', 1, '', '1', 'Starken', 1, 117, '2022-11-22 00:00:00', '8Fc751Eb6ead', 'CF74ECDB1', '4', 1, 2, 1, 1),
(5, 1, 'B001', 'Babucha modelo B001', 45000, 6750, 'Talla: 34', 1, '', '1', 'Chilexpress', 1, 79, '2022-11-22 00:00:00', 'd9acb7FBD195', '4BbF5D758', '1', 1, 2, 2, 1),
(6, 2, 'O02', 'Oxford modelo O02', 55000, 2750, 'Talla: 34', 1, '', '1', 'Chilexpress', 1, 79, '2022-11-22 00:00:00', 'd9acb7FBD195', 'fd8F8Cbbf', '1', 1, 2, 2, 1),
(7, 6, 'O10', 'Oxford en punta', 55000, 0, 'Talla: 34', 1, '', '1', 'Starken', 1, 80, '2022-11-23 00:00:00', 'ab41A5FdB46F', '0B82CE26e', '1', 1, 2, 2, 2),
(8, 6, 'O10', 'Oxford en punta', 55000, 5500, 'Talla: 34', 1, '', '1', 'Correos De Chile', 1, 81, '2022-11-23 00:00:00', '3B6C1BaEfFaB', 'C3dA1491A', '1', 1, 2, 2, 2),
(9, 1, 'B001', 'Babucha modelo B001', 45000, 2250, 'Talla: 34', 1, '', '1', 'Starken', 1, 118, '2022-11-28 00:00:00', '0faEaae3d01d', 'C67dD5aEb', '4', 1, 2, 1, 1),
(10, 2, 'O02', 'Oxford modelo O02', 55000, 8250, 'Talla: 34', 1, '', '1', 'Starken', 1, 118, '2022-11-28 00:00:00', '0faEaae3d01d', '743Febf13', '4', 1, 2, 1, 1),
(11, 3, 'M01', 'Mocasin modelo M01', 65000, 9750, 'Talla: 34', 1, '', '1', 'Starken', 1, 118, '2022-11-28 00:00:00', '0faEaae3d01d', 'eDcC6E5A6', '4', 1, 2, 1, 1),
(12, 3, 'M01', 'Mocasin modelo M01', 65000, 9750, 'Talla: 34', 1, '', '1', 'Starken', 1, 119, '2022-12-05 00:00:00', 'ba0F007D36AB', '9c11Fa737', '4', 1, 2, 1, 1);

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
  `producto` text NOT NULL,
  `categoria` text NOT NULL,
  `atributos` text NOT NULL DEFAULT '[]',
  `opciones` text NOT NULL DEFAULT '[]',
  `precio` decimal(10,0) DEFAULT 0,
  `valor` int(11) DEFAULT 0,
  `image` text NOT NULL,
  `image_2` text NOT NULL,
  `image_3` text NOT NULL,
  `image_4` text NOT NULL,
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

INSERT INTO `productos` (`ID`, `usuario`, `sku`, `producto`, `categoria`, `atributos`, `opciones`, `precio`, `valor`, `image`, `image_2`, `image_3`, `image_4`, `stock`, `web`, `activo`, `proveedor`, `fecha`, `f_actualizado`) VALUES
(1, 1, 'B001', 'Babucha modelo B001', '10', '[{\"opcion\":\"Talla\",\"opciones\":\"34,35,36\"}]', '[{\"name\":\"Talla: 34\",\"sku\":\"B001\",\"precio\":\"45000\",\"stock\":9},{\"name\":\"Talla: 35\",\"sku\":\"B001\",\"precio\":\"45000\",\"stock\":10},{\"name\":\"Talla: 36\",\"sku\":\"B001\",\"precio\":\"45000\",\"stock\":10}]', '45000', 5, '51eCA6Cff276Db8F.jpeg', '', '', '', 'false', 'true', 1, 1, '2022-11-06', NULL),
(2, 1, 'O02', 'Oxford modelo O02', '10', '[{\"opcion\":\"Talla\",\"opciones\":\"34\"}]', '[{\"name\":\"Talla: 34\",\"sku\":\"O02\",\"precio\":\"55000\",\"stock\":8}]', '55000', 15, 'FC19b01aa9f5bED0.jpeg', '', '', '', 'false', 'true', 1, 1, '2022-11-16', NULL),
(3, 1, 'M01', 'Mocasin modelo M01', '10', '[{\"opcion\":\"Talla\",\"opciones\":\"34\"}]', '[{\"name\":\"Talla: 34\",\"sku\":\"M01\",\"precio\":\"65000\",\"stock\":7}]', '65000', 15, 'e29fCe230aaBe43c.jpeg', '', '', '', 'false', 'true', 1, 1, '2022-11-16', NULL),
(4, 1, 'B12', 'Babucha modelo B12', '10', '[{\"opcion\":\"Talla\",\"opciones\":\"34\"}]', '[{\"name\":\"Talla: 34\",\"sku\":\"B12\",\"precio\":\"55000\",\"stock\":10}]', '55000', 15, '4a3B5eDF47fAae3E.png', '', '', '', 'false', 'true', 1, 1, '2022-11-21', NULL),
(5, 1, 'B22', 'Babuchas modelo B22', '10', '[{\"opcion\":\"Talla\",\"opciones\":\"34\"}]', '[{\"name\":\"Talla: 34\",\"sku\":\"B22\",\"precio\":\"55000\",\"stock\":10}]', '55000', 15, 'A26c9DAac1FDC5AD.jpeg', '', '', '', 'false', 'true', 1, 1, '2022-11-21', NULL),
(6, 2, 'O10', 'Oxford en punta', '11', '[{\"opcion\":\"Talla\",\"opciones\":\"34\"}]', '[{\"name\":\"Talla: 34\",\"sku\":\"O10\",\"precio\":0,\"stock\":8}]', '55000', 10, 'bdAcDC727D9a9aAB.png', '', '', '', 'false', 'true', 1, 2, '2022-11-23', NULL),
(7, 2, 'O11', 'Oxford en punta O11', '', '[{\"opcion\":\"Talla\",\"opciones\":\"34\"}]', '[{\"name\":\"Talla: 34\",\"sku\":\"O11\",\"precio\":0,\"stock\":10}]', '55000', 10, '31cBe3aafBd4243F.jpeg', '', '', '', 'false', 'true', 1, 2, '2022-11-23', NULL);

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
(1, 2, 'Jesus', '27481532-9', '948977182', 'jsstoniha@gmail.com', 'Quintero');

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
(2, 2, 2),
(4, 6, 1),
(3, 7, 1);

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
(1, 'jsstoniha@gmail.com', '1515', 'Zapatostop', '27481532-9', '945692310', '', '27481532-9', 'BANC', 'Cuen', '27481532-9', 'F6c27cC63ffF0343.jpeg', '81E7CE1019D7.jpeg', '', ''),
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
-- Indices de la tabla `colecciones`
--
ALTER TABLE `colecciones`
  ADD PRIMARY KEY (`ID`);

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
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `colecciones`
--
ALTER TABLE `colecciones`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `control_pedido`
--
ALTER TABLE `control_pedido`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `movimientos`
--
ALTER TABLE `movimientos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `order_id`
--
ALTER TABLE `order_id`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `retiros`
--
ALTER TABLE `retiros`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `solicitar`
--
ALTER TABLE `solicitar`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `subs`
--
ALTER TABLE `subs`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
