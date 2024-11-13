create or replace function leer_archivo(ruta_archivo text)
returns text as $$

begin

	return pg_read_file(ruta_archivo);	

end;
$$ language plpgsql security definer;



grant execute on function leer_archivo(text) to Comercio;