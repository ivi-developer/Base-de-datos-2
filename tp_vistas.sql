create database practica_vistas;
use practica_vistas;

-- Tabla de clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(50),
    email VARCHAR(100)
);

-- Tabla de productos
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(50),
    precio_unitario DECIMAL(10,2)
);

-- Tabla de vendedores
CREATE TABLE vendedores (
    id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_vendedor VARCHAR(50)
);

-- Tabla de ventas
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    id_producto INT,
    id_vendedor INT,
    cantidad INT,
    fecha_venta DATE,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto),
    FOREIGN KEY (id_vendedor) REFERENCES vendedores(id_vendedor)
);
-- Clientes
INSERT INTO clientes (nombre_cliente, email) VALUES
('Ana López', 'ana@email.com'),
('Juan Pérez', 'juan@email.com'),
('Carla Gómez', 'carla@email.com'),
('Luis Torres', 'luis@email.com');

-- Productos
INSERT INTO productos (nombre_producto, precio_unitario) VALUES
('Auriculares', 5000),
('Mouse', 3000),
('Teclado', 4500),
('Monitor', 25000),
('Notebook', 150000);

-- Vendedores
INSERT INTO vendedores (nombre_vendedor) VALUES
('Mario Gutierrez'),
('Sofía Vega'),
('Natalia Ríos');

-- Ventas
INSERT INTO ventas (id_cliente, id_producto, id_vendedor, cantidad, fecha_venta) VALUES
(1, 1, 1, 2, '2023-07-31'),
(2, 3, 1, 1, '2024-07-04'),
(3, 4, 2, 1, '2023-11-27'),
(1, 5, 3, 1, '2024-06-11'),
(4, 2, 1, 3, '2023-10-14'),
(3, 1, 2, 2, '2024-01-22'),
(2, 2, 3, 1, '2024-03-03'),
(1, 3, 2, 2, '2023-09-09'),
(4, 5, 3, 1, '2024-04-27'),
(2, 4, 2, 1, '2023-06-17');

-- crea una vista que muestre solo el nombre y precio de una tabla de productos.

create view product_names_n_price as
 select p.nombre_producto as product_name , p.precio_unitario as product_price from productos p;
 
 drop view product_names_n_price;
 
 select * from product_names_n_price;
 
 -- Crea una vista que muestre los empleados que pertenecen al departamento de “Ventas”.
 create view sales_employes as
  select distinct v.nombre_vendedor salesman
  from vendedores v
  join ventas on v.id_vendedor=ventas.id_vendedor;
  
drop view sales_employes;
  
select * from sales_employes;

-- Crea una vista que una las tablas ventas, productos y vendedores para mostrar: nombre del vendedor, producto vendido y cantidad.

create view sale as
 select v.nombre_vendedor salesman_name, p.nombre_producto product_name, ventas.cantidad how_many
 from vendedores v
 join ventas on ventas.id_vendedor = v.id_vendedor
 join productos p on ventas.id_producto=p.id_producto;
 
select * from sale;

-- Crea una vista que muestre la cantidad total de productos vendidos por cada vendedor.

create view salesman_sales as
 select v.nombre_vendedor salesman_name, sum(ventas.cantidad) as how_many
 from vendedores v
 join ventas on ventas.id_vendedor=v.id_vendedor
 group by salesman_name;
 
 select * from salesman_sales;
 
 -- Crea una vista que incluya solo los productos cuyo precio esté por encima del promedio.
 
 create view products_above_avg as
  select p.nombre_producto product_name
  from productos p
  where p.precio_unitario > (select avg(p.precio_unitario)from productos p);
  
select * from products_above_avg;  
  
  create view products_under_avg as
  select p.nombre_producto product_name
  from productos p
  where p.precio_unitario < (select avg(p.precio_unitario)from productos p);
 
 select * from products_under_avg;
 
 
 