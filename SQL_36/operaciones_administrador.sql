CREATE OR REPLACE FUNCTION public.importar_archivo(ruta_archivo text)
 RETURNS OID
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

declare
	archivo_oid OID;

begin

	archivo_oid := lo_import(ruta_archivo);
	EXECUTE format('ALTER LARGE OBJECT %s OWNER TO comercio', archivo_oid);
	return archivo_oid;	
	
	EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Error % importando el fichero : %', SQLERRM, ruta_archivo;
		return null;

end;
$function$ 
;

grant execute on function public.importar_archivo(text) to Comercio;


SELECT loid, pageno, data FROM pg_largeobject;

-- Función para eliminar el Large Object asociado al borrar una fila
CREATE OR REPLACE FUNCTION public.delete_factura_on_row_delete()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $$

BEGIN
    PERFORM lo_unlink(OLD.oid_json);
    RETURN OLD;
END;
$$
;

grant execute on function public.delete_factura_on_row_delete() to Comercio;