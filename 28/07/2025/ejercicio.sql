CREATE DATABASE IF NOT EXISTS Hospital;

USE Hospital;


CREATE TABLE Dept (
    Dept_No     INT NOT NULL,
    DNombre     VARCHAR(50),
    Loc         VARCHAR(50),
    PRIMARY KEY (Dept_No)
);


CREATE TABLE Emp (
    Emp_No      INT NOT NULL,
    Apellido    VARCHAR(50),
    Oficio      VARCHAR(50),
    Dir         INT,
    Fecha_Alt   DATETIME,
    Salario     DECIMAL(9,2),
    Comision    DECIMAL(9,2),
    Dept_No     INT,
    PRIMARY KEY (Emp_No),
    FOREIGN KEY (Dept_No) REFERENCES Dept(Dept_No)
);


CREATE TABLE Hospital (
    Hospital_Cod    INT NOT NULL,
    Nombre          VARCHAR(50),
    Direccion       VARCHAR(50),
    Telefono        VARCHAR(50),
    Num_Cama        INT,
    PRIMARY KEY (Hospital_Cod)
);


CREATE TABLE Doctor (
    Doctor_No       INT NOT NULL,
    Hospital_Cod    INT NOT NULL,
    Apellido        VARCHAR(50),
    Especialidad    VARCHAR(50),
    PRIMARY KEY (Doctor_No),
    FOREIGN KEY (Hospital_Cod) REFERENCES Hospital(Hospital_Cod)
);


CREATE TABLE Sala (
    Sala_Cod        INT NOT NULL,
    Hospital_Cod    INT NOT NULL,
    Nombre          VARCHAR(50),
    Num_Cama        INT,
    PRIMARY KEY (Sala_Cod, Hospital_Cod),
    FOREIGN KEY (Hospital_Cod) REFERENCES Hospital(Hospital_Cod)
);


CREATE TABLE Plantilla (
    Empleado_No     INT NOT NULL,
    Sala_Cod        INT NOT NULL,
    Hospital_Cod    INT NOT NULL,
    Apellido        VARCHAR(50),
    Funcion         VARCHAR(50),
    T               VARCHAR(15),
    Salario         DECIMAL(9,2),
    PRIMARY KEY (Empleado_No),
    FOREIGN KEY (Sala_Cod, Hospital_Cod) REFERENCES Sala(Sala_Cod, Hospital_Cod)
);


CREATE TABLE Enfermo (
    Inscripcion     INT NOT NULL,
    Apellido        VARCHAR(50),
    Direccion       VARCHAR(50),
    Fecha_Nac       DATE,
    S               VARCHAR(2),
    NSS             INT,
    PRIMARY KEY (Inscripcion)
);


INSERT INTO Dept(Dept_No, DNombre, Loc) VALUES
(10, 'CONTABILIDAD', 'ELCHE'),
(20, 'INVESTIGACIÓN', 'MADRID'),
(30, 'VENTAS', 'BARCELONA'),
(40, 'PRODUCCIÓN', 'SALAMANCA');


INSERT INTO Emp(Emp_No, Apellido, Oficio, Dir, Fecha_Alt, Salario, Comision, Dept_No) VALUES
(7369,'SANCHEZ','EMPLEADO',7902,'1980-12-17',10400,0,20),
(7499,'ARROYO','VENDEDOR',7698,'1981-02-22',208000,39000,30),
(7521,'SALA','VENDEDOR',689,'1981-02-22',162500,65000,30),
(7566,'JIMENEZ','DIRECTOR',7839,'1981-04-02',386750,0,20),
(7654,'MARTIN','VENDEDOR',7698,'1981-09-28',182000,182000,30),
(7698,'NEGRO','DIRECTOR',7839,'1981-05-01',370500,0,30),
(7782,'CEREZO','DIRECTOR',7839,'1981-06-09',318500,0,10),
(7788,'NINO','ANALISTA',7566,'1987-03-30',390000,0,20),
(7839,'REY','PRESIDENTE',0,'1981-11-17',650000,0,10),
(7844,'TOVAR','VENDEDOR',7698,'1981-09-08',195000,0,30),
(7876,'ALONSO','EMPLEADO',7788,'1987-05-03',143000,0,20),
(7900,'JIMENO','EMPLEADO',7698,'1981-12-03',123500,0,30),
(7902,'FERNANDEZ','ANALISTA',7566,'1981-12-03',390000,0,20),
(7934,'MUÑOZ','EMPLEADO',7782,'1982-06-23',169000,0,10),
(7119,'SERRA','DIRECTOR',7839,'1983-11-19',225000,39000,20),
(7322,'GARCIA','EMPLEADO',7119,'1982-10-12',129000,0,20);


INSERT INTO Hospital(Hospital_Cod, Nombre, Direccion, Telefono, Num_Cama) VALUES
(19, 'Provincial', 'O Donell 50', '964-4256', 502),
(18, 'General', 'Atocha s/n', '595-3111', 987),
(22, 'La Paz', 'Castellana 1000', '923-5411', 412),
(45, 'San Carlos', 'Ciudad Universitaria', '597-1500', 845);


INSERT INTO Doctor(Hospital_Cod, Doctor_No, Apellido, Especialidad) VALUES
(22, 386, 'Cabeza D.', 'Psiquiatría'),
(22, 398, 'Best D.', 'Urología'),
(19, 435, 'López A.', 'Cardiología'),
(22, 453, 'Galo D.', 'Pediatría'),
(45, 522, 'Adams C.', 'Neurología'),
(18, 585, 'Miller G.', 'Ginecología'),
(45, 607, 'Chuki P.', 'Pediatría'),
(18, 982, 'Cajal R.', 'Cardiología');


INSERT INTO Sala(Sala_Cod, Hospital_Cod, Nombre, Num_Cama) VALUES
(1, 22, 'Recuperación', 10),
(1, 45, 'Recuperación', 15),
(2, 22, 'Maternidad', 34),
(2, 45, 'Maternidad', 24),
(3, 19, 'Cuidados Intensivos', 21),
(3, 18, 'Cuidados Intensivos', 10),
(4, 18, 'Cardiología', 53),
(4, 45, 'Cardiología', 55),
(6, 19, 'Psiquiátricos', 67),
(6, 22, 'Psiquiátricos', 118);


INSERT INTO Plantilla(Hospital_Cod, Sala_Cod, Empleado_No, Apellido, Funcion, T, Salario) VALUES
(22, 6, 1009, 'Higueras D.', 'Enfermera', 'T', 200500),
(45, 4, 1280, 'Amigo R.', 'Interino', 'N', 221000),
(19, 6, 3106, 'Hernández', 'Enfermero', 'T', 275000),
(19, 6, 3754, 'Díaz B.', 'Enfermera', 'T', 226200),
(22, 1, 6065, 'Rivera G.', 'Enfermera', 'N', 162600),
(18, 4, 6357, 'Karplus W.', 'Interino', 'T', 337900),
(22, 1, 7379, 'Carlos R.', 'Enfermera', 'T', 211900),
(22, 6, 8422, 'Bocina G.', 'Enfermero', 'M', 183800),
(45, 1, 8526, 'Frank H.', 'Enfermera', 'T', 252200),
(22, 2, 9901, 'Núñez C.', 'Interino', 'M', 221000);


INSERT INTO Enfermo(Inscripcion, Apellido, Direccion, Fecha_Nac, S, NSS) VALUES
(10995, 'Laguía M.', 'Goya 20', '1956-05-16', 'M', 280862422),
(14024, 'Fernández M.', 'Recoletos 50', '1960-05-21', 'F', 284991452),
(18004, 'Serrano V.', 'Alcalá 12', '1967-06-23', 'F', 321790059),
(36658, 'Domin S.', 'Mayor 71', '1942-01-01', 'M', 160654471),
(38702, 'Neal R.', 'Orense 11', '1940-06-18', 'F', 380010217),
(39217, 'Cervantes M.', 'Perón 38', '1952-02-29', 'M', 440294390),
(59076, 'Miller B.', 'López de Hoyos 2', '1945-09-16', 'F', 311969044),
(63827, 'Ruiz P.', 'Ezquerdo 103', '1980-12-26', 'M', 100973253),
(64823, 'Fraiser A.', 'Soto 3', '1980-07-10', 'F', 285201776),
(74835, 'Benítez E.', 'Argentina', '1957-10-05', 'M', 154811767);


-- 1. Construya el procedimiento almacenado que saque todos los empleados que se dieron de
-- alta entre una determinada fecha inicial y fecha final y que pertenecen a un determinado
-- departamento.

drop procedure empleados_por_fecha_y_departamento;

DELIMITER $$

CREATE PROCEDURE empleados_por_fecha_y_departamento(
    IN fecha_inicio DATE,
    IN fecha_fin DATE,
    IN id_departamento INT
)
BEGIN
    SELECT * 
    FROM Emp
    WHERE Fecha_Alt BETWEEN fecha_inicio AND fecha_fin
      AND Dept_No = id_departamento;
END $$

DELIMITER ;

CALL empleados_por_fecha_y_departamento('1980-01-01', '1983-12-31', 20);


-- 2. Construya el procedimiento que inserte un empleado. 

DROP PROCEDURE IF EXISTS insertar_empleado;

DELIMITER $$
CREATE PROCEDURE insertar_empleado(
    IN p_emp_no INT,
    IN p_apellido VARCHAR(50),
    IN p_oficio VARCHAR(50),
    IN p_dir INT,
    IN p_fecha_alt DATE,
    IN p_salario DECIMAL(10,2),
    IN p_comision DECIMAL(10,2),
    IN p_dept_no INT
)
BEGIN
    INSERT INTO Emp(Emp_No, Apellido, Oficio, Dir, Fecha_Alt, Salario, Comision, Dept_No)
    VALUES(p_emp_no, p_apellido, p_oficio, p_dir, p_fecha_alt, p_salario, p_comision, p_dept_no);
END $$
DELIMITER ;

CALL insertar_empleado(8000, 'LOPEZ', 'PROGRAMADOR', 7839, '1985-06-10', 150000.00, 5000.00, 10);
CALL insertar_empleado(8001, 'GOMEZ', 'ANALISTA', 7566, '1984-08-15', 220000.00, 10000.00, 20);



-- 3. Construya el procedimiento que recupere el nombre, número y número de personas a
-- partir del número de departamento.


DROP PROCEDURE IF EXISTS obtener_info_departamento;

DELIMITER $$

CREATE PROCEDURE obtener_info_departamento(
    IN p_dept_no INT
)
BEGIN
    SELECT 
        d.DNombre AS Nombre_Departamento,
        d.Dept_No AS Numero_Departamento,
        COUNT(e.Emp_No) AS Numero_Empleados
    FROM Dept d
    LEFT JOIN Emp e ON d.Dept_No = e.Dept_No
    WHERE d.Dept_No = p_dept_no
    GROUP BY d.Dept_No, d.DNombre;
END $$

DELIMITER ;

CALL obtener_info_departamento(20);


-- 4. Diseñe y construya un procedimiento igual que el anterior, pero que recupere también las
-- personas que trabajan en dicho departamento, pasándole como parámetro el nombres

DELIMITER $$
CREATE PROCEDURE info_depto_y_empleados_por_nombre(
    IN p_dnombre VARCHAR(50)
)
BEGIN
    SELECT 
        Dept_No,
        DNombre,
        (SELECT COUNT(*) FROM Emp WHERE Dept_No = Dept.Dept_No) AS numero_personas
    FROM Dept
    WHERE DNombre = p_dnombre;
    SELECT 
        Emp_No,
        Apellido,
        Oficio,
        Salario,
        Comision
    FROM Emp
    WHERE Dept_No = (SELECT Dept_No FROM Dept WHERE DNombre = p_dnombre);
END $$
DELIMITER ;

CALL info_depto_y_empleados_por_nombre('VENTAS');


-- 5. Construya un procedimiento para devolver salario, oficio y comisión, pasándole el apellido.


DROP PROCEDURE IF EXISTS datos_empleado_por_apellido;

DELIMITER $$

CREATE PROCEDURE datos_empleado_por_apellido(
    IN p_apellido VARCHAR(50)
)
BEGIN
    SELECT Salario, Oficio, Comision
    FROM Emp
    WHERE Apellido = p_apellido;
END $$

DELIMITER ;

CALL datos_empleado_por_apellido('ARROYO');



-- 6. Tal como el ejercicio anterior, pero si no le pasamos ningún valor, mostrará los datos de
-- todos los empleados.


DROP PROCEDURE IF EXISTS datos_empleado_condicional;

DELIMITER $$

CREATE PROCEDURE datos_empleado_condicional(
    IN p_apellido VARCHAR(50)
)
BEGIN
    IF p_apellido IS NULL OR p_apellido = '' THEN
        SELECT Salario, Oficio, Comision, Apellido
        FROM Emp;
    ELSE
        SELECT Salario, Oficio, Comision, Apellido
        FROM Emp
        WHERE Apellido = p_apellido;
    END IF;
END $$

DELIMITER ;

CALL datos_empleado_condicional('');


-- 7. Construya un procedimiento para mostrar el salario, oficio, apellido y nombre del
-- departamento de todos los empleados que contengan en su apellido el valor que le
-- pasemos como parámetro.

drop procedure empleados_por_apellido;

DELIMITER $$
CREATE PROCEDURE empleados_por_apellido(IN filtro_apellido VARCHAR(50))
BEGIN
    SELECT 
        e.Salario,
        e.Oficio,
        e.Apellido,
        d.DNombre AS Nombre_Departamento
    FROM 
        Emp e
    JOIN 
        Dept d ON e.Dept_No = d.Dept_No
    WHERE 
        e.Apellido LIKE CONCAT('%', filtro_apellido, '%');
END $$
DELIMITER ;

CALL empleados_por_apellido('tin');