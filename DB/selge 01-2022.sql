-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 17-01-2022 a las 16:22:46
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
-- Estructura de tabla para la tabla `cambios`
--

CREATE TABLE `cambios` (
  `ID` int(11) NOT NULL,
  `fecha` date NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `sku` text NOT NULL,
  `producto` text NOT NULL,
  `opciones` text NOT NULL,
  `opcion` text NOT NULL,
  `razon` text NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `cambios`
--

INSERT INTO `cambios` (`ID`, `fecha`, `id_pedido`, `sku`, `producto`, `opciones`, `opcion`, `razon`, `usuario`) VALUES
(1, '2022-01-16', 1, '12', 'Balerina Modelo #12', 'Talla', '42', 'le queda apretado', 1);

--
-- Disparadores `cambios`
--
DELIMITER $$
CREATE TRIGGER `actualizar_pedido_cambio` AFTER INSERT ON `cambios` FOR EACH ROW INSERT INTO pedidos (sku, producto, opciones, opcion, valor, medio, abono, delivery, empresa, pago, npedido, fecha, serial, rut, producir, estado, usuario) SELECT NEW.sku, NEW.producto, NEW.opciones, NEW.opcion, 1, medio, abono, delivery, empresa, pago, npedido, NEW.fecha AS fecha, '', rut, 1 AS producir, 1 AS estado, usuario FROM pedidos WHERE ID = NEW.id_pedido
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `cambio_pedido_estado` AFTER INSERT ON `cambios` FOR EACH ROW UPDATE pedidos SET estado = 5 WHERE ID = NEW.id_pedido
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categorias`
--

CREATE TABLE `categorias` (
  `ID` int(11) NOT NULL,
  `nombre` text NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `categorias`
--

INSERT INTO `categorias` (`ID`, `nombre`, `usuario`) VALUES
(1, 'Sin Categoría', 0),
(4, 'Zapatos', 1),
(5, 'Zapatillas', 1),
(7, 'Sin Categoría', 1);

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
(37, 'Jesus Perez', '44204200-4', '+56945692310', 'jsstoniha@gmail.com', 'Quintero', 1),
(38, 'Jesus Antonio Perez', '27481532-9', '+56945692310', 'jsstoniha@gmail.com', 'Valaparaiso 595', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `despacho`
--

CREATE TABLE `despacho` (
  `ID` int(11) NOT NULL,
  `guia` varchar(64) NOT NULL,
  `costo` double NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `empresa` text NOT NULL,
  `fecha` date NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `despacho`
--

INSERT INTO `despacho` (`ID`, `guia`, `costo`, `id_pedido`, `empresa`, `fecha`, `usuario`) VALUES
(1, '12563695253', 4750, 1, 'Starken', '2022-01-16', 1);

--
-- Disparadores `despacho`
--
DELIMITER $$
CREATE TRIGGER `pedido enviado` AFTER INSERT ON `despacho` FOR EACH ROW UPDATE pedidos SET estado = 4 WHERE ID = NEW.id_pedido
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `entradas`
--

CREATE TABLE `entradas` (
  `ID` int(11) NOT NULL,
  `sku` varchar(36) NOT NULL,
  `usuario` int(11) NOT NULL,
  `opcion` varchar(66) NOT NULL,
  `opciones` longtext NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `entradas`
--

INSERT INTO `entradas` (`ID`, `sku`, `usuario`, `opcion`, `opciones`, `fecha`) VALUES
(1, '12', 1, 'Talla', '{\"40\":\"2\"}', '2022-01-07');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `gastos`
--

CREATE TABLE `gastos` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `documento` text NOT NULL,
  `tipo` text NOT NULL,
  `desde` text NOT NULL,
  `fecha` date NOT NULL,
  `total` int(11) DEFAULT NULL,
  `abono` int(11) DEFAULT 0,
  `estado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `gastos`
--

INSERT INTO `gastos` (`ID`, `usuario`, `documento`, `tipo`, `desde`, `fecha`, `total`, `abono`, `estado`) VALUES
(3, 1, '1', 'Compras para la casa 2 harian pan 1 mantequilla 1 cafe', '1', '2021-02-02', 8000, 8000, NULL),
(4, 1, '2', 'Gas', '1', '2021-02-02', 8400, 8400, NULL),
(7, 1, '3', 'Pago de arriendo', '1', '2021-03-08', 80000, 80000, NULL),
(8, 1, '4', 'Agua', '1', '2021-03-13', 2500, 2500, NULL),
(9, 1, '5', 'Comida en el mes', '1', '2021-03-11', 80000, 80000, NULL),
(10, 1, '6', 'Mercaderia Valparaiso', '1', '2021-05-08', 23000, 23000, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opciones`
--

CREATE TABLE `opciones` (
  `ID` int(11) NOT NULL,
  `opcion` text NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `opciones`
--

INSERT INTO `opciones` (`ID`, `opcion`, `usuario`) VALUES
(1, '[{\"talla\":[34,35,36,37,38,39,40,41,42,43], \"color\":[\"azul\", \"verde\"]}]', 1);

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
(1, 1, 12941);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pedidos`
--

CREATE TABLE `pedidos` (
  `ID` int(11) NOT NULL,
  `sku` varchar(16) NOT NULL,
  `producto` text NOT NULL,
  `precio` double NOT NULL,
  `opciones` set('Color','Talla','Diseño','Peso','Olor','Sensación','Ingredientes','Otro') NOT NULL,
  `opcion` varchar(26) NOT NULL,
  `valor` int(11) NOT NULL DEFAULT 1,
  `medio` varchar(26) NOT NULL,
  `abono` double NOT NULL,
  `delivery` double NOT NULL,
  `empresa` text NOT NULL,
  `pago` int(11) NOT NULL DEFAULT 0,
  `npedido` int(9) DEFAULT NULL,
  `fecha` date NOT NULL,
  `serial` varchar(9) NOT NULL,
  `rut` varchar(11) NOT NULL,
  `producir` int(11) NOT NULL DEFAULT 1,
  `estado` int(11) NOT NULL DEFAULT 1,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `pedidos`
--

INSERT INTO `pedidos` (`ID`, `sku`, `producto`, `precio`, `opciones`, `opcion`, `valor`, `medio`, `abono`, `delivery`, `empresa`, `pago`, `npedido`, `fecha`, `serial`, `rut`, `producir`, `estado`, `usuario`) VALUES
(1, '48', 'Mocasín  Modelo #48', 50, 'Talla', '41', 1, '1', 115000, 0, 'Starken', 0, 12940, '2022-01-16', '552688507', '44204200-4', 2, 5, 1),
(2, '546', 'Balerina Modelo Estela', 65, 'Talla', '41', 1, '1', 115000, 0, 'Starken', 0, 12940, '2022-01-16', '332013920', '44204200-4', 2, 3, 1),
(3, '12', 'Balerina Modelo #12', 42, 'Talla', '37', 1, '3', 137000, 4500, 'Chilexpress', 1, 12941, '2022-01-16', '283045951', '27481532-9', 2, 3, 1),
(4, '2', 'Balerina  Modelo #2', 45, 'Talla', '37', 1, '3', 137000, 4500, 'Chilexpress', 1, 12941, '2022-01-16', '238161080', '27481532-9', 2, 3, 1),
(5, '2000', 'Oxford  Modelo #2000', 50, 'Talla', '37', 1, '3', 137000, 4500, 'Chilexpress', 1, 12941, '2022-01-16', '562853912', '27481532-9', 2, 2, 1),
(6, '12', 'Balerina Modelo #12', 0, 'Talla', '42', 1, '1', 115000, 0, 'Starken', 0, 12940, '2022-01-16', '', '44204200-4', 1, 1, 1);

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
  `atributos` text NOT NULL,
  `precio` decimal(10,0) DEFAULT NULL,
  `web` int(11) NOT NULL,
  `activo` int(11) NOT NULL DEFAULT 1,
  `fecha` date NOT NULL,
  `f_actualizado` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`ID`, `usuario`, `sku`, `image`, `producto`, `categoria`, `atributos`, `precio`, `web`, `activo`, `fecha`, `f_actualizado`) VALUES
(1, 1, '1108', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261677253.jpg', 'Babucha Adela Modelo', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', '2021-12-28'),
(2, 1, '1151', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1950692643.jpg', 'Babucha Alhelí', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(3, 1, '1153', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1974211431.jpg', 'Babucha Alhelí', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(4, 1, 'B1151', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1950692643.jpg', 'Babucha Alhelí  Modelo #1151', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(5, 1, 'B1153', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1974211431.jpg', 'Babucha Alhelí  Modelo #1153', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(6, 1, '1105', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261635997.jpg', 'Babucha Modelo Abby', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(7, 1, 'B1105', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261635997.jpg', 'Babucha Modelo Abby', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(8, 1, '1106', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682179674.jpg', 'Babucha Modelo Abby', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(9, 1, 'B1106', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682179674.jpg', 'Babucha Modelo Abby', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(10, 1, '1085', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263564698.jpg', 'Babucha Modelo Adalis', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(11, 1, '1104', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682179669.jpg', 'Babucha Modelo Adalis', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(12, 1, '1087', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682819089.jpg', 'Babucha Modelo Adalis', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(13, 1, '1107', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682819058.jpg', 'Babucha Modelo Adalis', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(14, 1, 'B1104', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682179669.jpg', 'Babucha Modelo Adalis', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(15, 1, 'B1107', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682819058.jpg', 'Babucha Modelo Adalis', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(16, 1, '1093', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682177910.jpg', 'Babucha Modelo Melisa', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(17, 1, '1048', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263639257.jpg', 'BABUCHAS Modelo Josefina', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(18, 1, '564', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682244433.jpg', 'BABUCHAS Modelo Josefina', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(19, 1, '1035', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682819164.jpg', 'BABUCHAS Modelo Josefina', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(20, 1, 'B564', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682244433.jpg', 'BABUCHAS Modelo Josefina', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(21, 1, 'B1035', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682819164.jpg', 'BABUCHAS Modelo Josefina', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(22, 1, 'B1091', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1298886450.jpg', 'Balerina Adila Modelo #1091', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(23, 1, '1046', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269719854.jpg', 'Balerina Elizabeth Modelo #1046', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(24, 1, '1013', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1594455820.jpg', 'Balerina en punta #1013', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(25, 1, '1015', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682888281.jpg', 'Balerina en punta 1015', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(26, 1, '1091', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1298886450.jpg', 'Balerina en punta #1091', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(27, 1, '37', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682831272.jpg', 'Balerina en punta #37', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(28, 1, '38', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682179724.jpg', 'Balerina en punta #38', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(29, 1, '40', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259515198.jpg', 'Balerina en punta #40', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(30, 1, '41', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682244477.jpg', 'Balerina en punta #41', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(31, 1, '519', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682180408.jpg', 'Balerina en punta #519', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(32, 1, '515', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261866376.jpg', 'Balerina en punta Modelo Mía', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(33, 1, '516', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682180458.jpg', 'Balerina en punta Modelo Mía', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(34, 1, '196', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682180463.jpg', 'Balerina en punta Modelo Mía', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(35, 1, '216', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682178410.jpg', 'Balerina en punta Modelo Mía', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(36, 1, 'B515', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261866376.jpg', 'Balerina en punta Modelo Mía', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(37, 1, 'B216', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682178410.jpg', 'Balerina en punta Modelo Mía', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(38, 1, 'B516', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682180458.jpg', 'Balerina en punta Modelo Mía', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(39, 1, 'B196', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682180463.jpg', 'Balerina en punta Modelo Mía', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(40, 1, '1045', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269755317.jpg', 'Balerina Milena Modelo #1045', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(41, 1, '1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261813717.jpg', 'Balerina Modelo #1', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(42, 1, '10', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259442534.jpg', 'Balerina Modelo #10', 'Sin Categoría', '[]', '42', 0, 1, '2021-11-29', NULL),
(43, 1, '1072', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2053150258.jpg', 'Balerina Modelo #1072', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(44, 1, '1073', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259549409.jpg', 'Balerina Modelo #1073', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(45, 1, '1074', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259547240.jpg', 'Balerina  Modelo #1074', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(46, 1, '1075', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259551236.jpg', 'Balerina  Modelo #1075', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(47, 1, '1076', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1660951301.jpg', 'BALERINA Modelo #1076', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(48, 1, '1110', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682180478.jpg', 'Balerina  Modelo #1110', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(49, 1, '1111', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682177224.jpg', 'Balerina  Modelo #1111', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(50, 1, 'B1111', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682177224.jpg', 'Balerina  Modelo #1111', 'Sin Categoría', '[]', '40', 0, 1, '2021-11-29', NULL),
(51, 1, '1112', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259549355.jpg', 'Balerina  Modelo #1112', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(52, 1, '1162', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682879567.jpg', 'Balerina Modelo #1162', 'Sin Categoría', '[]', '42', 0, 1, '2021-11-29', NULL),
(53, 1, '1163', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682878012.jpg', 'Balerina Modelo #1163', 'Sin Categoría', '[]', '42', 0, 1, '2021-11-29', NULL),
(54, 1, '12', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682177244.jpg', 'Balerina Modelo #12', 'Sin Categoría', '[{\"atributo\":\"Planta\",\"valor\":\"Guala\"}]', '42', 0, 1, '2021-11-29', '2021-12-28'),
(55, 1, '182', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682881414.jpg', 'Balerina Modelo #182', 'Sin Categoría', '[]', '42', 0, 1, '2021-11-29', NULL),
(56, 1, '2', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259564873.jpg', 'Balerina  Modelo #2', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(57, 1, '2004', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682855030.jpg', 'Balerina Modelo #2004', 'Sin Categoría', '[]', '42', 0, 1, '2021-11-29', NULL),
(58, 1, '26', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269736693.jpg', 'Balerina Modelo #26', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(59, 1, '3', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261815445.jpg', 'Balerina Modelo #3', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(60, 1, '5', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1413163733.jpg', 'Balerina Modelo #5', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(61, 1, '573', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682831331.jpg', 'Balerina Modelo #573', 'Sin Categoría', '[]', '42', 0, 1, '2021-11-29', NULL),
(62, 1, '97', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682177214.jpg', 'Balerina  Modelo #97', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(63, 1, 'B97', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682177214.jpg', 'Balerina  Modelo #97', 'Sin Categoría', '[]', '40', 0, 1, '2021-11-29', NULL),
(64, 1, 'B1112', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259549355.jpg', 'Balerina  Modelo Alizee', 'Sin Categoría', '[]', '40', 0, 1, '2021-11-29', NULL),
(65, 1, '7', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1308372194.jpg', 'Balerina Modelo Anais', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(66, 1, 'B7', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1308372194.jpg', 'Balerina Modelo Anais', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(67, 1, '2003', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682879535.jpg', 'Balerina Modelo Anais', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(68, 1, '8', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682180488.jpg', 'Balerina Modelo Anais', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(69, 1, '180', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682819224.jpg', 'Balerina Modelo Anais', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(70, 1, 'B2003', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682879535.jpg', 'Balerina Modelo Anais', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(71, 1, 'B180', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682819224.jpg', 'Balerina Modelo Anais', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(72, 1, 'B8', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682180488.jpg', 'Balerina Modelo Anais', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(73, 1, 'B12', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682177244.jpg', 'Balerina Modelo Annie', 'Sin Categoría', '[]', '40', 0, 1, '2021-11-29', NULL),
(74, 1, 'B2004', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682855030.jpg', 'Balerina Modelo Annie', 'Sin Categoría', '[]', '40', 0, 1, '2021-11-29', NULL),
(75, 1, 'B573', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682831331.jpg', 'Balerina Modelo Annie', 'Sin Categoría', '[]', '40', 0, 1, '2021-11-29', NULL),
(76, 1, 'B1015', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682888281.jpg', 'Balerina Modelo Diana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(77, 1, '546', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267933503.jpg', 'Balerina Modelo Estela', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(78, 1, '548', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682881421.jpg', 'Balerina Modelo Estela', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(79, 1, '549', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682878022.jpg', 'Balerina Modelo Estela', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(80, 1, '550', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682178462.jpg', 'Balerina Modelo Estela', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(81, 1, 'B546', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267933503.jpg', 'Balerina Modelo Estela', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(82, 1, 'B550', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682178462.jpg', 'Balerina Modelo Estela', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(83, 1, 'B548', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682881421.jpg', 'Balerina Modelo Estela', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(84, 1, '517', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1262598652.jpg', 'Balerina Modelo Londres', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(85, 1, '501', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682888291.jpg', 'Balerina Modelo Londres', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(86, 1, '518', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682178492.jpg', 'Balerina Modelo Londres', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(87, 1, '502', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682878027.jpg', 'Balerina Modelo Londres', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(88, 1, '500', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682178482.jpg', 'Balerina Modelo Londres', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(89, 1, 'B502', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682878027.jpg', 'Balerina Modelo Londres', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(90, 1, 'B518', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682178492.jpg', 'Balerina Modelo Londres', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(91, 1, '545', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267951273.jpg', 'Balerina Modelo Luna', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(92, 1, '530', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682831413.jpg', 'Balerina Modelo Luna', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(93, 1, '521', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933750.jpg', 'Balerina Modelo Luna', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(94, 1, 'B521', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933750.jpg', 'Balerina Modelo Luna', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(95, 1, '232', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261813822.jpg', 'Ballerina Modelo #232', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(96, 1, '1063', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311904638.jpg', 'Begonia Modelo #1063', 'Sin Categoría', '[]', '79', 0, 1, '2021-11-29', NULL),
(97, 1, '259', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1299144280.jpg', 'Bota Emilia  Modelo #259', 'Sin Categoría', '[]', '88', 0, 1, '2021-11-29', NULL),
(98, 1, '292', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1299144311.jpg', 'Bota Emilia  Modelo #292', 'Sin Categoría', '[]', '88', 0, 1, '2021-11-29', NULL),
(99, 1, '143', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1282223144.jpg', 'Bota  Modelo #143', 'Sin Categoría', '[]', '88', 0, 1, '2021-11-29', NULL),
(100, 1, '258', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1282229036.jpg', 'Bota Modelo #258', 'Sin Categoría', '[]', '88', 0, 1, '2021-11-29', NULL),
(101, 1, '264', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2193148143.jpg', 'Bota  Modelo #264', 'Sin Categoría', '[]', '88', 0, 1, '2021-11-29', NULL),
(102, 1, '78', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1282239970.jpg', 'BOTA Modelo #78', 'Sin Categoría', '[]', '88', 0, 1, '2021-11-29', NULL),
(103, 1, '79', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1282248029.jpg', 'Bota Modelo #79', 'Sin Categoría', '[]', '88', 0, 1, '2021-11-29', NULL),
(104, 1, '1171', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2038579481.jpg', 'Botín Carlota Modelo #1171', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(105, 1, 'B1171', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2038579481.jpg', 'Botín Carlota Modelo #1171', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(106, 1, '579', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1338001121.jpg', 'Botín Luciana  Modelo #579', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(107, 1, '254', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1336684296.jpg', 'Botín Modelo Adolfina', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(108, 1, '249', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682929008.jpg', 'Botín Modelo Adolfina', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(109, 1, '290', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267897782.jpg', 'Botín Modelo Amaro', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(110, 1, '289', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682928525.jpg', 'Botín Modelo Amaro', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(111, 1, '1002', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269672793.jpg', 'Botín Modelo Amelia', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(112, 1, 'B1002', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269672793.jpg', 'Botín Modelo Amelia', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(113, 1, '1003', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933505.jpg', 'Botín Modelo Amelia', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(114, 1, '1001', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682929023.jpg', 'Botín Modelo Amelia', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(115, 1, '1006', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1338739739.jpg', 'Botín Modelo Ana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(116, 1, '1004', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682928540.jpg', 'Botín Modelo Ana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(117, 1, '1005', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933510.jpg', 'Botín Modelo Ana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(118, 1, '1132', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1408918670.jpg', 'Botín Modelo Antonella', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(119, 1, '1133', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682929033.jpg', 'Botín Modelo Antonella', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(120, 1, '251', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1338703909.jpg', 'Botín Modelo Apolo', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL),
(121, 1, '250', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933023.jpg', 'Botín Modelo Apolo', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL),
(122, 1, '497', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2500602483.jpg', 'Botín Modelo Canela', 'Sin Categoría', '[]', '78', 0, 1, '2021-11-29', NULL),
(123, 1, 'B497', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2500602483.jpg', 'Botín Modelo Canela', 'Sin Categoría', '[]', '78', 0, 1, '2021-11-29', NULL),
(124, 1, '498', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682929078.jpg', 'Botín Modelo Canela', 'Sin Categoría', '[]', '78', 0, 1, '2021-11-29', NULL),
(125, 1, '1186', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2292239454.jpg', 'Botín Modelo Charlotte', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(126, 1, 'B1185', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2292239454.jpg', 'Botín Modelo Charlotte', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(127, 1, '1185', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682932067.jpg', 'Botín Modelo Charlotte', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(128, 1, '1187', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682921093.jpg', 'Botín Modelo Charlotte', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(129, 1, 'B1187', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682921093.jpg', 'Botín Modelo Charlotte', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(130, 1, '257', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267909710.jpg', 'Botín Modelo Clemente', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(131, 1, '248', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682934279.jpg', 'Botín Modelo Clemente', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(132, 1, '285', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682929097.jpg', 'Botín Modelo Clemente', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(133, 1, '1037', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263840168.jpg', 'Botín Modelo Dalia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(134, 1, 'B1037', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263840168.jpg', 'Botín Modelo Dalia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(135, 1, '1182', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682928620.jpg', 'Botín Modelo Dalia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(136, 1, '1038', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933599.jpg', 'Botín Modelo Dalia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(137, 1, 'B1182', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682928620.jpg', 'Botín Modelo Dalia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(138, 1, '1032', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263818640.jpg', 'Botín Modelo Esperanza', 'Sin Categoría', '[]', '80', 0, 1, '2021-11-29', NULL),
(139, 1, 'B1032', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263818640.jpg', 'Botín Modelo Esperanza', 'Sin Categoría', '[]', '80', 0, 1, '2021-11-29', NULL),
(140, 1, '1031', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682929142.jpg', 'Botín Modelo Esperanza', 'Sin Categoría', '[]', '80', 0, 1, '2021-11-29', NULL),
(141, 1, '1033', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682932081.jpg', 'Botín Modelo Esperanza', 'Sin Categoría', '[]', '80', 0, 1, '2021-11-29', NULL),
(142, 1, '574', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682945833.jpg', 'Botín Modelo Esperanza', 'Sin Categoría', '[]', '80', 0, 1, '2021-11-29', NULL),
(143, 1, 'B574', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682945833.jpg', 'Botín Modelo Esperanza', 'Sin Categoría', '[]', '80', 0, 1, '2021-11-29', NULL),
(144, 1, 'B1033', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682932081.jpg', 'Botín Modelo Esperanza', 'Sin Categoría', '[]', '80', 0, 1, '2021-11-29', NULL),
(145, 1, '1053', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1270036459.jpg', 'Botín Modelo Fabiana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(146, 1, '1052', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933070.jpg', 'Botín Modelo Fabiana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(147, 1, '1034', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682945840.jpg', 'Botín Modelo Fabiana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(148, 1, '1054', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682928629.jpg', 'Botín Modelo Fabiana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(149, 1, 'B1052', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933070.jpg', 'Botín Modelo Fabiana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(150, 1, 'B1034', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682945840.jpg', 'Botín Modelo Fabiana', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(151, 1, '569', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1262582510.jpg', 'Botín Modelo Flor', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(152, 1, '571', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682928642.jpg', 'Botín Modelo Flor', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(153, 1, '572', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682921125.jpg', 'Botín Modelo Flor', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(154, 1, '570', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682934304.jpg', 'Botín Modelo Flor', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(155, 1, 'B570', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682934304.jpg', 'Botín Modelo Flor', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(156, 1, '1039', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267909450.jpg', 'Botín Modelo Francia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(157, 1, '1041', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933878.jpg', 'Botín Modelo Francia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(158, 1, '1040', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682929157.jpg', 'Botín Modelo Francia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(159, 1, 'B1041', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933878.jpg', 'Botín Modelo Francia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(160, 1, 'B1039', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267909450.jpg', 'Botín Modelo Francia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(161, 1, '1174', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2057152094.jpg', 'Botín Modelo Gabriela', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(162, 1, '1173', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682921135.jpg', 'Botín Modelo Gabriela', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(163, 1, '592', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267973829.jpg', 'Botín Modelo Ignacia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(164, 1, '581', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933091.jpg', 'Botín Modelo Ignacia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(165, 1, '1050', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933896.jpg', 'Botín Modelo Ignacia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(166, 1, '593', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933643.jpg', 'Botín Modelo Ignacia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(167, 1, 'B1050', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933896.jpg', 'Botín Modelo Ignacia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(168, 1, 'B581', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2682933091.jpg', 'Botín Modelo Ignacia', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(169, 1, '255', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1267996427.jpg', 'Botín Modelo Karen', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(170, 1, '288', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203327.jpg', 'Botín Modelo Karen', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(171, 1, '253', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203563.jpg', 'Botín Modelo Karen', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(172, 1, '496', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203800.jpg', 'Botín Modelo Karen', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(173, 1, '493', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203322.jpg', 'Botín Modelo Karen', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(174, 1, '278', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685202836.jpg', 'Botín Modelo Karen', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(175, 1, '492', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685211565.jpg', 'Botín Modelo Karen', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(176, 1, '273', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269668713.jpg', 'Botín Modelo Leah', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(177, 1, '274', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203332.jpg', 'Botín Modelo Leah', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(178, 1, '1135', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263833470.jpg', 'Botín Modelo Melí', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(179, 1, '586', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685215550.jpg', 'Botín Modelo Melí', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(180, 1, '1168', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2037766641.jpg', 'Botín Modelo Sara', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(181, 1, '124', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1321461060.jpg', 'Botín Modelo Sicot', 'Sin Categoría', '[]', '75', 0, 1, '2021-11-29', NULL),
(182, 1, '85', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685202846.jpg', 'Botín Modelo Sicot', 'Sin Categoría', '[]', '75', 0, 1, '2021-11-29', NULL),
(183, 1, '1175', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2057141148.jpg', 'Botín Modelo Tamy', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(184, 1, 'B1175', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2057141148.jpg', 'Botín Modelo Tamy', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(185, 1, '1170', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203337.jpg', 'Botín Modelo Tamy', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(186, 1, '1176', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203573.jpg', 'Botín Modelo Tamy', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(187, 1, 'B1170', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203337.jpg', 'Botín Modelo Tamy', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(188, 1, 'B1176', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203573.jpg', 'Botín Modelo Tamy', 'Sin Categoría', '[]', '72', 0, 1, '2021-11-29', NULL),
(189, 1, '265', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263600215.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(190, 1, '291', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203805.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(191, 1, '93', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685215585.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(192, 1, '536', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203578.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(193, 1, '92', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685386546.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(194, 1, '272', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685202087.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(195, 1, '91', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203845.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(196, 1, 'B91', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203845.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(197, 1, 'B92', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685386546.jpg', 'Botín Modelo Texano', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(198, 1, '583', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263732051.jpg', 'Botín Modelo Thomas', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(199, 1, 'B583', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263732051.jpg', 'Botín Modelo Thomas', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(200, 1, '596', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685386556.jpg', 'Botín Modelo Thomas', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(201, 1, '235', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1270383542.jpg', 'Botín Modelo Veraniego', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(202, 1, '237', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203649.jpg', 'Botín Modelo Veraniego', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(203, 1, '234', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685202131.jpg', 'Botín Modelo Veraniego', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(204, 1, '543', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685203145.jpg', 'Botín Modelo Veraniego', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(205, 1, '236', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685211610.jpg', 'Botín Modelo Veraniego', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(206, 1, 'B234', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685202131.jpg', 'Botín Modelo Veraniego', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(207, 1, '1121', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1281013193.jpg', 'CALZADO ESCOLAR Modelo #1121', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(208, 1, '1122', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1281015449.jpg', 'CALZADO ESCOLAR Modelo #1122', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(209, 1, '1123', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1281020121.jpg', 'CALZADO ESCOLAR Modelo #1123', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(210, 1, '1188', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2292413825.jpg', 'Casandra Modelo #1188', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(211, 1, 'B1188', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2292413825.jpg', 'Casandra Modelo #1188', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(212, 1, '1010', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269907095.jpg', 'Elisa Modelo #1010', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(213, 1, 'B1010', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269907095.jpg', 'Elisa Modelo #1010', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(214, 1, '1011', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269889225.jpg', 'Elisa  Modelo #1011', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(215, 1, '1012', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269889197.jpg', 'Elisa  Modelo #1012', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(216, 1, '1068', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311911626.jpg', 'Jazmín  Modelo #1068', 'Sin Categoría', '[]', '79', 0, 1, '2021-11-29', NULL),
(217, 1, '1165', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2037562994.jpg', 'Josefa Modelo #1165', 'Sin Categoría', '[]', '67', 0, 1, '2021-11-29', NULL),
(218, 1, 'B1165', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2037562994.jpg', 'Josefa Modelo #1165', 'Sin Categoría', '[]', '67', 0, 1, '2021-11-29', NULL),
(219, 1, '1166', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2037996146.jpg', 'Josefa Modelo #1166', 'Sin Categoría', '[]', '67', 0, 1, '2021-11-29', NULL),
(220, 1, 'B1166', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2037996146.jpg', 'Josefa Modelo #1166', 'Sin Categoría', '[]', '67', 0, 1, '2021-11-29', NULL),
(221, 1, '1167', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2038162802.jpg', 'Josefa Modelo #1167', 'Sin Categoría', '[]', '67', 0, 1, '2021-11-29', NULL),
(222, 1, 'B1167', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2038162802.jpg', 'Josefa Modelo #1167', 'Sin Categoría', '[]', '67', 0, 1, '2021-11-29', NULL),
(223, 1, '551', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259534129.jpg', 'Makarena Modelo #551', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(224, 1, 'B551', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259534129.jpg', 'Makarena Modelo #551', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(225, 1, '553', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1269655312.jpg', 'Makarena  Modelo #553', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(226, 1, 'B554', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1270093124.jpg', 'Makarena  Modelo #554', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(227, 1, '554', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1270093124.jpg', 'Makarena  Modelo #554', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(228, 1, '1157', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1951388107.jpg', 'Margarita Modelo #1157', 'Sin Categoría', '[]', '57', 0, 1, '2021-11-29', NULL),
(229, 1, 'B1157', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1951388107.jpg', 'Margarita Modelo #1157', 'Sin Categoría', '[]', '57', 0, 1, '2021-11-29', NULL),
(230, 1, '1058', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1272068688.jpg', 'Mocasin Alba  Modelo #1058', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(231, 1, '1060', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1877872569.jpg', 'Mocasin Alba Modelo #1060', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(232, 1, 'B1060', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1877872569.jpg', 'Mocasin Alba Modelo #1060', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(233, 1, '1059', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1270088247.jpg', 'Mocasin Alondra Modelo #1059', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(234, 1, '1028', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259519313.jpg', 'Mocasin Amanda Modelo #1028', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(235, 1, '1029', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259534065.jpg', 'Mocasin Amanda Modelo #1029', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(236, 1, '1066', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1272110134.jpg', 'Mocasin Amanda Modelo #1066', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(237, 1, '1057', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1263587042.jpg', 'Mocasin Amapola  Modelo #1057', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(238, 1, '1144', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1693858224.jpg', 'Mocasín Henry Modelo #1144', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(239, 1, 'B1144', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1693858224.jpg', 'Mocasín Henry Modelo #1144', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(240, 1, '1080', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1895356225.jpg', 'Mocasin  Modelo #1080', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(241, 1, '1081', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1895176567.jpg', 'Mocasin Modelo #1081', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(242, 1, '1082', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1895515019.jpg', 'Mocasin Modelo #1082', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(243, 1, '1083', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1894333954.jpg', 'Mocasin  Modelo #1083', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(244, 1, '136', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2755014483.jpg', 'Mocasín Modelo #136', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(245, 1, '195', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261725865.jpg', 'Mocasín  Modelo #195', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(246, 1, '45', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2755249791.jpg', 'Mocasín  Modelo #45', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(247, 1, '46', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2476481214.jpg', 'Mocasín Modelo #46', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(248, 1, 'B46', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2476481214.jpg', 'Mocasín Modelo #46', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(249, 1, '48', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261721652.jpg', 'Mocasín  Modelo #48', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(250, 1, 'B48', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261721652.jpg', 'Mocasín  Modelo #48', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(251, 1, '508', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261719688.jpg', 'Mocasín Modelo #508', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(252, 1, '51', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311864154.jpg', 'Mocasín  Modelo #51', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(253, 1, '513', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259515419.jpg', 'Mocasín Modelo #513', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(254, 1, '94', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2755249801.jpg', 'Mocasín Modelo #53', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(255, 1, '53', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2755012484.jpg', 'Mocasín Modelo #53', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(256, 1, '541', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2755202146.jpg', 'Mocasín Modelo #541', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(257, 1, '294', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1676558463.jpg', 'Mocasín Modelo Ivana', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(258, 1, 'B294', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1676558463.jpg', 'Mocasín Modelo Ivana', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(259, 1, '295', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685868599.jpg', 'Mocasín Modelo Ivana', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(260, 1, 'B296', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685868604.jpg', 'Mocasín Modelo Ivana', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(261, 1, '298', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685868868.jpg', 'Mocasín Modelo Ivana', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(262, 1, 'B298', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685868868.jpg', 'Mocasín Modelo Ivana', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(263, 1, '296', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685868604.jpg', 'Mocasín Modelo Ivana', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(264, 1, '293', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2685833376.jpg', 'Mocasín Modelo Ivana', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(265, 1, '261', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1334913104.jpg', 'Oxford Augusto Modelo #261', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(266, 1, '271', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1334940598.jpg', 'Oxford Augusto Modelo #271', 'Sin Categoría', '[]', '55', 0, 1, '2021-11-29', NULL),
(267, 1, '1154', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427128542.jpg', 'Oxford en punta Amber  Modelo #1154', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(268, 1, 'B1154', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427128542.jpg', 'Oxford en punta Amber  Modelo #1154', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(269, 1, '1155', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427105418.jpg', 'Oxford en punta Amber  Modelo #1155', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(270, 1, 'B1155', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427105418.jpg', 'Oxford en punta Amber  Modelo #1155', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(271, 1, '1156', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427135605.jpg', 'Oxford en punta Amber  Modelo #1156', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(272, 1, '1172', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427141385.jpg', 'Oxford en punta Amber Modelo #1172', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(273, 1, 'B1172', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427141385.jpg', 'Oxford en punta Amber Modelo #1172', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(274, 1, '1179', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427175503.jpg', 'Oxford en punta Amber Modelo #1179', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(275, 1, 'B1179', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2427175503.jpg', 'Oxford en punta Amber Modelo #1179', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(276, 1, '1180', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2271731973.jpg', 'Oxford en punta Amber Modelo #1180', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(277, 1, 'B1180', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2271731973.jpg', 'Oxford en punta Amber Modelo #1180', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(278, 1, '1181', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2464513323.jpg', 'Oxford en punta Amber  Modelo #1181', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(279, 1, 'B1181', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2464513323.jpg', 'Oxford en punta Amber  Modelo #1181', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(280, 1, '184', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259332452.jpg', 'Oxford Modelo #184', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(281, 1, '193', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259399562.jpg', 'Oxford Modelo #193', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(282, 1, '2000', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1277335542.jpg', 'Oxford  Modelo #2000', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(283, 1, '238', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259364619.jpg', 'Oxford  Modelo #238', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(284, 1, 'B238', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259364619.jpg', 'Oxford  Modelo #238', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(285, 1, '27', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311862133.jpg', 'Oxford Modelo #27', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(286, 1, 'B27', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311862133.jpg', 'Oxford Modelo #27', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(287, 1, '29', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259435317.jpg', 'Oxford  Modelo #29', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(288, 1, 'B29', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259435317.jpg', 'Oxford  Modelo #29', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(289, 1, '30', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1262582806.jpg', 'Oxford Modelo #30', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(290, 1, '33', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259399609.jpg', 'Oxford Modelo #33', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(291, 1, 'B33', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259399609.jpg', 'Oxford Modelo #33', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(292, 1, '34', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259406469.jpg', 'Oxford  Modelo #34', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(293, 1, '36', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259399141.jpg', 'Oxford Modelo #36', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(294, 1, 'B36', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259399141.jpg', 'Oxford Modelo #36', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(295, 1, '525', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259320476.jpg', 'Oxford Modelo #525', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(296, 1, '526', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259332924.jpg', 'Oxford  Modelo #526', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(297, 1, '527', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2019801410.jpg', 'Oxford Modelo #527', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL);
INSERT INTO `productos` (`ID`, `usuario`, `sku`, `image`, `producto`, `categoria`, `atributos`, `precio`, `web`, `activo`, `fecha`, `f_actualizado`) VALUES
(298, 1, '54', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259395686.jpg', 'Oxford Modelo #54', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(299, 1, 'B54', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259395686.jpg', 'Oxford Modelo #54', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(300, 1, '542', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2545363028.jpg', 'Oxford Modelo #542', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(301, 1, '566', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1277542033.jpg', 'Oxford Modelo #566', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(302, 1, '58', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259320601.jpg', 'Oxford Modelo #58', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(303, 1, 'B58', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259320601.jpg', 'Oxford Modelo #58', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(304, 1, '594', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2544642499.jpg', 'Oxford Modelo #594', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(305, 1, '595', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259352671.jpg', 'Oxford  Modelo #595', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(306, 1, '598', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259320486.jpg', 'Oxford Modelo #598', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(307, 1, '599', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1262598351.jpg', 'Oxford  Modelo #599', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(308, 1, '95', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1454319192.jpg', 'Oxford Modelo #95', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(309, 1, 'B95', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1454319192.jpg', 'Oxford Modelo #95', 'Sin Categoría', '[]', '50', 0, 1, '2021-11-29', NULL),
(310, 1, '1159', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1974197442.jpg', 'oxford renata Modelo #1159', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(311, 1, 'B1159', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1974197442.jpg', 'oxford renata Modelo #1159', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(312, 1, '1064', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311911206.jpg', 'Reina Azucena Modelo #1064', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL),
(313, 1, '1065', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311903990.jpg', 'Reina Azucena Modelo #1065', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL),
(314, 1, 'B1065', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311903990.jpg', 'Reina Azucena Modelo #1065', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL),
(315, 1, '1158', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1974193596.jpg', 'Renata  Modelo #1158', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(316, 1, 'B1158', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1974193596.jpg', 'Renata  Modelo #1158', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(317, 1, '1160', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1974213440.jpg', 'Renata Modelo #1160', 'Sin Categoría', '[]', '60', 0, 1, '2021-11-29', NULL),
(318, 1, '1078', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261583504.jpg', 'Romana Modelo #1078', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(319, 1, 'B1078', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1261583504.jpg', 'Romana Modelo #1078', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(320, 1, '1079', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2053157293.jpg', 'Romana Modelo #1079', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(321, 1, '1092', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259534149.jpg', 'Romana Modelo #1092', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(322, 1, '1095', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259551169.jpg', 'Romana Modelo #1095', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(323, 1, 'B1095', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259551169.jpg', 'Romana Modelo #1095', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(324, 1, '1096', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259569058.jpg', 'Romana  Modelo #1096', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(325, 1, 'B1096', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259569058.jpg', 'Romana  Modelo #1096', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(326, 1, '1098', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259564035.jpg', 'Romana  Modelo #1098', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(327, 1, 'B1098', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259564035.jpg', 'Romana  Modelo #1098', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(328, 1, '1099', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259589853.jpg', 'Romana  Modelo #1099', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(329, 1, '1115', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259569103.jpg', 'Romana Modelo #1115', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(330, 1, '1116', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259549481.jpg', 'Romana Modelo #1116', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(331, 1, 'B1116', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1259549481.jpg', 'Romana Modelo #1116', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(332, 1, '1201', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2553468865.jpg', 'Romana Modelo #1201', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(333, 1, '1202', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2553554759.jpg', 'Romana Modelo #1202', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(334, 1, 'B1202', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2553554759.jpg', 'Romana Modelo #1202', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(335, 1, '1203', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2553349965.jpg', 'Romana Modelo #1203', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(336, 1, 'B1203', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2553349965.jpg', 'Romana Modelo #1203', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(337, 1, '1204', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2553468897.jpg', 'Romana Modelo #1204', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(338, 1, '1097', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1256456636.jpg', 'Romanas Modelo #1097', 'Sin Categoría', '[]', '45', 0, 1, '2021-11-29', NULL),
(339, 1, 'TR1100', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2760173215.jpg', 'Tarjeta regalo', 'Sin Categoría', '[]', '0', 0, 1, '2021-11-29', NULL),
(340, 1, '1164', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1999324472.jpg', 'Tiaré Modelo #1164', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(341, 1, 'B1164', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1999324472.jpg', 'Tiaré Modelo #1164', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(342, 1, '1042', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311907924.jpg', 'Valentina  Modelo #1042', 'Sin Categoría', '[]', '79', 0, 1, '2021-11-29', NULL),
(343, 1, 'B1042', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1311907924.jpg', 'Valentina  Modelo #1042', 'Sin Categoría', '[]', '79', 0, 1, '2021-11-29', NULL),
(344, 1, '1194', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2647688845.jpg', 'Zapatilla Apolo Modelo #1194', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(345, 1, 'B1194', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2647688845.jpg', 'Zapatilla Apolo Modelo #1194', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(346, 1, '1196', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2647390706.jpg', 'Zapatilla Con Caña Modelo #1196', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(347, 1, 'B1196', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2647390706.jpg', 'Zapatilla Con Caña Modelo #1196', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(348, 1, '1197', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2647375206.jpg', 'Zapatilla Con Caña Modelo #1197', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(349, 1, 'B1197', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2647375206.jpg', 'Zapatilla Con Caña Modelo #1197', 'Sin Categoría', '[]', '65', 0, 1, '2021-11-29', NULL),
(350, 1, '1190', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2429997516.jpg', 'Zapatilla  Modelo #1190', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(351, 1, 'B1190', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2429997516.jpg', 'Zapatilla  Modelo #1190', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(352, 1, '1191', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2429997511.jpg', 'Zapatilla Modelo #1191', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(353, 1, 'B1191', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2429997511.jpg', 'Zapatilla Modelo #1191', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(354, 1, '1198', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2542796429.jpg', 'Zapatilla  Modelo #1198', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(355, 1, '1199', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2542797786.jpg', 'Zapatilla  Modelo #1199', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(356, 1, 'B1199', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2542797786.jpg', 'Zapatilla  Modelo #1199', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(357, 1, '1200', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2541836692.jpg', 'Zapatilla  Modelo #1200', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(358, 1, 'B1200', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2541836692.jpg', 'Zapatilla  Modelo #1200', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(359, 1, '1192', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2429971218.jpg', 'Zapatilla Olivia Modelo #1192', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(360, 1, 'B1192', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2429971218.jpg', 'Zapatilla Olivia Modelo #1192', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(361, 1, '1193', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2429900936.jpg', 'Zapatilla Olivia Modelo #1193', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(362, 1, 'B1193', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2429900936.jpg', 'Zapatilla Olivia Modelo #1193', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(363, 1, '1195', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2647706815.jpg', 'Zapatilla Olivia Modelo #1195', 'Sin Categoría', '[]', '54', 0, 1, '2021-11-29', NULL),
(364, 1, 'B1195', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/2647706815.jpg', 'Zapatilla Olivia Modelo #1195', 'Sin Categoría', '[]', '0', 0, 1, '2021-11-29', NULL),
(365, 1, '1138', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1475576593.jpg', 'Zapato de Hombre Modelo #1138', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL),
(366, 1, '1139', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1475583402.jpg', 'Zapato de Hombre Modelo #1139', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL),
(367, 1, '1140', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1475588142.jpg', 'Zapato de Hombre Modelo #1140', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL),
(368, 1, '1141', 'https://d2j6dbq0eux0bg.cloudfront.net/images/22541387/1475576786.jpg', 'Zapato de Hombre  Modelo #1141', 'Sin Categoría', '[]', '68', 0, 1, '2021-11-29', NULL);

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
(1, 1, 'Casa matriz', '27481532-9', '+56945692310', 'jsstoniha@gmail.com', 'Valparaiso');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `solicitar`
--

CREATE TABLE `solicitar` (
  `ID` int(11) NOT NULL,
  `npedido` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `nota` text NOT NULL,
  `usuario` int(11) NOT NULL,
  `estado` tinyint(4) NOT NULL DEFAULT 1,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `solicitar`
--

INSERT INTO `solicitar` (`ID`, `npedido`, `id_pedido`, `id_proveedor`, `nota`, `usuario`, `estado`, `fecha`) VALUES
(1, 12940, 1, 1, '', 1, 2, '2022-01-16'),
(2, 12941, 3, 1, '', 1, 2, '2022-01-16'),
(3, 12941, 4, 1, '', 1, 2, '2022-01-16'),
(4, 12941, 5, 1, '', 1, 1, '2022-01-16');

--
-- Disparadores `solicitar`
--
DELIMITER $$
CREATE TRIGGER `actualizar_pedido` AFTER INSERT ON `solicitar` FOR EACH ROW UPDATE pedidos SET producir = 2, estado = 2 WHERE ID = NEW.id_pedido
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `ID` int(11) NOT NULL,
  `email` text NOT NULL,
  `password` varchar(46) NOT NULL,
  `logo` text NOT NULL,
  `nombre` text NOT NULL,
  `rut` varchar(11) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `direccion` text NOT NULL,
  `impuestos` int(11) DEFAULT NULL,
  `moneda` varchar(5) NOT NULL,
  `rango` int(11) NOT NULL,
  `invitados` int(11) NOT NULL,
  `productos` int(11) NOT NULL,
  `admin` int(11) DEFAULT NULL,
  `color` varchar(12) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`ID`, `email`, `password`, `logo`, `nombre`, `rut`, `phone`, `direccion`, `impuestos`, `moneda`, `rango`, `invitados`, `productos`, `admin`, `color`) VALUES
(1, 'jsstoniha@gmail.com', 'ddr2hajesus', '/upload/264560445091.png', 'ZapatillasTop', '44204200-4', '951893723', 'Valparaiso Quintero Ohiggins, Magallanes', 19, 'CLP', 9, 0, 90, 1, '#3f3'),
(2, 'hackjp14@hotmail.com', 'ddr2hajesus', '', 'Zapatillastop.cl', '44204200-4', '987433198', 'VAlpo', NULL, 'CLP', 0, 0, 0, 0, ''),
(3, 'tilby.cl@gmail.com', '1515ha', '', 'TILBY', '44204200-4', '987433198', 'Luis Cousiño #2142', NULL, 'CLP', 1, 1, 1, 0, '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ventas`
--

CREATE TABLE `ventas` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `sku` varchar(36) NOT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `tipo` varchar(64) NOT NULL,
  `opcion` int(11) DEFAULT NULL,
  `precio` int(11) DEFAULT NULL,
  `valor` int(11) DEFAULT NULL,
  `pago` int(11) DEFAULT NULL COMMENT '1) efectivo, 2) debito, 3) credito, 4) cheque 5) deposito, 6) transferencia',
  `efectivo` double DEFAULT 0,
  `vuelto` double DEFAULT NULL,
  `rebank` text DEFAULT NULL,
  `cliente` int(11) DEFAULT NULL,
  `entrega` int(11) DEFAULT NULL COMMENT '1) entrega inmediata, 2) despachar',
  `documento` bigint(1) DEFAULT NULL COMMENT '1-Boleta, 2-Factura',
  `code` varchar(18) DEFAULT NULL,
  `enviado` int(11) DEFAULT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `cambios`
--
ALTER TABLE `cambios`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `categorias`
--
ALTER TABLE `categorias`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `categoria` (`nombre`,`usuario`) USING HASH;

--
-- Indices de la tabla `clientes`
--
ALTER TABLE `clientes`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `rut` (`rut`,`usuario`);

--
-- Indices de la tabla `despacho`
--
ALTER TABLE `despacho`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD PRIMARY KEY (`ID`) USING BTREE,
  ADD UNIQUE KEY `sku` (`sku`,`usuario`) USING BTREE;

--
-- Indices de la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `opciones`
--
ALTER TABLE `opciones`
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
  ADD UNIQUE KEY `pedidos` (`sku`,`opciones`,`opcion`,`npedido`,`producir`) USING BTREE;

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
-- Indices de la tabla `solicitar`
--
ALTER TABLE `solicitar`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `ventas`
--
ALTER TABLE `ventas`
  ADD PRIMARY KEY (`ID`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `cambios`
--
ALTER TABLE `cambios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=39;

--
-- AUTO_INCREMENT de la tabla `despacho`
--
ALTER TABLE `despacho`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `entradas`
--
ALTER TABLE `entradas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `opciones`
--
ALTER TABLE `opciones`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `order_id`
--
ALTER TABLE `order_id`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `pedidos`
--
ALTER TABLE `pedidos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=369;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `solicitar`
--
ALTER TABLE `solicitar`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
