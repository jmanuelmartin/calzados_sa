USE calzados_sa;

-- Devolver el Nº más vendido por c/modelo de zapatos.

SELECT z.modelo, p.numero_zapato, SUM(p.cantidad) AS unidades
FROM Pertenece p
INNER JOIN Zapato z ON z.codigo = p.codigo_zapato
GROUP BY z.codigo, z.modelo, p.numero_zapato
HAVING SUM(p.cantidad) >= ALL (
    SELECT SUM(p2.cantidad)
    FROM Pertenece p2
    WHERE p2.codigo_zapato = z.codigo
    GROUP BY p2.numero_zapato
);

-- Listado de vendedores con sus ventas totales(monto total) durante 2025.

SELECT f.dni_vendedor, SUM(f.monto) as monto_total
FROM Factura f
WHERE f.fecha >= '2025-01-01' AND f.fecha < '2026-01-01'
GROUP BY f.dni_vendedor;

-- Apellido y nombre de los vendedores que no han tenido francos en enero de 2026.

SELECT p.apellido, p.nombre
FROM Persona p
INNER JOIN Vendedor v ON p.dni = v.dni
WHERE p.dni NOT IN (
	SELECT f.dni_vendedor
    FROM Franco f
    WHERE f.fecha >= '2026-01-01' AND f.fecha < '2026-02-01'
);

-- Listar los modelos y colores de zapatos que nunca han sido vendidos.

SELECT z.modelo, z.color
FROM Zapato z
WHERE z.codigo NOT IN (
    SELECT p.codigo_zapato
    FROM Pertenece p
);

-- Listar los proveedores que proveen más de un modelo de zapatos.

SELECT p.cuit, p.razon_social, COUNT(provee.cuit_proveedor) as modelos
FROM Proveedor p
INNER JOIN Provee provee ON p.cuit = provee.cuit_proveedor
GROUP BY p.cuit, p.razon_social
HAVING COUNT(provee.cuit_proveedor) > 1;

-- Listar el stock total por cada modelo de forma creciente.

SELECT z.codigo, z.modelo, SUM(t.cantidad) AS stock
FROM Zapato z
LEFT JOIN Tiene t ON z.codigo = t.codigo_zapato
GROUP BY z.codigo, z.modelo
ORDER BY stock ASC;
