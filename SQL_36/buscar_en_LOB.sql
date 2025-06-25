DO $$
DECLARE
    rec RECORD;
    fd INTEGER;
    buf BYTEA;
    chunk_size INTEGER := 32768; -- 32 KB
    contenido TEXT := '';
    encontrado BOOLEAN;
    subcadena TEXT := 'F0026';

BEGIN
    FOR rec IN SELECT id, oid_json, fecha_creacion FROM facturas_backup LOOP
        contenido := '';
        encontrado := FALSE;

        fd := lo_open(rec.oid_json, 262144); -- 262144 = INV_READ
        LOOP
            buf := loread(fd, chunk_size);
            EXIT WHEN length(buf) = 0;

			IF contenido != '' THEN
				SELECT RIGHT(contenido, LENGTH(subcadena)) into contenido;
			END IF;
            -- Concatena y convierte a texto (suponiendo UTF-8)
            contenido := contenido || convert_from(buf, 'UTF8');

            -- Si ya encontramos la subcadena, podemos salir
            IF position(subcadena IN contenido) > 0 THEN
                encontrado := TRUE;
                EXIT;
            END IF;
        END LOOP;

        PERFORM lo_close(fd);

        IF encontrado THEN
            RAISE NOTICE 'Subcadena encontrada en el registro con id % y fecha creación %s', rec.id, rec.fecha_creacion;
        END IF;
    END LOOP;
END;
$$ LANGUAGE plpgsql;
