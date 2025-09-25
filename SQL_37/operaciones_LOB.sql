CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    descripcion varchar(80) NOT NULL,
    inventario int4 NOT NULL,
    foto OID,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


-- Insertar un elemento
do $$
DECLARE
    image_oid OID;
    file_fd INTEGER;
	path_archivo TEXT := '/var/lib/postgresql/files/lapiz.png';

BEGIN
    -- Abre el archivo como archivo binario desde el sistema de archivos del servidor
    image_oid := public.importar_archivo(path_archivo);

    -- Almacena la referencia en la tabla
	insert into productos
		(descripcion, inventario, foto)
	values
		('Lapiz', 100, image_oid);

	RAISE NOTICE 'Large Object con OID % y datos de "%" insertado exitosamente.', image_oid, path_archivo;

	EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al procesar el Large Object: %', SQLERRM;
        -- Si hay un error y el LOB fue creado, borrarlo:
		 IF image_oid IS NOT NULL THEN
	        PERFORM lo_unlink(image_oid);
			RAISE NOTICE 'Large Object con OID % ha sido eliminado por manejo de error.', image_oid;
		END IF;

END;
$$
LANGUAGE plpgsql;


-- Extraer el contenido binario a un fichero
DO $$
DECLARE
    v_oid OID;
BEGIN
    SELECT foto INTO v_oid FROM productos WHERE id = 1;

    PERFORM public.exportar_binario(v_oid, '/var/lib/postgresql/files/imagen_exportada.png');
    
    RAISE NOTICE 'Imagen exportada con OID %', v_oid;
END;
$$;


-- Creación de triger con el manejo del campo Large Object
CREATE TRIGGER trg_productos_foto_lo_manage
BEFORE UPDATE OR DELETE ON productos
FOR EACH ROW
EXECUTE FUNCTION comercio.lo_manage(foto);


delete
	from productos
	where	id = 1;