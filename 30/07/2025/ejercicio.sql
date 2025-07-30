-- Actividad

-- Ejercicio #1: 
-- Crea un usuario llamado 'modificador' que pueda insertar y actualizar datos en la tabla `city`, 
-- pero no pueda eliminarlos. Además debe conectarse desde la IP '192.168.1.50'.

create user 'modificador'@'192.168.1.50' IDENTIFIED BY 'Advanced2023.';
grant insert , update on world.city to 'modificador'@'192.168.1.50';
show grants for 'modificador'@'192.168.1.50';


-- Ejercicio #2: 
-- Crea un procedimiento almacenado que reciba como parámetro el código de un país.
-- Dentro del procedimiento, crea un usuario temporal llamado 'temp_user' con una contraseña aleatoria.
-- Otorga al usuario 'temp_user' permiso para seleccionar (solo las columnas `Name` y `Population`) de la tabla `city` 
-- para las ciudades que pertenezcan al país recibido como parámetro.
-- El procedimiento debe devolver el nombre de usuario y la contraseña generada.

drop procedure if exists crear_usuario_temporal;

delimiter $$
create procedure crear_usuario_temporal(in codigo_pais char(3))
begin
    declare contrasena varchar(32);
    declare consulta_sql text;
    declare permisos_sql text;

    set contrasena = 'TempUser123!';

    set @drop_user = concat('drop user if exists \'temp_user\'@\'localhost\'');
    prepare stmt from @drop_user;
    execute stmt;
    deallocate prepare stmt;

    set @crear_usuario = concat('create user \'temp_user\'@\'localhost\' identified by \'', contrasena, '\'');
    prepare stmt from @crear_usuario;
    execute stmt;
    deallocate prepare stmt;

    set @vista_nombre = concat('temp_city_', codigo_pais);
    set @crear_vista = concat('create or replace view ', @vista_nombre, ' as
        select name, population from city where countrycode = \'', codigo_pais, '\'');
    prepare stmt from @crear_vista;
    execute stmt;
    deallocate prepare stmt;

    set @permisos = concat('grant select on ', @vista_nombre, ' to \'temp_user\'@\'localhost\'');
    prepare stmt from @permisos;
    execute stmt;
    deallocate prepare stmt;

    select 'temp_user' as usuario, contrasena as contrasena_generada;
end $$
delimiter ;

call crear_usuario_temporal('COL');


-- Ejercicio #3:
-- crea una función que devuelva el código de un país al azar.
delimiter $$
create function obtener_codigo_pais_azar()
returns char(3)
deterministic
reads sql data
begin
    declare codigo char(3);
    select code into codigo
    from country
    order by rand()
    limit 1;
    return codigo;
end $$
delimiter ;

select obtener_codigo_pais_azar();