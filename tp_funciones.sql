create database tp_funciones;
use tp_funciones;
-- Crear una función que calcule el doble de un número.
delimiter //
	create function doble_de_numero(n int)
	returns int
    deterministic
	begin 
		return n*2;
    end //
delimiter ;

select doble_de_numero(5);

-- Función que calcule el cuadrado de un número.
delimiter //
	create function cuadrado_de_numero(n int) 
    returns int 
    deterministic
	begin 
		return n*n;
    end //
delimiter ; 

select cuadrado_de_numero(5);

-- Función que retorne "Mayor" o "Menor" según si el número ingresado es mayor o menor a 18.
delimiter //
	create function mayor_menor(n int)
    returns varchar(5)
    deterministic
    begin
		if n<18 then return 'menor';
        else return 'mayor';
        end if;
    end //
delimiter ;

select mayor_menor(18);

-- Función que retorne el largo de un texto recibido.
delimiter //
	create function largo_de_texto(texto varchar(1000))
    returns int
    deterministic
    begin
		return char_length(texto);
    end //
delimiter ;

select largo_de_texto('Los muchachos peronistas todos unidos triunfaremos');


-- Función que reciba un nombre y lo devuelva en mayúsculas

delimiter //
	create function nombre_to_upper(nombre varchar(50))
	returns varchar(50)
	deterministic
	begin
		return upper(nombre);
	end //
delimiter ;

select nombre_to_upper('El_Porongon');

-- Función que retorne el IVA (21%) de un precio

delimiter //
	create function iva_de_precio(precio decimal(10,2))
    returns decimal(10,2)
    deterministic
    begin
		return precio*0.21;
    end //
delimiter ;

select iva_de_precio(200);

CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100),
    precio_unitario DECIMAL(10, 2),
    stock INT
);

-- Crear tabla de clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    email VARCHAR(100)
);

-- Crear tabla de ventas
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
('Cerveza Rubia', 200.00, 50),
('Cerveza Negra', 220.00, 30),
('Cerveza Roja', 210.00, 25),
('IPA Artesanal', 250.00, 15);

-- Insertar clientes
INSERT INTO clientes (nombre_cliente, email) VALUES
('Juan Pérez', 'juanperez@gmail.com'),
('María López', 'marialopez@yahoo.com'),
('Carlos Díaz', 'cdiaz@hotmail.com');

-- Insertar ventas
INSERT INTO ventas (id_cliente, id_producto, cantidad, fecha_venta) VALUES
(1, 1, 5, '2024-04-01'),
(1, 3, 2, '2024-04-05'),
(2, 2, 6, '2024-04-03'),
(3, 4, 3, '2024-04-07'),
(2, 1, 1, '2024-04-10'),
(1, 4, 2, '2024-04-11');


-- Función que reciba un número de producto y devuelva su stock actual desde una tabla 
delimiter //
	create function product_stock(id_product int)
    returns int
    reads sql data
    not deterministic
    begin
		declare stock int;
        select p.stock into stock from productos p where p.id_producto=id_product;
		return stock;
    end //
delimiter ;

select product_stock(1);


-- Función que reciba un ID de cliente y devuelva el total de sus compras (usando una tabla ventas).
delimiter //
	create function total_compras_cliente(id_cliente int)
    returns decimal(10,2)
    reads sql data
    not deterministic
    begin
		declare total decimal(10,2);
        select sum(v.cantidad*p.precio_unitario) into total 
        from ventas v
        join productos p on p.id_producto=v.id_producto
        where v.id_cliente=id_cliente;
        return total;
    end //
delimiter ;

drop function total_compras_cliente;

select total_compras_cliente(2);

-- Función que devuelva el promedio de ventas mensuales de un producto

delimiter //
	create function prom_ventas_por_mes(mes date, id_producto_param int)
    returns decimal(10,2)
    reads sql data
    not deterministic
    begin
		declare prom decimal(10,2);
        select avg(v.cantidad) into prom from ventas v
        where v.id_producto=id_producto_param and
		month(v.fecha_venta)=month(mes);
        return prom;
    end //
delimiter ;
drop function prom_ventas_por_mes;
select prom_ventas_por_mes('2024-04-11', 1);


-- Función que reciba un nombre de producto y devuelva su precio, o -1 si no existe
delimiter //
	create function precio_producto(nombre_producto_p varchar(100))
    returns decimal(10,2)
    reads sql data
    not deterministic
    begin
		declare precio decimal(10,2);
        select p.precio_unitario into precio from productos p where p.nombre_producto like(nombre_producto_p);
		return ifnull(precio,-1);
    end //
delimiter ;

select precio_producto('Cerveza Negra');