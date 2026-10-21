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

	CONSTRAINT PKTiene PRIMARY KEY (codigo_zapato, numero_zapato),
	CONSTRAINT FKCodigoZapato_Tiene FOREIGN KEY (codigo_zapato) REFERENCES Zapato(codigo)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
	CONSTRAINT FKNumeroZapato_Tiene FOREIGN KEY (numero_zapato) REFERENCES Numero(numero)
	ON DELETE RESTRICT
	ON UPDATE CASCADE
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

	CONSTRAINT PKPCelular PRIMARY KEY (cuit, celular),
	CONSTRAINT FKCuit_PCelular FOREIGN KEY (cuit) REFERENCES Proveedor
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE Provee (
	codigo_zapato INT NOT NULL,
	cuit_proveedor VARCHAR(50) NOT NULL,

	CONSTRAINT PKProvee PRIMARY KEY (codigo_zapato, cuit_proveedor),
	CONSTRAINT FKCodigoZapato_Provee FOREIGN KEY (codigo_zapato) REFERENCES Zapato(codigo)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FKCuitProveedor_Provee FOREIGN KEY (cuit_proveedor) REFERENCES Proveedor(cuit)
	ON DELETE CASCADE
	ON UPDATE CASCADE
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
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE Cliente_Minorista (
	dni VARCHAR(50) PRIMARY KEY,
	fecha_nacimiento DATE,

	CONSTRAINT PKDni_ClienteMinorista FOREIGN KEY (dni) REFERENCES Cliente
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE Cliente_Mayorista (
	dni VARCHAR(50) PRIMARY KEY,
	descuento FLOAT,

	CONSTRAINT PKDni FOREIGN KEY (dni) REFERENCES Cliente
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT descuento_cero_CM CHECK (descuento >= 0.00),
	CONSTRAINT descuento_100_CM CHECK (descuento <= 100.00)
);

CREATE TABLE Vendedor (
	dni VARCHAR(50) PRIMARY KEY,
	numero INT AUTO_INCREMENT UNIQUE,

	CONSTRAINT PKDni_Vendedor FOREIGN KEY (dni) REFERENCES Persona
	ON DELETE CASCADE
	ON UPDATE CASCADE
);

CREATE TABLE Fecha (
	dia ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo') PRIMARY KEY
);

CREATE TABLE Trabaja (
	dni_vendedor VARCHAR(50),
	dia ENUM('lunes', 'martes', 'miercoles', 'jueves', 'viernes', 'sabado', 'domingo'),
	horario_entrada TIME,
	horario_salida TIME,

	CONSTRAINT PKTrabaja PRIMARY KEY (dni_vendedor, dia),
	CONSTRAINT FKDniVendedor_Trabaja FOREIGN KEY (dni_vendedor) REFERENCES Vendedor(dni)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	CONSTRAINT FKDia_Trabaja FOREIGN KEY (dia) REFERENCES Fecha(dia)
	ON DELETE SET NULL
	ON UPDATE RESTRICT
);

CREATE TABLE Franco (
	numero INT AUTO_INCREMENT PRIMARY KEY,
	fecha DATE,
	observaciones VARCHAR(150),
	dni_vendedor VARCHAR(50),

	CONSTRAINT FKDniVendedor_Franco FOREIGN KEY (dni_vendedor) REFERENCES Vendedor(dni)
	ON DELETE SET NULL
	ON UPDATE CASCADE
);

CREATE TABLE Factura (
	numero INT AUTO_INCREMENT PRIMARY KEY,
	fecha DATE,
	monto FLOAT NOT NULL,
	dni_cliente VARCHAR(50),
	dni_vendedor VARCHAR(50),
	descuento FLOAT,

	CONSTRAINT FKCliente_Factura FOREIGN KEY (dni_cliente) REFERENCES Cliente(dni)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
	CONSTRAINT FKDniVendedor_Factura FOREIGN KEY (dni_vendedor) REFERENCES Vendedor(dni)
	ON DELETE SET NULL
	ON UPDATE CASCADE,
	CONSTRAINT descuento_cero_factura CHECK (descuento >= 0.00),
	CONSTRAINT descuento_100_factura CHECK (descuento <= 100.00)
);

CREATE TABLE Pertenece (
	codigo_zapato INT NOT NULL,
	numero_zapato INT NOT NULL,
	numero_factura INT NOT NULL,
	cantidad INT,
	precio_venta FLOAT,

	CONSTRAINT PKPertenece PRIMARY KEY (codigo_zapato, numero_zapato, numero_factura),
	CONSTRAINT FKTiene_Pertenece FOREIGN KEY (codigo_zapato, numero_zapato) REFERENCES Tiene(codigo_zapato, numero_zapato)
	ON DELETE RESTRICT
	ON UPDATE CASCADE,
	CONSTRAINT FKNumeroFactura_Pertenece FOREIGN KEY (numero_factura) REFERENCES Factura(numero)
	ON DELETE CASCADE
	ON UPDATE CASCADE
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
