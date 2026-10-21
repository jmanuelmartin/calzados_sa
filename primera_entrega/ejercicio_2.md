Zapato (**codigo**, modelo, color, precio)
Numero (**numero**)
Tiene (**codigo_zapato**, **numero_zapato**, cantidad) : codigo_zapato es clave foránea de codigo de Zapato y numero_zapato es clave foránea de numero de Numero
Proveedor (**cuit**, razon_social, direccion, telefono_fijo)
PCelular (**cuit**, celular)
Provee (**codigo_zapato**, **cuit_proveedor**) : codigo_zapato es clave foránea de codigo de Zapato y cuit_proveedor es clave foránea de cuit de Proveedor
Persona (**dni**, nombre, apellido, direccion)
Cliente (**dni**) : dni es clave foránea de Persona
Cliente_Minorista (**dni**, fecha_nacimiento) : dni es clave foránea de Cliente
Cliente_Mayorista (**dni**, descuento) : dni es clave foránea de Cliente
Vendedor (**dni**, numero) 
Fecha (**dia**)
Trabaja (**dni_vendedor**, **dia**, horario_entrada, horario_salida) : dni_vendedor es clave foránea de dni de Vendedor y dia es clave foránea de Fecha
Franco (**numero**, fecha, observaciones)
Tiene_Franco (**dni_vendedor**, **numero_franco**) : dni_vendedor es clave foránea de dni de Vendedor y numero_franco es clave foránea de numero de Franco
*Tiene_Franco es una modificación del nombre de la relación entre Vendedor y Franco, para evitar confusiones con otras relaciones tabuladas*
Factura (**numero**, fecha, monto, *dni_cliente*, *dni_vendedor*) : dni_cliente es clave foránea de dni de Cliente y dni_vendedor es clave foránea de dni de Vendedor
Pertenece (**codigo_zapato**, **numero_zapato**, **numero_factura**, cantidad, precio_venta) : codigo_zapato es clave foránea de codigo de Zapato, numero_zapato es clave foránea de numero de Numero y numero_factura es clave foránea de numero de Factura