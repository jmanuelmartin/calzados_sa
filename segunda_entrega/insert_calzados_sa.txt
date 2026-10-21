USE calzados_sa;

INSERT INTO Zapato (modelo, color, precio)
VALUES
	('Zapatillas Running', 'Rojo', 45000.00),
	('Botas de Cuero', 'Marrón', 85000.00),
	('Zapatos de vestir', 'Negro', 72000.00),
	('Sandalias', 'Verde', 25000.00);

INSERT INTO Numero (numero)
VALUES
	(38),
	(39),
	(40),
	(41),
	(42);

INSERT INTO Tiene (codigo_zapato, numero_zapato, cantidad)
VALUES
	(1, 39, 15),
	(2, 40, 20),
	(1, 41, 10),
	(3, 42, 5),
	(4, 38, 30);

INSERT INTO Proveedor (cuit, razon_social, direccion, telefono_fijo) VALUES
('30-12345678-9', 'Tate Express', 'Mitre 67, Rio Cuarto', '011-4444-5555'),
('27-87654321-0', 'Rossetti Deportes', 'San Lorenzo 511, Rio Cuarto', '0351-432-1111');

INSERT INTO PCelular (cuit, celular) VALUES
('30-12345678-9', '11-5555-6666'),
('30-12345678-9', '11-5555-7777'),
('27-87654321-0', '351-111-2222');

INSERT INTO Provee (codigo_zapato, cuit_proveedor) VALUES
(1, '30-12345678-9'),
(2, '27-87654321-0'),
(3, '30-12345678-9');

INSERT INTO Persona (dni, nombre, apellido, direccion) VALUES
('47312442', 'Juan Cruz', 'Uva Britos', 'Paul Harris 323'),
('47892123', 'Gastón', 'López', 'Pasaje Lanín 893'),
('47911017', 'Juan Manuel', 'Martin', 'Pasaje Antonio Sáenz 2250'),
('47367123', 'Juan Sebástian', 'Leanza', 'José Biassi 951'),
('47611567', 'Tomás Ezequiel', 'Miranda Gottardi', 'Pasaje Caracas 951');

INSERT INTO Fecha (dia) VALUES
('lunes'), ('martes'), ('miercoles'), ('jueves'), ('viernes'), ('sabado'), ('domingo');

INSERT INTO Cliente (dni) VALUES
('47312442'),
('47892123'),
('47911017'),
('47367123'),
('47611567');

INSERT INTO Cliente_Minorista (dni, fecha_nacimiento) VALUES
('47312442', '1990-05-15'),
('47892123', '1985-10-22');

INSERT INTO Cliente_Mayorista (dni, descuento) VALUES
('47911017', 15);

INSERT INTO Vendedor (dni) VALUES
('47367123'),
('47611567');

INSERT INTO Trabaja (dni_vendedor, dia, horario_entrada, horario_salida) VALUES
('47367123', 'lunes', '08:00:00', '16:00:00'),
('47367123', 'martes', '08:00:00', '16:00:00'),
('47611567', 'miercoles', '10:00:00', '18:00:00');

INSERT INTO Franco (numero, fecha, observaciones, dni_vendedor) VALUES
(1, '2026-10-25', 'Descanso semanal normal', '47367123'),
(2, '2026-10-26', 'Franco compensatorio', '47611567');

INSERT INTO Factura (numero, fecha, monto, dni_cliente, dni_vendedor, descuento) VALUES
(1, '2026-10-20', 45000.50, '47312442', '47367123', 0),
(2, '2026-10-20', 144500.00, '47911017', '47611567', 15);

INSERT INTO Pertenece (codigo_zapato, numero_zapato, numero_factura, cantidad, precio_venta) VALUES
(1, 39, 1, 1, 45000.50),
(2, 40, 2, 2, 85000.00);
