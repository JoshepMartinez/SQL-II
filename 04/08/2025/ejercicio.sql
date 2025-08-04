-- 1.Crea un trigger que impida que una ciudad cambie de país.

DROP TRIGGER IF EXISTS trg_block_city_country_change;

DELIMITER //
CREATE TRIGGER trg_block_city_country_change
BEFORE UPDATE ON city
FOR EACH ROW
BEGIN
  IF OLD.CountryCode != NEW.CountryCode THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite cambiar la ciudad de país.';
  END IF;
END;
//
DELIMITER ;

UPDATE city
SET CountryCode = 'USA'
WHERE Name = 'Bucaramanga';

SELECT * from city where Name = 'Bucaramanga'; 

-- 2.Crea un trigger que registre en una tabla los intentos de eliminar registros de country.

CREATE TABLE IF NOT EXISTS country_delete_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  country_code CHAR(3),
  name VARCHAR(100),
  attempted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop trigger log_country_delete;

DELIMITER //
CREATE TRIGGER log_country_delete
BEFORE DELETE ON country
FOR EACH ROW
BEGIN
  INSERT INTO country_delete_log (country_code, name)
  VALUES (OLD.Code, OLD.Name);
END;
//
DELIMITER ;

INSERT INTO country (
  Code, Name, Continent, Region, SurfaceArea, IndepYear, Population,
  LifeExpectancy, GNP, GNPOld, LocalName, GovernmentForm, HeadOfState, Capital, Code2
) VALUES (
  'ZZZ', 'Testland', 'Asia', 'TestRegion', 1234.5, 2000, 10000,
  70.0, 12345, 12000, 'Testlandia', 'Republic', 'Test Leader', NULL, 'TL'
);

DELETE FROM country WHERE Code = 'ZZZ';

SELECT * FROM country_delete_log;


-- 3.Programa un evento que actualice una tabla de estadísticas cada semana.

CREATE TABLE IF NOT EXISTS weekly_statistics (
  id INT AUTO_INCREMENT PRIMARY KEY,
  stat_date DATE,
  total_cities INT,
  total_countries INT
);

SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS ev_update_stats_weekly;

DELIMITER //
CREATE EVENT ev_update_stats_weekly
ON SCHEDULE EVERY 1 WEEK
STARTS CURRENT_TIMESTAMP
DO
BEGIN
  INSERT INTO weekly_statistics (stat_date, total_cities, total_countries)
  VALUES (
    CURDATE(),
    (SELECT COUNT(*) FROM city),
    (SELECT COUNT(*) FROM country)
  );
END;
//
DELIMITER ;

INSERT INTO weekly_statistics (stat_date, total_cities, total_countries)
VALUES (
  CURDATE(),
  (SELECT COUNT(*) FROM city),
  (SELECT COUNT(*) FROM country)
);

SELECT * FROM weekly_statistics;


-- 4.Implementa un trigger que controle que no se agreguen ciudades con el mismo nombre dentro del mismo país.
 
DELIMITER //
CREATE TRIGGER prevent_duplicate_city
BEFORE INSERT ON city
FOR EACH ROW
BEGIN
  IF EXISTS (
    SELECT 1 FROM city
    WHERE Name = NEW.Name AND CountryCode = NEW.CountryCode
  ) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Ya existe una ciudad con ese nombre en este país.';
  END IF;
END;
//
DELIMITER ;

INSERT INTO city (Name, CountryCode, District, Population)
VALUES ('Bogotá', 'COL', 'Cundinamarca', 100000);

-- 5.Crea un trigger que actualice automáticamente el número total de ciudades en cada país.

DROP TRIGGER IF EXISTS after_city_insert;
DROP TRIGGER IF EXISTS after_city_delete;

DELIMITER //
CREATE TRIGGER after_city_insert
AFTER INSERT ON city
FOR EACH ROW
BEGIN
  UPDATE country
  SET total_cities = total_cities + 1
  WHERE Code = NEW.CountryCode;
END;
//

CREATE TRIGGER after_city_delete
AFTER DELETE ON city
FOR EACH ROW
BEGIN
  UPDATE country
  SET total_cities = total_cities - 1
  WHERE Code = OLD.CountryCode;
END;
//

DELIMITER ;

INSERT INTO city (Name, CountryCode, District, Population)
VALUES ('Nueva Ciudad', 'COL', 'Santander', 5000);

SELECT Name, total_cities FROM country WHERE Code = 'COL';


-- 6.Programa un evento que borre ciudades con población menor a 1,000 habitantes cada mes.

DELIMITER //
CREATE EVENT IF NOT EXISTS ev_monthly_cleanup
ON SCHEDULE EVERY 1 MONTH
DO
BEGIN
  DELETE FROM city
  WHERE Population < 1000;
END;
//
DELIMITER ;

DELETE FROM city WHERE Population < 1000;

SELECT * FROM city WHERE Population < 1000;


-- 7.Diseña un trigger que registre cambios en la tabla country.

CREATE TABLE IF NOT EXISTS country_change_log (
  id INT AUTO_INCREMENT PRIMARY KEY,
  country_code CHAR(3),
  old_name VARCHAR(100),
  new_name VARCHAR(100),
  change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

drop trigger log_country_name_change;
DELIMITER //
CREATE TRIGGER log_country_name_change
AFTER UPDATE ON country
FOR EACH ROW
BEGIN
  IF OLD.Name <> NEW.Name THEN
    INSERT INTO country_change_log (country_code, old_name, new_name)
    VALUES (OLD.Code, OLD.Name, NEW.Name);
  END IF;
END;
//
DELIMITER ;

UPDATE country
SET Name = 'Colombia Nueva'
WHERE Code = 'COL';

SELECT * FROM country_change_log;

-- 8.Crea un trigger que evite que la población de una ciudad disminuya en más del 50%.

drop trigger prevent_population_drop;
DELIMITER //
CREATE TRIGGER prevent_population_drop
BEFORE UPDATE ON city
FOR EACH ROW
BEGIN
  IF NEW.Population < OLD.Population / 2 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La población no puede disminuir más del 50%.';
  END IF;
END;
//
DELIMITER ;

UPDATE city
SET Population = Population * 0.4
WHERE Name = 'Buenos Aires';

SELECT * FROM city WHERE Name = 'Buenos Aires';


-- 9.Programa un evento que genere un reporte diario de los 10 países con mayor población urbana.

drop table top_urban_countries;
CREATE TABLE IF NOT EXISTS top_urban_countries (
  report_date DATE,
  country_code CHAR(3),
  country_name VARCHAR(100),
  total_urban_population INT
);

drop event ev_daily_urban_report;
DELIMITER //
CREATE EVENT IF NOT EXISTS ev_daily_urban_report
ON SCHEDULE EVERY 1 DAY
DO
BEGIN
  INSERT INTO top_urban_countries (report_date, country_code, country_name, total_urban_population)
  SELECT CURDATE(), c.Code, c.Name, SUM(ci.Population)
  FROM country c
  JOIN city ci ON c.Code = ci.CountryCode
  GROUP BY c.Code
  ORDER BY SUM(ci.Population) DESC
  LIMIT 10;
END;
//
DELIMITER ;

SELECT * FROM top_urban_countries
ORDER BY report_date DESC;

-- 10.Diseña un trigger que impida eliminar países que tienen ciudades registradas.

DELIMITER //
CREATE TRIGGER prevent_country_delete_with_cities
BEFORE DELETE ON country
FOR EACH ROW
BEGIN
  IF EXISTS (SELECT 1 FROM city WHERE CountryCode = OLD.Code) THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se puede eliminar un país que tiene ciudades registradas.';
  END IF;
END;
//
DELIMITER ;

DELETE FROM country
WHERE Code = 'COL';