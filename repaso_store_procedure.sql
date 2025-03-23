create database repaso_store_procedure;
use repaso_store_procedure;

create table empleados(
	id int primary key,
    nombre varchar(50),
    salario decimal(10,2)
);

insert into empleados values (1, 'Juan Perez', 3500);
insert into empleados values (2, 'Ana Gomez', 4200);
insert into empleados values (3, 'Carloz Ruiz', 5000);

-- Crea un procedimiento almacenado llamado ObtenerSalario que reciba como parámetro de entrada un ID de empleado y devuelva su salario.
delimiter //
 create procedure obtener_salario(in id int, out salarioX decimal(10,2))
  begin
		select salario into salarioX from empleados where empleados.id=id;
  end //
delimiter ;

call obtener_salario(2,@salario);
select @salario;

-- Crea un procedimiento llamado CalcularDescuento que reciba un precio y devuelva el precio con un descuento del 10% en un parámetro de salida.
delimiter //
	create procedure precio_con_descuento(in precio int, out precio_final decimal(10,2), in descuento int)
		begin
			set precio_final=precio-(precio*(descuento/100));
        end //
delimiter ;
-- drop procedure precio_con_descuento;
call precio_con_descuento(500,@precio_final, 10);
select @precio_final;

-- Crea un procedimiento llamado DuplicarNumero que reciba un número como parámetro INOUT y lo duplique.

delimiter //
	create procedure duplicar_numero(inout num int)
		begin 
			set num = num*2;
        end //
delimiter ;

set @num=5;
call duplicar_numero(@num);
select @num;

-- Crea un procedimiento llamado VerificarEdad que reciba una edad y
-- devuelva en un parámetro de salida si la persona es "Menor de edad" (menos de 18 años) o "Mayor de edad" (18 o más).
delimiter //
	create procedure verificar_edad(in edad int, out msg varchar(30))
		begin
			if edad>=18 then set msg='Mayor de edad';
            else set msg='Menor de edad';
            end if ;
        end //
delimiter ;

call verificar_edad(18,@msg);
select @msg;


-- Crea un procedimiento llamado SumarHastaN que reciba un número n 
-- y devuelva en un parámetro de salida la suma de todos los números desde 1 hasta n.

delimiter //
	create procedure sumar_hasta_n(in n int, out sum int)
		begin
			declare i int default 0;
            set sum=0;
            while i<n do
                set sum=sum+i;
                set i=i+1;
			end while;
        end //
delimiter ;
 -- drop procedure sumar_hasta_n;
call sumar_hasta_n(5,@sum);
select @sum;