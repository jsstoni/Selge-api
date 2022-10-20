<style>
body {
	font-family: Verdana,sans-serif;
}

table {
	text-align: left;
	border-collapse: collapse;
	border-spacing: 0;
	vertical-align: middle;
	width: 100%;
	margin: 10px 0;
}
table thead th {
	border-bottom: #000 solid 1px;
	border-top: #000 solid 1px;
}
table td, table th {
	text-align: left;
	padding: 10px;
}

.wrapper-page {
	page-break-after: always;
}

.wrapper-page:last-child {
	page-break-after: avoid;
}

.product img {
	width: 55px;
	height: 55px;
	display: inline-block;
	vertical-align: top;
	margin: 0 6px 0 0;
}
</style>
<?php foreach ($pedidos as $key => $value) { ?>
<div class="wrapper-page">
	<h1>N° Pedido: #<?php echo $key; ?></h1>

	<table>
		<thead>
			<tr>
				<th colspan="2">Datos cliente</th>
			</tr>
		</thead>
		<tr>
			<td><strong>Nombre:</strong> <?php echo $value[0]['nombre']; ?></td>
			<td><strong>Rut:</strong> <?php echo $value[0]['rut']; ?></td>
		</tr>
		<tr>
			<td><strong>Teléfono:</strong> <?php echo $value[0]['phone']; ?></td>
			<td><strong>Email:</strong> <?php echo $value[0]['email']; ?></td>
		</tr>
	</table>
	<table>
		<thead>
			<tr>
				<th>Producto</th>
				<th>SKU</th>
				<th>Precio</th>
				<th>Cantidad</th>
			</tr>
		</thead>
		<?php foreach ($value as $item) { ?>
		<tbody>
			<tr>
				<td class="product">
					<img src="<?php echo self::newMedia('upload', $item['image']); ?>" alt="<?php echo $item['image']; ?>">
					<?php echo $item['producto']; ?>
				</td>
				<td><?php echo $item['sku']; ?></td>
				<td><?php echo $item['precio']; ?></td>
				<td><?php echo $item['cantidad']; ?></td>
			</tr>
		</tbody>
		<?php } ?>
	</table>
</div>
<?php }