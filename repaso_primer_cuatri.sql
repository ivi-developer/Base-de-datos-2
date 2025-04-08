-- Crear la tabla ventas
CREATE TABLE ventas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    producto VARCHAR(50),
    vendedor VARCHAR(50),
    cantidad INT,
    precio_unitario DECIMAL(10,2)
);

-- Insertar los datos
INSERT INTO ventas (producto, vendedor, cantidad, precio_unitario) VALUES
('Galletas', 'Ana', 5, 100),
('Pan', 'Juan', 10, 50),
('Galletas', 'Ana', 7, 100),
('Jugo', 'Pedro', 3, 200),
('Pan', 'Juan', 2, 50),
('Leche', 'Ana', 4, 150);

-- Mostrar todos los datos de la tabla.
select *from ventas;
-- Mostrar solo los nombres de los productos sin repetir.
select producto from ventas group by ventas.producto;
-- Mostrar todos los productos que vendió Ana.
select producto from ventas where vendedor like('Ana');
-- Contar cuántas ventas hizo cada vendedor (GROUP BY vendedor).
select vendedor,count(*)as cant_ventas from ventas group by vendedor;
-- Contar cuántas veces se vendió cada producto (GROUP BY producto).
select producto, count(*) cant_vendido from ventas group by producto;
-- Mostrar el vendedor que más ventas hizo (usando ORDER BY y LIMIT 1).
select vendedor, count(*)as cant_ventas from ventas group by vendedor order by cant_ventas desc limit 1;
-- Calcular el total de productos vendidos por cada vendedor (SUM(cantidad)).
select  sum(cantidad) from ventas;
-- Calcular el precio promedio de cada producto (AVG(precio_unitario)).
select avg(precio_unitario)from ventas;
-- Mostrar el producto más caro (MAX(precio_unitario)).
select  max(precio_unitario) from ventas;
-- Mostrar la cantidad mínima de unidades vendidas por producto (MIN(cantidad)).
select min(cantidad) from ventas;

-- con mas tablas

drop table ventas;

CREATE TABLE vendedores (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_vendedor VARCHAR(50)
);

-- Crear tabla de productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(50),
    precio_unitario DECIMAL(10,2)
);

-- Crear tabla de ventas
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_vendedor INT,
    id_producto INT,
    cantidad INT,
    fecha DATE,
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Insertar datos en vendedores
INSERT INTO vendedores (nombre_vendedor) VALUES 
('Ana'),
('Juan'),
('Pedro');

-- Insertar datos en productos
INSERT INTO productos (nombre_producto, precio_unitario) VALUES 
('Galletas', 100),
('Pan', 50),
('Jugo', 200),
('Leche', 150);

-- Insertar datos en ventas
INSERT INTO ventas (id_vendedor, id_producto, cantidad, fecha) VALUES
(1, 1, 5, '2025-04-01'), -- Ana vendió Galletas
(2, 2, 10, '2025-04-01'), -- Juan vendió Pan
(1, 1, 7, '2025-04-02'), -- Ana vendió Galletas
(3, 3, 3, '2025-04-02'), -- Pedro vendió Jugo
(2, 2, 2, '2025-04-03'), -- Juan vendió Pan
(1, 4, 4, '2025-04-03'); -- Ana vendió Leche

-- Listar cuántas ventas hizo cada vendedor
select nombre_vendedor, count(*) as cant_ventas
from vendedores
join ventas on ventas.id_vendedor=vendedores.id_vendedor
group by nombre_vendedor;

-- Mostrar cuánto vendió en total cada producto (cantidad de unidades)
select nombre_producto, sum(cantidad) as cant_vedido
from productos
join ventas on ventas.id_producto=productos.id_producto
group by nombre_producto;

-- Obtener el total de dinero recaudado por cada vendedor.
select nombre_vendedor, sum(cantidad*precio_unitario) as dinero_recaudado
from vendedores
join ventas on ventas.id_vendedor=vendedores.id_vendedor
join productos on productos.id_producto=ventas.id_producto
group by nombre_vendedor;

-- Listar el vendedor que más productos vendió.
select nombre_vendedor, sum(cantidad) as cant_productos_vendidos
from vendedores
join ventas on ventas.id_vendedor=vendedores.id_vendedor
group by nombre_vendedor;

-- Mostrar las ventas agrupadas por día (fecha)
select * from ventas
where day(ventas.fecha)='1';

-- Mostrar el promedio de unidades vendidas por venta
select avg(ventas.cantidad) as promedio_unidades_por_venta from ventas;

-- Listar para cada vendedor la cantidad de productos distintos que vendió
select nombre_vendedor, count(distinct ventas.id_producto) as cant_de_distintos_productos
from vendedores
join ventas on ventas.id_vendedor=vendedores.id_vendedor
join productos on productos.id_producto=ventas.id_producto
group by nombre_vendedor;

-- Listar la venta de mayor cantidad realizada (mostrar vendedor, producto y cantidad).

select nombre_vendedor, nombre_producto, cantidad
from vendedores
join ventas on ventas.id_vendedor=vendedores.id_vendedor
join productos on productos.id_producto=ventas.id_producto
group by nombre_vendedor, nombre_producto, cantidad
order by cantidad desc limit 1;