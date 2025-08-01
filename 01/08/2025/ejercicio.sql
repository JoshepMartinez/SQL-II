-- Ejercicio # 1: 
-- Crea un evento que aumente la superficie de los países en 5% cada año.

delimiter $$
create event actualizarSuperficie
ON schedule EVERY 1 second
on completion preserve

do
begin
	update world.country_temp set Surfacearea = Surfacearea * 1.05;
end$$
delimiter ;

show events;

select Surfacearea from world.country_temp;

select Surfacearea from world.country c;
select Surfacearea from world.country_temp ct;


-- Ejercicio # 2: 
-- Crea un evento que registre en una tabla la cantidad de países por continente cada mes.

drop table if exists world.registro_continentes;
create table world.registro_continentes (
    id int auto_increment primary key,
    fecha datetime,
    continente varchar(50),
    cantidad_paises int
);

drop event if exists registrar_paises_continente;

delimiter $$
create event registrar_paises_continente
on schedule every 1 second
starts current_timestamp
do
begin
    insert into world.registro_continentes (fecha, continente, cantidad_paises)
    select now(), continent, count(*)
    from world.country_temp
    group by continent;
end$$
delimiter ;

select *
from world.registro_continentes
order by fecha desc;

-- Ejercicio # 3 :
-- Programa un evento que guarde un registro de cambios de población cada semana.

drop event guardarPoblacionSemanal;

delimiter $$
create event guardarpoblacionsemanal
on schedule every 1 second
on completion preserve
do
begin
    update world.country_temp set population = population * 1.02;
end$$
delimiter ;


show events;

select population from world.country_temp;

select population from world.country c;
select population from world.country_temp ct;

-- ejercicio # 4 :
-- crea un evento que elimine países sin ciudades registradas cada 3 meses (simulado cada 3 segundos).
-- este evento debe dejar una traza de cuáles fueron los países eliminados en otra tabla.

drop table if exists world.paises_eliminados;
create table world.paises_eliminados (
    id int auto_increment primary key,
    fecha datetime,
    codigo_pais char(3),
    nombre_pais varchar(100)
);

drop event if exists eliminar_paises_sin_ciudades;

delimiter $$
create event eliminar_paises_sin_ciudades
on schedule every 3 second
starts current_timestamp
do
begin
    insert into world.paises_eliminados (fecha, codigo_pais, nombre_pais)
    select now(), c.code, c.name
    from world.country_temp c
    left join world.city ct on c.code = ct.countrycode
    where ct.id is null;

    delete c
    from world.country_temp c
    left join world.city ct on c.code = ct.countrycode
    where ct.id is null;
end$$
delimiter ;

select * 
from world.paises_eliminados
order by fecha desc;

select * 
from world.country_temp;

-- ejercicio # 5:
-- crear un evento que elimine y mueva a otra tabla todos los datos de los 
-- países que se independizaron hace más de 500 años. este evento ocurre cada viernes (simulado cada minuto).

drop table if exists world.paises_antiguos;
create table world.paises_antiguos as
select * from world.country_temp where 1=0;

drop event if exists mover_eliminar_paises_antiguos;

delimiter $$
create event mover_eliminar_paises_antiguos
on schedule every 1 minute
starts current_timestamp
comment 'se ejecuta cada viernes (simulado)'
do
begin
    insert into world.paises_antiguos
    select *
    from world.country_temp
    where year(current_date()) - indepyear > 500;

    delete from world.country_temp
    where year(current_date()) - indepyear > 500;
end$$
delimiter ;

select * 
from world.paises_antiguos
order by indepyear;

select * 
from world.country_temp;


show events;