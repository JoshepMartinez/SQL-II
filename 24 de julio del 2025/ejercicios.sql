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

-- 1. Devuelve un listado que solamente muestre los clientes que no han realizado ningún pedido.

SELECT * 
FROM cliente 
WHERE id NOT IN (SELECT id_cliente FROM pedido);

-- 2. Devuelve un listado que solamente muestre los comerciales que no han realizado ningún pedido.

SELECT * 
FROM comercial 
WHERE id NOT IN (SELECT id_comercial FROM pedido);

-- 3. Devuelve un listado con los clientes que no han realizado ningún pedido y de los comerciales que
-- no han participado en ningún pedido. Ordene el listado alfabéticamente por los apellidos y el
-- nombre. En en listado deberá diferenciar de algún modo los clientes y los comerciales.

SELECT 'Cliente' AS tipo, nombre, apellido1, apellido2
FROM cliente 
WHERE id NOT IN (SELECT id_cliente FROM pedido)
UNION
SELECT 'Comercial' AS tipo, nombre, apellido1, apellido2
FROM comercial 
WHERE id NOT IN (SELECT id_comercial FROM pedido)
ORDER BY apellido1, apellido2, nombre;

-- 4. ¿Se podrían realizar las consultas anteriores con NATURAL LEFT JOIN o NATURAL RIGHT JOIN? Justifique
-- su respuesta.

-- Respuesta no se pondria realizar porque para utilizar el natural left join se necesita que en ambas tablas tengan el mismo nombre
-- o que tengan una relacion entre ellas por eso en los ejercicios anteriores no se podria usar el natural left join porque no cumple con 
-- las condiciones requeridas para usar el natural lef join las cuales son que deben que tener al menos una columna con el mismo nombre 
-- y tipo de datos compatible.

-- 5. Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada uno de
-- los clientes. Es decir, el mismo cliente puede haber realizado varios pedidos de diferentes
-- cantidades el mismo día. Se pide que se calcule cuál es el pedido de máximo valor para cada uno
-- de los días en los que un cliente ha realizado un pedido. Muestra el identificador del cliente,
-- nombre, apellidos, la fecha y el valor de la cantidad.

SELECT p.id_cliente, c.nombre, c.apellido1, c.apellido2, p.fecha, MAX(p.total) AS max_total
FROM pedido p
JOIN cliente c ON p.id_cliente = c.id
GROUP BY p.id_cliente, p.fecha;

-- 6. Calcula cuál es el máximo valor de los pedidos realizados durante el mismo día para cada uno de
-- los clientes, teniendo en cuenta que sólo queremos mostrar aquellos pedidos que superen la
-- cantidad de 2000 €.

SELECT p.id_cliente, c.nombre, c.apellido1, c.apellido2, p.fecha, MAX(p.total) AS max_total
FROM pedido p
JOIN cliente c ON p.id_cliente = c.id
WHERE p.total > 2000
GROUP BY p.id_cliente, p.fecha;

-- 7. Calcula el máximo valor de los pedidos realizados para cada uno de los comerciales durante la
-- fecha 2016-08-17. Muestra el identificador del comercial, nombre, apellidos y total.

SELECT p.id_comercial, cm.nombre, cm.apellido1, cm.apellido2, MAX(p.total) AS max_total
FROM pedido p
JOIN comercial cm ON p.id_comercial = cm.id
WHERE p.fecha = '2016-08-17'
GROUP BY p.id_comercial;

-- 8. Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de
-- pedidos que ha realizado cada uno de clientes. Tenga en cuenta que pueden existir clientes que
-- no han realizado ningún pedido. Estos clientes también deben aparecer en el listado indicando
-- que el número de pedidos realizados es 0.

SELECT c.id, c.nombre, c.apellido1, c.apellido2, COUNT(p.id) AS total_pedidos
FROM cliente c
LEFT JOIN pedido p ON c.id = p.id_cliente
GROUP BY c.id;

-- 9. Devuelve un listado con el identificador de cliente, nombre y apellidos y el número total de
-- pedidos que ha realizado cada uno de clientes durante el año 2017.

SELECT c.id, c.nombre, c.apellido1, c.apellido2, COUNT(p.id) AS total_2017
FROM cliente c
LEFT JOIN pedido p ON c.id = p.id_cliente AND YEAR(p.fecha) = 2017
GROUP BY c.id;

-- 10.Devuelve un listado que muestre el identificador de cliente, nombre, primer apellido y el valor de
-- la máxima cantidad del pedido realizado por cada uno de los clientes. El resultado debe mostrar
-- aquellos clientes que no han realizado ningún pedido indicando que la máxima cantidad de sus
-- pedidos realizados es 0. Puede hacer uso de la función IFNULL.

SELECT c.id, c.nombre, c.apellido1, IFNULL(MAX(p.total), 0) AS max_total
FROM cliente c
LEFT JOIN pedido p ON c.id = p.id_cliente
GROUP BY c.id;

-- 11.Devuelve cuál ha sido el pedido de máximo valor que se ha realizado cada año.

SELECT YEAR(fecha) AS anio, MAX(total) AS max_total
FROM pedido
GROUP BY anio;

-- 12.Devuelve el número total de pedidos que se han realizado cada año.

SELECT YEAR(fecha) AS anio, COUNT(*) AS total_pedidos
FROM pedido
GROUP BY anio;

-- 13.Devuelve los datos del cliente que realizó el pedido más caro en el año 2019. (Sin utilizar INNER
-- JOIN)

SELECT * 
FROM cliente
WHERE id = (
    SELECT id_cliente 
    FROM pedido 
    WHERE YEAR(fecha) = 2019 
    ORDER BY total DESC 
    LIMIT 1
);

-- 14.Devuelve la fecha y la cantidad del pedido de menor valor realizado por el cliente Pepe Ruiz
-- Santana.

SELECT fecha, total 
FROM pedido 
WHERE id_cliente = (
    SELECT id FROM cliente 
    WHERE nombre = 'Pepe' AND apellido1 = 'Ruiz' AND apellido2 = 'Santana'
)
ORDER BY total ASC 
LIMIT 1;

-- 15.Devuelve un listado con los datos de los clientes y los pedidos, de todos los clientes que han
-- realizado un pedido durante el año 2017 con un valor mayor o igual al valor medio de los pedidos
-- realizados durante ese mismo año.

SELECT c.*, p.*
FROM cliente c
JOIN pedido p ON c.id = p.id_cliente
WHERE YEAR(p.fecha) = 2017
AND p.total >= (
    SELECT AVG(total) FROM pedido WHERE YEAR(fecha) = 2017
);

-- 16.Devuelve el pedido más caro que existe en la tabla pedido si hacer uso de MAX, ORDER BY ni LIMIT.

SELECT * 
FROM pedido p1
WHERE total >= ALL (SELECT total FROM pedido);

-- 17.Devuelve un listado de los clientes que no han realizado ningún pedido. (Utilizando ANY o ALL).

SELECT * 
FROM cliente 
WHERE id <> ALL (SELECT id_cliente FROM pedido);

-- 18.Devuelve un listado de los comerciales que no han realizado ningún pedido. (Utilizando ANY o ALL).

SELECT * 
FROM comercial 
WHERE id <> ALL (SELECT id_comercial FROM pedido);

-- 19.Devuelve un listado de los clientes que no han realizado ningún pedido. (Utilizando IN o NOT IN).

SELECT * 
FROM cliente 
WHERE id NOT IN (SELECT id_cliente FROM pedido);

-- 20.Devuelve un listado de los comerciales que no han realizado ningún pedido. (Utilizando IN o NOT
-- IN).

SELECT * 
FROM comercial 
WHERE id NOT IN (SELECT id_comercial FROM pedido);

-- 21.Devuelve un listado de los clientes que no han realizado ningún pedido. (Utilizando EXISTS o NOT
-- EXISTS).
SELECT * 
FROM cliente c
WHERE NOT EXISTS (
    SELECT 1 FROM pedido p WHERE p.id_cliente = c.id
);