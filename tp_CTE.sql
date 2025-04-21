create database tp_cte;
use tp_cte;


CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    precio_unitario DECIMAL(10,2),
    stock INT
);

-- Tabla de clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100)
);

-- Tabla de ventas
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    cantidad INT,
    fecha_venta DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Insertar productos
INSERT INTO productos (nombre_producto, precio_unitario, stock) VALUES
('Laptop', 1200.00, 15),
('Mouse', 25.00, 50),
('Teclado', 45.00, 30),
('Monitor', 300.00, 10),
('Auriculares', 60.00, 5);

-- Insertar clientes
INSERT INTO clientes (nombre_cliente) VALUES
('Ana'),
('Carlos'),
('Lucía'),
('Pedro'),
('Marta');

-- Insertar ventas
INSERT INTO ventas (id_cliente, id_producto, cantidad, fecha_venta) VALUES
(1, 1, 1, '2024-04-01'),
(1, 2, 2, '2024-04-02'),
(2, 3, 3, '2024-04-03'),
(3, 1, 1, '2024-04-04'),
(4, 4, 1, '2024-04-05'),
(5, 5, 2, '2024-04-06'),
(1, 3, 1, '2024-04-07'),
(2, 2, 4, '2024-04-08'),
(3, 5, 1, '2024-04-09'),
(4, 1, 2, '2024-04-10'),
(5, 4, 1, '2024-04-11'),
(1, 2, 3, '2024-04-12');


-- Crear una CTE llamada productos_caros que obtenga los productos con precio mayor a 100.
-- Luego, seleccionar el nombre y precio desde esa CTE.


with productos_caros as(select * from productos p where p.precio_unitario>100)
select nombre_producto, precio_unitario from productos_caros;

-- Crear una CTE que calcule cuántas ventas hizo cada cliente.
-- Filtrar aquellos con más de 2 compras.

with cant_compras as(
	select c.nombre_cliente,count(*) as cant
    from ventas v
    join clientes c on v.id_cliente= c.id_cliente
    group by c.nombre_cliente
)select * from cant_compras where cant>2;

-- Crear una CTE que contenga los productos con stock menor a 20.
-- Mostrar el nombre y stock de esos productos.

with productos_con_poco_stock as(
	select * from productos p
    where p.stock<20
)select nombre_producto, stock from productos_con_poco_stock;

-- Crear una CTE que calcule la suma total de compras por cliente.
-- Luego mostrar los que gastaron más de $1200.

with total_de_compras as(
	select c.nombre_cliente, sum(p.precio_unitario*v.cantidad) total
    from clientes c
    join ventas v on v.id_cliente=c.id_cliente
    join productos p on p.id_producto=v.id_producto
    group by c.nombre_cliente
)select * from total_de_compras where total>1200;


-- Crear una CTE que sume la cantidad total vendida por producto.
-- Agregá una columna con el RANK() o DENSE_RANK() para ordenar por cantidad.

with cantidad_vendida_por_producto as(
	select p.nombre_producto, sum(cantidad) as cantidad
    from productos p
    join ventas v on v.id_producto=p.id_producto
    group by p.nombre_producto
)select nombre_producto, rank()over(order by cantidad desc) ranking from cantidad_vendida_por_producto;

-- Crear una CTE que calcule el promedio de unidades vendidas por producto.
-- Filtrar aquellos productos cuyo promedio sea mayor a 3

with promedio_ventas_producto as(
	select p.nombre_producto, avg(cantidad) prom
    from productos p
    join ventas v on p.id_producto=v.id_producto
    group by p.nombre_producto
)select * from promedio_ventas_producto where prom >3;

