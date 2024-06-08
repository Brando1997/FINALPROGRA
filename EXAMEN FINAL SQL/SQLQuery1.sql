create database DBTeam
go

use DBTeam
go

Create table productos
(
codigo varchar(5),
nombre varchar(50),
precio int,
existencia int,
);
go

create proc sp_listar_productos
as
select * from productos order by codigo
go

create proc sp_buscar_producto
@nombre varchar(50)
as
select codigo,nombre,precio,existencia from productos where nombre like @nombre + '%'
go

create proc sp_mantenimiento_productos
@codigo varchar(5),
@nombre varchar(50),
@precio int,
@existencia int,
@accion varchar (50) output
as
if (@accion= '1')
begin
	declare @codnuevo varchar(5), @codmax varchar(5)
	set @codmax = (select max(codigo) from productos)
	set @codmax = isnull(@codmax, 'A0000')
	set @codnuevo = 'A'+RIGHT(RIGHT(@codmax,4)+10001,4)
	insert into productos(codigo,nombre,precio,existencia)
	values(@codnuevo,@nombre,@precio,@existencia)
	set @accion='Se genero el codigo:  ' +@codnuevo 
	end
	else if (@accion='2')
	begin
		update productos set nombre=@nombre, precio=@precio, existencia=@existencia where codigo=@codigo
		set @accion='Se modifico el codigo: ' +@codigo
		end
		else if (@accion='3')
		begin
			delete from productos where codigo=@codigo
			set @accion='Se borro el codigo: ' +@codigo
		end
		go


