CREATE OR REPLACE FUNCTION public.leer_binario(ruta_archivo text)
 RETURNS BYTEA
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

begin

	return pg_read_binary_file(ruta_archivo);	

end;
$function$
;


SELECT loid, pageno, data FROM pg_largeobject;


CREATE OR REPLACE FUNCTION public.exportar_binario(oid_binario OID, ruta_fichero TEXT)
 RETURNS void
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$

begin

	PERFORM lo_export(oid_binario, ruta_fichero);	

end;
$function$
;


-- Manejo de extensiones
SELECT * FROM pg_available_extension_versions WHERE name = 'lo';

CREATE EXTENSION lo WITH SCHEMA comercio;
DROP EXTENSION lo CASCADE;

SELECT extname, extnamespace::regnamespace AS esquema
	FROM pg_extension;
