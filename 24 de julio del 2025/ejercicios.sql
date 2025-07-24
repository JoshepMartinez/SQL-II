-- 1. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos
-- de la base de datos.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante;

-- 2. Devuelve una lista con el nombre del producto, precio y nombre de fabricante de todos los productos
-- de la base de datos. Ordene el resultado por el nombre del fabricante, por orden alfabético.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
order by fabricante asc;

-- 3. Devuelve una lista con el identificador del producto, nombre del producto, identificador del
-- fabricante y nombre del fabricante, de todos los productos de la base de datos.

select p.id, p.nombre, p.precio, f.id, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante;

-- 4. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más barato.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
order by p.precio asc
limit 1;

-- 5. Devuelve el nombre del producto, su precio y el nombre de su fabricante, del producto más caro.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
order by p.precio desc
limit 1;

-- 6. Devuelve una lista de todos los productos del fabricante Lenovo.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
where f.nombre = 'Lenovo';

-- 7. Devuelve una lista de todos los productos del fabricante Crucial que tengan un precio mayor que
-- 200€.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
where p.precio >= 200 and f.nombre = 'Crucial';

-- 8. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packardy Seagate. Sin
-- utilizar el operador IN.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
where f.nombre = 'Asus' or f.nombre = 'Hewlett-Packard' or f.nombre = 'Seagate';

-- 9. Devuelve un listado con todos los productos de los fabricantes Asus, Hewlett-Packardy Seagate.
-- Utilizando el operador IN.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
where f.nombre in ('Asus', 'Hewlett-Packard', 'Seagate');

-- 10. Devuelve un listado con el nombre y el precio de todos los productos de los fabricantes cuyo nombre
-- termine por la vocal e.

select p.nombre, p.precio, f.nombre as fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
where f.nombre like "%e";

-- 11.Devuelve un listado con los nombres de los fabricantes que tienen 2 o más productos.

SELECT f.nombre, p.nombre AS producto
FROM fabricante f
JOIN producto p ON f.id = p.id_fabricante
WHERE f.id IN (
  SELECT p1.id_fabricante
  FROM producto p1, producto p2
  WHERE p1.id_fabricante = p2.id_fabricante
    AND p1.id <> p2.id
);

-- 12.Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada
-- uno con un precio superior o igual a 220 €. No es necesario mostrar el nombre de los fabricantes
-- que no tienen productos que cumplan la condición.

select f.nombre as nombre_fabricante, count(p.id) total
from producto p
join fabricante f on f.id = p.id_fabricante
where p.precio >= 220
group by f.nombre;

-- 13.Devuelve un listado con los nombres de los fabricantes y el número de productos que tiene cada
-- uno con un precio superior o igual a 220 €. El listado debe mostrar el nombre de todos los
-- fabricantes, es decir, si hay algún fabricante que no tiene productos con un precio superior o igual
-- a 220€ deberá aparecer en el listado con un valor igual a 0 en el número de productos.

select f.nombre as nombre_fabricante, 
       count(case when p.precio >= 220 then 1 end) as total
from fabricante f
left join producto p on f.id = p.id_fabricante
group by f.nombre;

-- 14.Devuelve un listado con los nombres de los fabricantes donde la suma del precio de todos sus
-- productos es superior a 1000 €.

select f.nombre as nombre_fabricante, 
       sum(p.precio) as suma_precios
from fabricante f
join producto p on f.id = p.id_fabricante
group by f.nombre
having sum(p.precio) > 1000;

-- 15.Devuelve un listado con el nombre del producto más caro que tiene cada fabricante. El resultado
-- debe tener tres columnas: nombre del producto, precio y nombre del fabricante. El resultado tiene
-- que estar ordenado alfabéticamente de menor a mayor por el nombre del fabricante.

select p.nombre as nombre_producto, 
       p.precio, 
       f.nombre as nombre_fabricante
from producto p
join fabricante f on f.id = p.id_fabricante
where p.precio = (
    select max(p2.precio)
    from producto p2
    where p2.id_fabricante = p.id_fabricante
)
order by f.nombre;

-- 16.Devuelve el producto más caro que existe en la tabla producto sin hacer uso de MAX, ORDER
-- BY ni LIMIT.

select p.nombre, p.precio
from producto p
where not exists (
    select 1 from producto p2
    where p2.precio > p.precio
);

-- 17.Devuelve el producto más barato que existe en la tabla producto sin hacer uso de MIN, ORDER
-- BY ni LIMIT.

select p.nombre, p.precio
from producto p
where not exists (
    select 1 from producto p2
    where p2.precio < p.precio
);

-- 18.Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando ALL o ANY).

select f.nombre
from fabricante f
where f.id = any (
    select p.id_fabricante
    from producto p
);

-- 19.Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando ALL o ANY).

select f.nombre
from fabricante f
where f.id <> all (
    select p.id_fabricante
    from producto p
);

-- 20.Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).

select f.nombre
from fabricante f
where f.id in (
    select p.id_fabricante
    from producto p
);