CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    descripcion varchar(80) NOT NULL,
    inventario int4 NOT NULL,
    foto BYTEA,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

insert into productos
	(descripcion, inventario, foto)
values
	('Lapiz', 100, public.leer_binario('/var/lib/postgresql/files/lapiz.png'));

insert into productos
	(descripcion, inventario, foto)
values
	('Folios', 50, public.leer_binario('/var/lib/postgresql/files/folio.png'));

select *
	from	 productos;

insert into productos
	(descripcion, inventario, foto)
values
	('Sacapuntas', 20, null);

insert into productos
	(descripcion, inventario, foto)
values
	('Borrador', 25, E'\\x');

SELECT * FROM productos WHERE foto IS NULL;

SELECT * FROM productos WHERE length(foto) = 0;

delete
	from	productos
	where	id = 1;