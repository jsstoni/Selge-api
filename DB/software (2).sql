-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 01-09-2021 a las 15:10:24
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
-- Base de datos: `software`
--

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
(1, 'Sin Categoría', 0);

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
(4, 'Mario Cazas', '44202202-4', '981492844', 'jsstoniha@gmail.com', '', 0),
(5, 'Claudia Andrea Olivera Ceballos', '17733488-K', '972120211', 'tilby.cl@gmail.com', '', 0),
(10, 'Claudia Andrea Olivera Ceballos', '12329789-2', '951893723', 'hackjp14@hotmail.com', 'nueva', 1),
(21, 'Jesus Perez', '27481532-9', '945692310', 'jsstoniha@gmail.com', 'Valparaiso, Quintero Gomez Carreño 2431', 1);

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
(2, 'PG105-5A', 1, 'Talla', '{\"34\":\"2\",\"35\":\"1\",\"36\":\"3\",\"37\":\"1\"}', '2021-08-29'),
(59, 'PG823-5', 1, 'Talla', '{\"34\":0,\"35\":0,\"36\":\"1\"}', '2021-08-29'),
(64, 'PG822-10', 1, 'Talla', '{\"43\":\"2\"}', '2021-08-28'),
(66, 'PG831-8', 1, 'Talla', '{\"34\":\"3\",\"35\":\"1\"}', '2021-08-28'),
(67, 'PG831-1', 1, 'Talla', '{\"34\":\"1\",\"35\":\"1\",\"36\":\"1\"}', '2021-08-26'),
(68, 'PG143-13', 1, 'Talla', '{\"34\":\"2\",\"35\":\"3\",\"36\":\"4\",\"37\":\"4\",\"39\":\"4\"}', '2021-08-26');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `envios`
--

CREATE TABLE `envios` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `venta` varchar(12) NOT NULL,
  `envio` text NOT NULL,
  `guia` varchar(50) NOT NULL,
  `pago` int(11) NOT NULL COMMENT '1=Paga el cliente\r\n2=envio gratis',
  `valor` int(11) NOT NULL,
  `tipo` int(11) NOT NULL COMMENT '1=sucursal\r\n2=domicilio',
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

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
-- Estructura de tabla para la tabla `invitado`
--

CREATE TABLE `invitado` (
  `ID` int(11) NOT NULL,
  `user_admin` int(11) NOT NULL,
  `usuario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `opciones_envio`
--

CREATE TABLE `opciones_envio` (
  `ID` int(11) NOT NULL,
  `nombre` varchar(54) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paginas`
--

CREATE TABLE `paginas` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `titulo` varchar(70) NOT NULL,
  `contenido` longtext NOT NULL,
  `url` text NOT NULL,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `paginas`
--

INSERT INTO `paginas` (`ID`, `usuario`, `titulo`, `contenido`, `url`, `fecha`) VALUES
(3, 1, 'Sobre nosotros', 'Pagina sobre nosotros', 'sobre-nosotros', '2020-05-23');

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
  `valor` int(11) DEFAULT NULL,
  `precio` int(11) DEFAULT NULL,
  `modelo` varchar(54) NOT NULL,
  `web` int(11) NOT NULL,
  `activo` int(11) NOT NULL DEFAULT 1,
  `fecha` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `productos`
--

INSERT INTO `productos` (`ID`, `usuario`, `sku`, `image`, `producto`, `categoria`, `valor`, `precio`, `modelo`, `web`, `activo`, `fecha`) VALUES
(1, 1, 'PG143-14', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796333609.jpg', 'Sneakers ALL BLACK', 'Sin categoría', 8000, 15000, 'Mujer', 0, 1, '2021-03-10'),
(2, 1, 'PG821-5', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796038992.jpg', 'Sneakers BEIGEs', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10'),
(3, 1, 'PG138-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1951631276.jpg', 'Sneakers Black', 'Sin categoría', 7000, 15000, 'Hombre', 0, 1, '2021-03-10'),
(4, 1, 'PG105-1A', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1951579538.jpg', 'Sneakers Black', 'Sin categoría', 6500, 15000, 'Sin categoría', 0, 1, '2021-03-10'),
(5, 1, 'PG146-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1951537539.jpg', 'Sneakers Black', 'Sin categoría', 6500, 15000, 'Sin categoría', 0, 1, '2021-03-10'),
(6, 1, 'PG141-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1805169315.jpg', 'Sneakers BLACK', 'Sin categoría', 6500, 15000, 'Sin categoría', 0, 1, '2021-03-10'),
(7, 1, 'PG830-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1803988678.jpg', 'Sneakers BLACK', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(8, 1, 'PG823-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796333798.jpg', 'Sneakers BLACK', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(9, 1, 'PG828-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1798784399.jpg', 'Sneakers BLACK', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10'),
(10, 1, 'PG836-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796570196.jpg', 'Sneakers BLACK', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(11, 1, '2074-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1803915870.jpg', 'Sneakers BLACK', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(12, 1, 'PG123-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1951537303.jpg', 'Sneakers BLACK', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10'),
(13, 1, 'PG821-3', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796418208.jpg', 'Sneakers BLACK/ORCHID', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10'),
(14, 1, 'PG123-9', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1951537544.jpg', 'Sneakers DK. GREY', 'Sin categoría', 6500, 15000, 'Sin categoría', 0, 1, '2021-03-10'),
(15, 1, '2180-12', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1803915912.jpg', 'Sneakers LEOPARD', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(16, 1, 'ZT02', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825231708.jpg', 'Sneakers MEN BLACK', 'Sin categoría', 6500, 15000, 'Sin categoría', 0, 1, '2021-03-10'),
(17, 1, 'ZT06', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825518645.jpg', 'Sneakers Modelo Fran', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(18, 1, 'ZT04', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825492705.jpg', 'Sneakers Modelo Fran blanco con rosa', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(19, 1, 'ZT05', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825513721.jpg', 'Sneakers Modelo Fran blanco con verde', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(20, 1, 'ZT03', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825553322.jpg', 'Sneakers Modelo Fran colores', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(21, 1, 'ZT08', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825513711.jpg', 'Sneakers Modelo Gris', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(22, 1, 'ZT09', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825239707.jpg', 'Sneakers Modelo Print', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(23, 1, 'ZT07', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825434914.jpg', 'Sneakers Modelo Rose', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(24, 1, 'PG828-2', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796142703.jpg', 'Sneakers ORANGE', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10'),
(25, 1, '2073-15', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1805297506.jpg', 'Sneakers ORANGE', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(26, 1, 'PG102-7', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1951537293.jpg', 'Sneakers RED', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10'),
(27, 1, 'PG101-5', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1805340191.jpg', 'Sneakers White', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(28, 1, 'PG836-5', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796468982.jpg', 'Sneakers WHITE', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(29, 1, 'PG823-5', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796468327.jpg', 'Sneakers WHITE', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(30, 1, '2097-10', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1805340216.jpg', 'Sneakers WHITE', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(31, 1, 'PG831-1', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796422801.jpg', 'Sneakers WHITE/BLACK', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(32, 1, 'PG831-8', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796468564.jpg', 'Sneakers WHITE/GREEN', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(33, 1, 'ZT01', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1825533546.jpg', 'Sneakers WHITE ORANGE', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10'),
(34, 1, 'PG829-6', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1805352268.jpg', 'Sneakers WHITE/PINK', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(35, 1, 'PG829-7', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1805415761.jpg', 'Sneakers WHITE/RED', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(36, 1, 'PG822-10', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1805352315.jpg', 'Sneakers WHITE/YELLOW', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(37, 1, 'PG143-13', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1796127925.jpg', 'Sneakers WINE', 'Sin categoría', 6500, 15000, 'Mujer', 0, 1, '2021-03-10'),
(38, 1, 'PG123-13', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1951579000.jpg', 'Sneakers WINE', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10'),
(39, 1, 'PG105-5A', 'https://d2j6dbq0eux0bg.cloudfront.net/images/28658458/1951893025.jpg', 'Sneaker WHITE', 'Sin categoría', 6500, 15000, 'Hombre', 0, 1, '2021-03-10');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto_proveedor`
--

CREATE TABLE `producto_proveedor` (
  `ID` int(11) NOT NULL,
  `usuario` int(11) NOT NULL,
  `id_proveedor` int(11) NOT NULL,
  `id_producto` varchar(32) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `producto_proveedor`
--

INSERT INTO `producto_proveedor` (`ID`, `usuario`, `id_proveedor`, `id_producto`) VALUES
(4, 1, 1, '12'),
(5, 1, 1, 'PG105-5A'),
(3, 1, 1, 'PG143-14');

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
(1, 1, 'Casa matriz hogar', '44204200-4', '987433198', 'jsstoniha@gmail.com', 'as'),
(2, 1, 'Zapatillas top', '8001578-4', '951893723', 'zapatostop.cl@gmail.com', 'Quintero'),
(5, 1, 'Hotel', '44204200-4', '951893723', 'hotelf@franco.us', 'Hotel franco');

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
-- Volcado de datos para la tabla `ventas`
--

INSERT INTO `ventas` (`ID`, `usuario`, `sku`, `cantidad`, `tipo`, `opcion`, `precio`, `valor`, `pago`, `efectivo`, `vuelto`, `rebank`, `cliente`, `entrega`, `documento`, `code`, `enviado`, `fecha`) VALUES
(1, 1, 'PG105-5A', 1, 'Talla', 37, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '647622190737', 1, '2021-05-19'),
(2, 1, 'PG143-13', 1, 'Talla', 39, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '201789342213', 1, '2021-05-19'),
(3, 1, 'PG143-13', 1, 'Talla', 36, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '897762646011', 1, '2021-05-19'),
(4, 1, 'PG143-13', 1, 'Talla', 35, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '495321990695', 1, '2021-05-19'),
(5, 1, 'PG143-13', 1, 'Talla', 34, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '607813005337', 1, '2021-05-19'),
(6, 1, 'PG143-13', 1, 'Talla', 36, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '947371197160', 1, '2021-05-19'),
(7, 1, 'PG105-5A', 1, 'Talla', 37, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '615858833684', 1, '2021-05-19'),
(8, 1, 'PG105-5A', 1, 'Talla', 35, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '262757277092', 1, '2021-05-19'),
(9, 1, 'PG143-13', 1, 'Talla', 34, 15000, 6500, 6, 0, -15000, '45893746', 1, 2, 1, '868431697211', 0, '2021-05-29'),
(10, 1, 'ZT01', 1, 'Talla', 43, 15000, 6500, 6, 0, -15000, '2589336997', 13, 2, 1, '319306898604', 0, '2021-06-30'),
(11, 1, 'PG143-13', 1, 'Talla', 35, 15000, 6500, 2, 0, -15000, '0', 0, 1, 1, '173629365837', 1, '2021-07-05');

--
-- Índices para tablas volcadas
--

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
-- Indices de la tabla `entradas`
--
ALTER TABLE `entradas`
  ADD PRIMARY KEY (`ID`) USING BTREE,
  ADD UNIQUE KEY `sku` (`sku`,`usuario`) USING BTREE;

--
-- Indices de la tabla `envios`
--
ALTER TABLE `envios`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `gastos`
--
ALTER TABLE `gastos`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `invitado`
--
ALTER TABLE `invitado`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `opciones_envio`
--
ALTER TABLE `opciones_envio`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `paginas`
--
ALTER TABLE `paginas`
  ADD PRIMARY KEY (`ID`);

--
-- Indices de la tabla `productos`
--
ALTER TABLE `productos`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `productos` (`usuario`,`sku`) USING BTREE;

--
-- Indices de la tabla `producto_proveedor`
--
ALTER TABLE `producto_proveedor`
  ADD PRIMARY KEY (`ID`),
  ADD UNIQUE KEY `lista` (`usuario`,`id_proveedor`,`id_producto`);

--
-- Indices de la tabla `proveedores`
--
ALTER TABLE `proveedores`
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
-- AUTO_INCREMENT de la tabla `categorias`
--
ALTER TABLE `categorias`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `clientes`
--
ALTER TABLE `clientes`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT de la tabla `entradas`
--
ALTER TABLE `entradas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=69;

--
-- AUTO_INCREMENT de la tabla `envios`
--
ALTER TABLE `envios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `gastos`
--
ALTER TABLE `gastos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de la tabla `invitado`
--
ALTER TABLE `invitado`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `opciones_envio`
--
ALTER TABLE `opciones_envio`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `paginas`
--
ALTER TABLE `paginas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `productos`
--
ALTER TABLE `productos`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT de la tabla `producto_proveedor`
--
ALTER TABLE `producto_proveedor`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `proveedores`
--
ALTER TABLE `proveedores`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `ventas`
--
ALTER TABLE `ventas`
  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
