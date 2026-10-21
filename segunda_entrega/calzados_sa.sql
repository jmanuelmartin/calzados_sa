CREATE DATABASE calzados_sa;
USE calzados_sa;

CREATE TABLE Zapato (
	codigo INT AUTO_INCREMENT PRIMARY KEY,
	modelo VARCHAR(50) NOT NULL,
	color VARCHAR(50) NOT NULL,
	precio FLOAT,

	CONSTRAINT precio_positivo_zapato CHECK (precio > 0),
	CONSTRAINT resticcion_precio_zapato CHECK (precio < 200000.00)
);

CREATE TABLE Numero (
	numero INT PRIMARY KEY
);

CREATE TABLE Tiene (
	codigo_zapato INT NOT NULL,
	numero_zapato INT NOT NULL,
	cantidad INT,

	PRIMARY KEY (codigo_zapato, numero_zapato),
	CONSTRAINT FKCodigoZapato_Tiene FOREIGN KEY (codigo_zapato) REFERENCES Zapato(codigo),
	CONSTRAINT FKNumeroZapato_Tiene FOREIGN KEY (numero_zapato) REFERENCES Numero(numero)
);

CREATE TABLE Proveedor (
	cuit VARCHAR(50) PRIMARY KEY,
	razon_social VARCHAR(100),
	direccion VARCHAR(100),
	telefono_fijo VARCHAR(50)
);

CREATE TABLE PCelular (
	cuit VARCHAR(50),
	celular VARCHAR(50),

	PRIMARY KEY (cuit, celular),
	CONSTRAINT FKCuit_PCelular FOREIGN KEY (cuit) REFERENCES Proveedor
);

CREATE TABLE Provee (
	codigo_zapato INT NOT NULL,
	cuit_proveedor VARCHAR(50) NOT NULL,

	PRIMARY KEY (codigo_zapato, cuit_proveedor),
	CONSTRAINT FKCodigoZapato_Provee FOREIGN KEY (codigo_zapato) REFERENCES Zapato(codigo),
	CONSTRAINT FKCuitProveedor_Provee FOREIGN KEY (cuit_proveedor) REFERENCES Proveedor(cuit)
);

CREATE TABLE Persona (
	dni VARCHAR(50) PRIMARY KEY,
	nombre VARCHAR(100) NOT NULL,
	apellido VARCHAR(100) NOT NULL,
	direccion VARCHAR(100)
);


CREATE TABLE Cliente (
	dni VARCHAR(50) PRIMARY KEY,

	CONSTRAINT PKDni_Cliente FOREIGN KEY (dni) REFERENCES Persona
);

CREATE TABLE Cliente_Minorista (
	dni VARCHAR(50) PRIMARY KEY,
	fecha_nacimiento DATE,

	CONSTRAINT PKDni_ClienteMinorista FOREIGN KEY (dni) REFERENCES Cliente
);

CREATE TABLE Cliente_Mayorista (
	dni VARCHAR(50) PRIMARY KEY,
	descuento FLOAT,

	CONSTRAINT PKDni FOREIGN KEY (dni) REFERENCES Cliente,
	CONSTRAINT descuento_cero_CM CHECK (descuento >= 0.00),
	CONSTRAINT descuento_100_CM CHECK (descuento <= 100.00)
);

CREATE TABLE Vendedor (
	dni VARCHAR(50) PRIMARY KEY,
	numero INT AUTO_INCREMENT UNIQUE,

	CONSTRAINT PKDni_Vendedor FOREIGN KEY (dni) REFERENCES Persona
);

CREATE TABLE Fecha (
	dia ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo') PRIMARY KEY
);

CREATE TABLE Trabaja (
	dni_vendedor VARCHAR(50),
	dia ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo'),
	horario_entrada TIME,
	horario_salida TIME,

	PRIMARY KEY (dni_vendedor, dia),
	CONSTRAINT FKDniVendedor_Trabaja FOREIGN KEY (dni_vendedor) REFERENCES Vendedor(dni),
	CONSTRAINT FKDia_Trabaja FOREIGN KEY (dia) REFERENCES Fecha(dia)
);

CREATE TABLE Franco (
	numero INT AUTO_INCREMENT PRIMARY KEY,
	fecha DATE,
	observaciones VARCHAR(150),
	dni_vendedor VARCHAR(50),

	CONSTRAINT FKDniVendedor_Franco FOREIGN KEY (dni_vendedor) REFERENCES Vendedor(dni)
);

CREATE TABLE Factura (
	numero INT AUTO_INCREMENT PRIMARY KEY,
	fecha DATE,
	monto FLOAT NOT NULL,
	dni_cliente VARCHAR(50),
	dni_vendedor VARCHAR(50),
	descuento FLOAT,

	CONSTRAINT FKCliente_Factura FOREIGN KEY (dni_cliente) REFERENCES Cliente(dni),
	CONSTRAINT FKDniVendedor_Factura FOREIGN KEY (dni_vendedor) REFERENCES Vendedor(dni),
	CONSTRAINT descuento_cero_factura CHECK (descuento >= 0.00),
	CONSTRAINT descuento_100_factura CHECK (descuento <= 100.00)
);

CREATE TABLE Pertenece (
	codigo_zapato INT NOT NULL,
	numero_zapato INT NOT NULL,
	numero_factura INT NOT NULL,
	cantidad INT,
	precio_venta FLOAT,

	PRIMARY KEY (codigo_zapato, numero_zapato, numero_factura),
	CONSTRAINT FKTiene_Pertenece FOREIGN KEY (codigo_zapato, numero_zapato) REFERENCES Tiene(codigo_zapato, numero_zapato),
	CONSTRAINT FKNumeroFactura_Pertenece FOREIGN KEY (numero_factura) REFERENCES Factura(numero)
);

CREATE TABLE Auditoria (
	fecha DATETIME,
	codigo INT,
	precio_anterior FLOAT,
	precio_nuevo FLOAT,
	usuario VARCHAR(100)
);

DELIMITER $$
	CREATE TRIGGER trigger_auditoria_zapato
		AFTER UPDATE ON Zapato
		FOR EACH ROW
			BEGIN
				IF OLD.precio <> NEW.precio THEN
					INSERT INTO Auditoria VALUES (NOW(), OLD.codigo, OLD.precio, NEW.precio, CURRENT_USER());
				END IF;
			END;
$$
DELIMITER ;
