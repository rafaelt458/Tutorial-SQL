CREATE TABLE facturas_backup (
    id SERIAL PRIMARY KEY,
    oid_json OID NOT NULL,
    fecha_creacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);


do $$
DECLARE
    json_oid OID;
    file_fd INTEGER;
	path_archivo TEXT := '/var/lib/postgresql/files/factura.json';

BEGIN
    -- Abre el archivo como archivo binario desde el sistema de archivos del servidor
    json_oid := public.importar_archivo(path_archivo);

    -- Almacena la referencia en la tabla
    INSERT INTO facturas_backup (oid_json)
    VALUES (json_oid);

	RAISE NOTICE 'Large Object con OID % y datos de "%" insertado exitosamente.', json_oid, path_archivo;

	EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Error al procesar el Large Object: %', SQLERRM;
        -- Si hay un error y el LOB fue creado, borrarlo:
		 IF json_oid IS NOT NULL THEN
	        PERFORM lo_unlink(json_oid);
			RAISE NOTICE 'Large Object con OID % ha sido eliminado por manejo de error.', json_oid;
		END IF;

END;
$$
LANGUAGE plpgsql;

-- Crear un trigger para borrar el LOB automáticamente al eliminar la fila
CREATE TRIGGER trg_delete_factura_on_row_delete
AFTER DELETE ON facturas_backup
FOR EACH ROW EXECUTE FUNCTION public.delete_factura_on_row_delete();

DELETE FROM facturas_backup WHERE id = 2;