create database practica_handlers;
use practica_handlers;

CREATE TABLE productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  stock INT NOT NULL
);

INSERT INTO productos (nombre, stock) VALUES
('Cerveza', 10),
('Vino', 5),
('Fernet', 0);

-- crear un procedimiento que inserte un producto nuevo.
-- Si ocurre un error (por ejemplo, nombre nulo), mostrar un mensaje.
-- Usa un EXIT HANDLER.

delimiter //
	create procedure insert_product(in nombre varchar(100), in stock int )
		begin 
			declare exit handler for sqlexception 
				begin
					select concat('Error valor invalido: ', @error_msj) mensaje_error;
				end ;
                if trim(nombre)='' then 
                set @error_msj='El nombre no puede estar vacio';
                signal sqlstate '45000' set message_text = @error_msj; 
                end if;
                if stock <=0 then 
                set @error_msj='El stock debe ser un natural';
                signal sqlstate '45000' set message_text=@error_msj;
                end if;
                insert into productos(nombre,stock) values(nombre,stock);
        end //
delimiter ;
drop procedure insert_product;
select * from productos;
delete from productos where id=8;
call insert_product('Gin', 1);

-- Crear un procedimiento que intente reducir el stock de un producto.
-- Si no hay suficiente stock, lanzar un error con SIGNAL SQLSTATE.

delimiter //
	create procedure reduce_stock(in id_product int)
    begin
		declare current_stock int;
		declare continue handler for sqlexception 
        begin
			select concat('Stock: ', @stock_msj) sotck_msj;
        end ;
        select stock into current_stock from productos where id=id_product;
	  if current_stock = 0 then
		set @stock_msj='Ya no hay stock';
        signal sqlstate '45000' set message_text = @stock_msj ;
		else update productos set stock = stock - 1 where id = id_product;
			if current_stock = 1 then select 'Ya no habrá más stock' stock_msj;
				else select 'Stock reducido exitosamente' stock_msj;
			end if;
      end if;
    end //
delimiter ;
drop procedure reduce_stock;
select * from productos;
call reduce_stock(1);