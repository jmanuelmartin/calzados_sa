# (3382) Bases de Datos

## Universidad Nacional de Río Cuarto

### Proyecto: Calzados S.A.

Este repositorio cuenta con la resolución del proyecto integrador propuesto por la materia Bases de Datos de segundo año de la carrera Licenciatura en Ciencias de la Computación (UNRC).

#### 6. Consultas SQL

##### 6.a. Devolver el Nº más vendido por c/modelo de zapatos.

```sql
USE calzados_sa;

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
```
