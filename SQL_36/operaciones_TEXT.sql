CREATE TABLE facturas_backup (
    id SERIAL PRIMARY KEY,
    contenido_json TEXT NOT NULL,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO facturas_backup (contenido_json)
VALUES (public.leer_archivo('/var/lib/postgresql/files/factura.json'));


select	*
	from	facturas_backup
	where	contenido_json like '%F0026%';

delete
	from	facturas_backup
	where	id = 1;