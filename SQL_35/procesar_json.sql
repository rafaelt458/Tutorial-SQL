do $body$

declare
	factura jsonb;
	numfactura varchar(20);
	codcliente integer;
	linea jsonb;
	codproducto integer;
	cantidad integer;

begin

	select public.leer_archivo('/var/lib/postgresql/files/factura.json')
		into factura;

	RAISE NOTICE 'Se ha leido el JSON: %', factura;

	numfactura := factura ->> 'numeroFactura';
	codcliente := factura ->> 'idCliente';
	RAISE NOTICE 'Factura: %. Código cliente: %', numfactura, codcliente;

	for linea in (
		select *
			from	jsonb_array_elements(factura -> 'lineasFactura')
	)
	loop
		codproducto := linea ->> 'idProducto';
		cantidad := linea ->> 'Cantidad';
		RAISE NOTICE 'Código del producto: %. Cantidad: %', codproducto, cantidad;
	end loop;
	
	
end;
$body$;