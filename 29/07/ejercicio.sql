CREATE DATABASE Tienda;
USE Tienda;

CREATE TABLE Productos (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(255),
    precio DECIMAL(10, 2),
    stock INT,
    PRIMARY KEY (id)
);


CREATE TABLE Clientes (
    id INT AUTO_INCREMENT,
    nombre VARCHAR(255),
    email VARCHAR(255),
    PRIMARY KEY (id)
);

CREATE TABLE Ventas (
    id INT AUTO_INCREMENT,
    producto_id INT,
    cliente_id INT,
    cantidad INT,
    fecha_venta DATE,
    PRIMARY KEY (id),
    FOREIGN KEY (producto_id) REFERENCES Productos(id),
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id)
);

DROP PROCEDURE IF EXISTS AñadirProducto;

DELIMITER //
CREATE PROCEDURE AñadirProducto(
    IN nombre VARCHAR(255),
    IN precio DECIMAL(10, 2),
    IN stock INT
)
BEGIN
    INSERT INTO Productos(nombre, precio, stock)
    VALUES (nombre, precio, stock);
end//
DELIMITER ;

DROP PROCEDURE IF EXISTS RegistrarCliente;

DELIMITER //
CREATE PROCEDURE RegistrarCliente(
    IN nombre VARCHAR(255),
    IN email VARCHAR(255)
)
BEGIN
    INSERT INTO Clientes(nombre, email)
    VALUES (nombre, email);
end//
DELIMITER ;

DROP PROCEDURE IF EXISTS RealizarVenta;

DELIMITER //
CREATE PROCEDURE RealizarVenta(
    IN productoID INT,
    IN clienteID INT,
    IN cantidad INT
)
BEGIN
    INSERT INTO Ventas(producto_id, cliente_id, cantidad, fecha_venta)
    VALUES (productoID, clienteID, cantidad, CURDATE());
END//
DELIMITER ;

-- El DBA de la base de datos tienda te da la estructura de la base de datos y algunos
-- procedimientos almacenados y te pide que agregues excepciones a los procedimientos
-- almacenados registrando el error en la tabla “errores_log” (debes diseñar una estructura para
-- esta tabla y crearla ).

CREATE TABLE errores_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    procedimiento VARCHAR(100),
    mensaje_error TEXT,
    fecha_error DATETIME DEFAULT CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS AñadirProducto;
DELIMITER //
CREATE PROCEDURE AñadirProducto(
    IN nombre VARCHAR(255),
    IN precio DECIMAL(10, 2),
    IN stock INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO errores_log(procedimiento, mensaje_error)
        VALUES ('AñadirProducto', 'Error al insertar el producto.');
    END;

    INSERT INTO Productos(nombre, precio, stock)
    VALUES (nombre, precio, stock);
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS RegistrarCliente;

DELIMITER //
CREATE PROCEDURE RegistrarCliente(
    IN nombre VARCHAR(255),
    IN email VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO errores_log(procedimiento, mensaje_error)
        VALUES ('RegistrarCliente', 'Error al insertar el cliente.');
    END;

    INSERT INTO Clientes(nombre, email)
    VALUES (nombre, email);
END//
DELIMITER ;


DROP PROCEDURE IF EXISTS RealizarVenta;

DELIMITER //
CREATE PROCEDURE RealizarVenta(
    IN productoID INT,
    IN clienteID INT,
    IN cantidad INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        INSERT INTO errores_log(procedimiento, mensaje_error)
        VALUES ('RealizarVenta', 'Error al registrar la venta.');
    END;

    INSERT INTO Ventas(producto_id, cliente_id, cantidad, fecha_venta)
    VALUES (productoID, clienteID, cantidad, CURDATE());
end//
DELIMITER ;


use hospital;

-- 1. Crear un procedimiento que recupere el número departamento, el nombre y número de
-- empleados, dándole como valor el nombre del departamento, si el nombre introducido no
-- es válido, mostraremos un mensaje informativo comunicándolo.

DROP PROCEDURE IF EXISTS RecuperarInfoDepartamento;

DELIMITER //
CREATE PROCEDURE RecuperarInfoDepartamento(IN nombre_departamento VARCHAR(50))
BEGIN
    DECLARE dept_id INT;
    DECLARE cantidad_empleados INT;
    IF EXISTS (
        SELECT 1 FROM Dept WHERE DNombre = nombre_departamento
    ) THEN
        SELECT Dept_No INTO dept_id FROM Dept WHERE DNombre = nombre_departamento LIMIT 1;

        SELECT COUNT(*) INTO cantidad_empleados FROM Emp WHERE Dept_No = dept_id;

        SELECT 
            dept_id AS numero_departamento,
            nombre_departamento AS nombre_departamento,
            cantidad_empleados AS numero_empleados;
    ELSE
        SELECT CONCAT('El departamento "', nombre_departamento, '" no existe.') AS mensaje;
    END IF;
END//
DELIMITER ;

CALL RecuperarInfoDepartamento('ventas');

-- 2. Crear un procedimiento para devolver un informe sobre los empleados de la plantilla de
-- un determinado hospital, sala, turno o función. El informe mostrará número de empleados,
-- media, suma y un informe personalizado de cada uno que muestre número de empleado,
-- apellido y salario.

DROP PROCEDURE IF EXISTS InformePlantilla;

DELIMITER //
CREATE PROCEDURE InformePlantilla(
    IN p_Hospital_Cod INT,
    IN p_Sala_Cod INT,
    IN p_T VARCHAR(15),
    IN p_Funcion VARCHAR(50)
)
BEGIN
    SELECT 
        COUNT(*) AS numero_empleados,
        AVG(Salario) AS salario_medio,
        SUM(Salario) AS salario_total
    FROM Plantilla
    WHERE (p_Hospital_Cod IS NULL OR Hospital_Cod = p_Hospital_Cod)
      AND (p_Sala_Cod IS NULL OR Sala_Cod = p_Sala_Cod)
      AND (p_T IS NULL OR T = p_T)
      AND (p_Funcion IS NULL OR Funcion = p_Funcion);
    SELECT 
        Empleado_No,
        Apellido,
        Salario
    FROM Plantilla
    WHERE (p_Hospital_Cod IS NULL OR Hospital_Cod = p_Hospital_Cod)
      AND (p_Sala_Cod IS NULL OR Sala_Cod = p_Sala_Cod)
      AND (p_T IS NULL OR T = p_T)
      AND (p_Funcion IS NULL OR Funcion = p_Funcion)
    ORDER BY Apellido;
END//
DELIMITER ;

CALL InformePlantilla(NULL, NULL, NULL, NULL);

-- 3. Crear un procedimiento en el que pasaremos como parámetro el Apellido de un
-- empleado. El procedimiento devolverá los subordinados del empleado escrito, si el
-- empleado no existe en la base de datos, informaremos de ello, si el empleado no tiene
-- subordinados, lo informa remos con un mensaje y mostraremos su jefe. Mostrar el
-- número de empleado, Apellido, Oficio y Departamento de los subordinados.

DROP PROCEDURE IF EXISTS MostrarSubordinados;

DELIMITER //
CREATE PROCEDURE MostrarSubordinados(IN p_Apellido VARCHAR(50))
BEGIN
    DECLARE v_emp_no INT;
    DECLARE v_dir INT;
    DECLARE v_subordinados INT;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_emp_no = NULL;

    SELECT Emp_No, Dir INTO v_emp_no, v_dir
    FROM Emp
    WHERE Apellido = p_Apellido
    LIMIT 1;

    IF v_emp_no IS NULL THEN
        SELECT CONCAT('El empleado con apellido "', p_Apellido, '" no existe.') AS mensaje;
    ELSE
        SELECT COUNT(*) INTO v_subordinados FROM Emp WHERE Dir = v_emp_no;

        IF v_subordinados = 0 THEN
            SELECT CONCAT('El empleado "', p_Apellido, '" no tiene subordinados.') AS mensaje;

            IF v_dir IS NOT NULL AND v_dir != 0 THEN
                SELECT Emp_No AS numero_empleado, Apellido AS apellido, Oficio AS oficio, Dept_No AS departamento
                FROM Emp WHERE Emp_No = v_dir;
            ELSE
                SELECT 'El empleado no tiene jefe asignado.' AS info;
            END IF;
        ELSE
            SELECT Emp_No, Apellido, Oficio, Dept_No
            FROM Emp WHERE Dir = v_emp_no;
        END IF;
    END IF;
END//
DELIMITER ;

CALL MostrarSubordinados('SANCHEZ');

-- 4. Crear procedimiento que borre un empleado que coincida con los parámetros indicados
-- (los parámetros serán todos los campos de la tabla empleado).

DROP PROCEDURE IF EXISTS BorrarEmpleadoExacto;

DELIMITER //
CREATE PROCEDURE BorrarEmpleadoExacto(
    IN p_Emp_No INT,
    IN p_Apellido VARCHAR(50),
    IN p_Oficio VARCHAR(50),
    IN p_Dir INT,
    IN p_Fecha_Alt DATETIME,
    IN p_Salario DECIMAL(9,2),
    IN p_Comision DECIMAL(9,2),
    IN p_Dept_No INT
)
BEGIN
    DELETE FROM Emp
    WHERE Emp_No = p_Emp_No
      AND Apellido = p_Apellido
      AND Oficio = p_Oficio
      AND ((Dir IS NULL AND p_Dir IS NULL) OR Dir = p_Dir)
      AND Fecha_Alt = p_Fecha_Alt
      AND Salario = p_Salario
      AND ((Comision IS NULL AND p_Comision IS NULL) OR Comision = p_Comision)
      AND Dept_No = p_Dept_No;
END//
DELIMITER ;

CALL BorrarEmpleadoExacto(
    7369,
    'SANCHEZ',
    'EMPLEADO',
    7902,
    '1980-12-17 00:00:00',
    10400.00,
    0,
    20
);

-- 5. Modificación del ejercicio anterior, si no se introducen datos correctamente, informar de
-- ello con un mensaje y no realizar la baja. Si el empleado introducido no existe en la base
-- de datos, deberemos informarlo con un mensaje que devuelva el nombre y número de
-- empleado del empleado introducido. Si el empleado existe, pero los datos para eliminarlo
-- son incorrectos, informaremos mostrando los datos reales del empleado junto con los
-- datos introducidos por el usuario, para que se vea el fallo.

DROP PROCEDURE IF EXISTS BorrarEmpleadoVerificado;
DELIMITER //

CREATE PROCEDURE BorrarEmpleadoVerificado(
    IN p_Emp_No INT,
    IN p_Apellido VARCHAR(50),
    IN p_Oficio VARCHAR(50),
    IN p_Dir INT,
    IN p_Fecha_Alt DATETIME,
    IN p_Salario DECIMAL(9,2),
    IN p_Comision DECIMAL(9,2),
    IN p_Dept_No INT
)
BEGIN
    DECLARE v_apellido VARCHAR(50);
    DECLARE v_oficio VARCHAR(50);
    DECLARE v_dir INT;
    DECLARE v_fecha_alt DATETIME;
    DECLARE v_salario DECIMAL(9,2);
    DECLARE v_comision DECIMAL(9,2);
    DECLARE v_dept_no INT;

    IF NOT EXISTS (SELECT 1 FROM Emp WHERE Emp_No = p_Emp_No) THEN
        SELECT CONCAT('El empleado con número ', p_Emp_No, ' no existe.') AS mensaje;
    ELSE

        SELECT Apellido, Oficio, Dir, Fecha_Alt, Salario, Comision, Dept_No
        INTO v_apellido, v_oficio, v_dir, v_fecha_alt, v_salario, v_comision, v_dept_no
        FROM Emp WHERE Emp_No = p_Emp_No;

        IF v_apellido != p_Apellido OR
           v_oficio != p_Oficio OR
           v_dir != p_Dir OR
           v_fecha_alt != p_Fecha_Alt OR
           v_salario != p_Salario OR
           v_comision != p_Comision OR
           v_dept_no != p_Dept_No THEN

            SELECT 'Los datos introducidos NO coinciden con los datos reales del empleado.' AS mensaje;
            SELECT
                p_Emp_No AS emp_no,
                p_Apellido AS apellido_introducido, v_apellido AS apellido_real,
                p_Oficio AS oficio_introducido, v_oficio AS oficio_real,
                p_Dir AS dir_introducido, v_dir AS dir_real,
                p_Fecha_Alt AS fecha_introducida, v_fecha_alt AS fecha_real,
                p_Salario AS salario_introducido, v_salario AS salario_real,
                p_Comision AS comision_introducida, v_comision AS comision_real,
                p_Dept_No AS dept_introducido, v_dept_no AS dept_real;
        ELSE
            DELETE FROM Emp WHERE Emp_No = p_Emp_No;
            SELECT CONCAT('Empleado con número ', p_Emp_No, ' eliminado correctamente.') AS mensaje;
        END IF;
    END IF;
END//
DELIMITER ;



CALL BorrarEmpleadoVerificado(
    7369, 'SANCHEZ', 'EMPLEADO', 7902, '1980-12-17 00:00:00', 10400.00, 0.00, 20
);

CALL BorrarEmpleadoVerificado(
    7369, 'SANCHEZ', 'EMPLEADO', 7902, '1980-12-17 00:00:00', 10000.00, 0.00, 20
);


-- 6. Crear un procedimiento para insertar un empleado de la plantilla del Hospital. Para poder
-- insertar el empleado realizaremos restricciones:
-- - No podrá estar repetido el número de empleado.
-- - Para insertar, lo haremos por el nombre del hospital y por el nombre de sala, si no existe
-- la sala o el hospital, no insertaremos y lo informaremos.
-- - El oficio para insertar deberá estar entre los que hay en la base de datos, al igual que el
-- Turno.
-- - El salario no superará las 500.000 ptas.
-- - (Opcional) Podremos insertar por el código del hospital o sala y por su nombre.

DROP PROCEDURE IF EXISTS InsertarEmpleadoPlantilla;

DELIMITER //
CREATE PROCEDURE InsertarEmpleadoPlantilla(
    IN p_Empleado_No INT,
    IN p_Hospital_Nombre VARCHAR(50),
    IN p_Sala_Nombre VARCHAR(50),
    IN p_Apellido VARCHAR(50),
    IN p_Oficio VARCHAR(50),
    IN p_Turno VARCHAR(15),
    IN p_Salario DECIMAL(9,2)
)
BEGIN
    DECLARE v_Hospital_Cod INT DEFAULT NULL;
    DECLARE v_Sala_Cod INT DEFAULT NULL;
    DECLARE v_count INT DEFAULT 0;
    DECLARE continuar BOOL DEFAULT TRUE;

    SELECT COUNT(*) INTO v_count FROM Plantilla WHERE Empleado_No = p_Empleado_No;
    IF v_count > 0 THEN
        SELECT 'Error: Ya existe un empleado con ese número.' AS mensaje;
        SET continuar = FALSE;
    END IF;

    IF continuar THEN
        SELECT Hospital_Cod INTO v_Hospital_Cod
        FROM Hospital
        WHERE Nombre = p_Hospital_Nombre
        LIMIT 1;

        IF v_Hospital_Cod IS NULL THEN
            SELECT 'Error: Hospital no encontrado.' AS mensaje;
            SET continuar = FALSE;
        END IF;
    END IF;

    IF continuar THEN
        SELECT Sala_Cod INTO v_Sala_Cod
        FROM Sala
        WHERE Nombre = p_Sala_Nombre AND Hospital_Cod = v_Hospital_Cod
        LIMIT 1;

        IF v_Sala_Cod IS NULL THEN
            SELECT 'Error: Sala no encontrada para ese hospital.' AS mensaje;
            SET continuar = FALSE;
        END IF;
    END IF;

    IF continuar THEN
        SELECT COUNT(*) INTO v_count FROM Plantilla WHERE Funcion = p_Oficio;
        IF v_count = 0 THEN
            SELECT 'Error: Oficio no válido.' AS mensaje;
            SET continuar = FALSE;
        END IF;
    END IF;

    IF continuar THEN
        SELECT COUNT(*) INTO v_count FROM Plantilla WHERE T = p_Turno;
        IF v_count = 0 THEN
            SELECT 'Error: Turno no válido.' AS mensaje;
            SET continuar = FALSE;
        END IF;
    END IF;

    IF continuar THEN
        IF p_Salario > 500000 THEN
            SELECT 'Error: El salario no puede superar 500.000 ptas.' AS mensaje;
            SET continuar = FALSE;
        END IF;
    END IF;

    IF continuar THEN
        INSERT INTO Plantilla (
            Empleado_No, Sala_Cod, Hospital_Cod, Apellido, Funcion, T, Salario
        ) VALUES (
            p_Empleado_No, v_Sala_Cod, v_Hospital_Cod, p_Apellido, p_Oficio, p_Turno, p_Salario
        );

        SELECT 'Empleado insertado correctamente.' AS mensaje;
    END IF;
END//
DELIMITER ;

CALL InsertarEmpleadoPlantilla(
    9911, 'General', 'Cardiología', 'Romina', 'Enfermera', 'T', 4500000
);