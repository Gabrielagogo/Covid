push!(LOAD_PATH,"../src/")

using InfoZIP, HTTP, DataFrames, CSV, StringEncodings

"""
  unzip(path::String, dest::String=pwd())

Descomprime y guarda el archivo en el destino indicado, si no se proporciona un destino, se guarda en el directorio actual.

# Ejemplo
```
julia> unzip("datos.zip")
julia> unzip("datos.zip", pwd()*"/datos")
```
"""
function unzip(path::String, dest::String="")
  if dest == ""
    InfoZIP.unzip(path, pwd())
  else
    InfoZIP.unzip(path, dest)
  end
end


"""
  CSV_to_DataFrame(path_url::String, encoding::String="UTF-8")::DataFrame

Lee un archivo CSV con el _encoding_ indicado y regresa un DataFrame.

# Ejemplo
```
julia> df = DataFrameEncode("datos.csv")
julia> df_latin1 = DataFrameEncode("datos.csv", "LATIN1")
```

Los _encodings_ soportados dependen de la plataforma, obtén la lista de la siguiente manera.

```
julia> using StringEncodings
julia> encodings()

```
"""
function CSV_to_DataFrame(path::String, encoding::String="UTF-8")
  f = open(path, "r")
  s = StringDecoder(f, encoding, "UTF-8")
  data = DataFrame(CSV.File(s))
  close(s)
  close(f)
  return data
end


"""

  data_check(path_url::String, type::String="PATH", encoding::String="UTF-8")::DataFrame

Crea un DataFrame dado un archivo CSV o una liga al archivo.
Se pude especificar el _encoding_

# Ejemplo
```
julia> url = "http://www.conapo.gob.mx/work/models/OMI/Datos_Abiertos/DA_IAIM/IAIM_Municipio_2010.csv"
julia> first(data_check(url, "URL", "LATIN1"))
julia> first(data_check("prueba.csv"))
```
"""
function data_check(path_url::String, type::String="PATH", encoding::String="UTF-8")::DataFrame
  if type == "PATH"
    return CSV_to_DataFrame(path_url, encoding)
  elseif type == "URL"
    path = HTTP.download(path_url, pwd())
    return CSV_to_DataFrame(path, encoding)
  else
    error("'type' debe de ser 'PATH' o 'URL'")
  end
end
