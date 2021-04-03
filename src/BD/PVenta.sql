DROP DATABASE IF EXISTS PVenta;
CREATE DATABASE PVenta;
USE PVenta;

CREATE TABLE Tienda(
    Id_tienda INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(45) NOT NULL,
    Direccion VARCHAR(45) NOT NULL,
    RFC VARCHAR(45) NOT NULL,
    Ciudad VARCHAR(45) NOT NULL,
    Telefono VARCHAR(45) NOT NULL
)ENGINE = INNODB;

CREATE TABLE Proveedor(
    Id_proveedor INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(45) NOT NULL,
    RFC VARCHAR(45) NOT NULL,
    Telefono VARCHAR(45) NOT NULL,
    Empresa VARCHAR(45) NOT NULL,
    Direccion VARCHAR(45) NOT NULL,
    Estado VARCHAR(45) NOT NULL,
    Municipio VARCHAR(45) NOT NULL
)ENGINE = INNODB;

CREATE TABLE Puesto(
    Id_puesto INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(45) NOT NULL
)ENGINE = INNODB;

CREATE TABLE Departamento(
    Id_departamento INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(45) NOT NULL
)ENGINE = INNODB;

CREATE TABLE Producto(
    Id_producto INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(45) NOT NULL,
    Descripcion VARCHAR(45) NOT NULL,
    Precio_prov INT NOT NULL,
    Precio_vent INT NOT NULL,
    Marca VARCHAR(45) NOT NULL,
    Cantidad INT NOT NULL,
    Codigo_Barras VARCHAR(45) NOT NULL,
    Id_tienda_FK INT,
    Id_departamento_FK INT,
    Id_proveedor_FK INT,
    FOREIGN KEY (Id_tienda_FK) REFERENCES Tienda(Id_tienda),
    FOREIGN KEY (Id_departamento_FK) REFERENCES Departamento(Id_departamento),
    FOREIGN KEY (Id_proveedor_FK) REFERENCES Proveedor(Id_proveedor)
)ENGINE = INNODB;

CREATE TABLE Empleado(
    Id_empleado INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(45) NOT NULL,
    Apellido_P VARCHAR(45) NOT NULL,
    Apellido_M VARCHAR(45) NOT NULL,
    Direccion VARCHAR(45) NOT NULL,
    Telefono INT NOT NULL,
    Usuario VARCHAR(45) NOT NULL,
    Pass VARCHAR(45) NOT NULL,
    Id_tienda_FK INT,
    Id_puesto_FK INt,
    FOREIGN KEY (Id_tienda_FK) REFERENCES Tienda(Id_tienda),
    FOREIGN KEY (Id_puesto_FK) REFERENCES Puesto(Id_puesto)
)ENGINE = INNODB;

CREATE TABLE Login(
    Id_login INT PRIMARY KEY AUTO_INCREMENT,
    Id_empleado_FK INT,
    FechaYHora DATETIME,
    FOREIGN KEY (Id_empleado_FK) REFERENCES Empleado(Id_empleado)
)ENGINE = INNODB;

-- drop table if exists Venta;
CREATE TABLE Venta(
    Id_venta INT PRIMARY KEY AUTO_INCREMENT,
    Fecha DATE NOT NULL,
    Hora TIME NOT NULL,
    Total INT NOT NULL,
    Cambio VARCHAR(45) NOT NULL,
    Pago INT NOT NULL,
    Cantidad INT NOT NULL,
    Id_empleado_FK INT,
    FOREIGN KEY (Id_empleado_FK) REFERENCES Empleado(Id_empleado)
)ENGINE = INNODB;

-- DROP TABLE IF EXISTS CarritoDeCompra;
CREATE TABLE CarritoDeCompra(
	Id_Carrito INT PRIMARY KEY AUTO_INCREMENT,
	Nombre_Completo VARCHAR(45) NOT NULL,
	Cantidad INT NOT NULL,
    Precio INT NOT NULL,
	Total INT NOT NULL,
	Id_Aux_Venta INT NOT NULL
)ENGINE = INNODB;

CREATE TABLE Compra(
    Id_compra INT PRIMARY KEY AUTO_INCREMENT,
    Folio INT NOT NULL,
    Cantidad INT NOT NULL,
    Id_proveedor_FK INT,
    FOREIGN KEY (Id_proveedor_FK) REFERENCES Proveedor(Id_proveedor)
)ENGINE = INNODB;

DROP TABLE IF EXISTS Corte;
CREATE TABLE Corte(
    Id_corte INT PRIMARY KEY AUTO_INCREMENT,
    FechaHora DATETIME NOT NULL,
    Folio INT NOT NULL,
    Cajero VARCHAR(50) NOT NULL,
    N_Venta INT NOT NULL,
    Caja INT NOT NULL,
    Fondo_Inicial INT NOT NULL,
    Total_Venta INT NOT NULL,
    Total_Entregar INT NOT NULL,
    Id_empleado_FK INT,
    FOREIGN KEY (Id_empleado_FK) REFERENCES Empleado(Id_empleado)
)ENGINE = INNODB;

CREATE TABLE Inventario(
    Id_inventario INT PRIMARY KEY AUTO_INCREMENT,
    FechaHora DATETIME NOT NULL,
    Total_prov INT NOT NULL,
    Total_venta INT NOT NULL,
    Id_empleado_FK INT,
    Id_producto_FK INT,
    FOREIGN KEY (Id_empleado_FK) REFERENCES Empleado(Id_empleado),
    FOREIGN KEY (Id_producto_FK) REFERENCES Producto(Id_producto)
)ENGINE = INNODB;

-- PROCEDIMIENTO ALMACENADO --
DROP PROCEDURE IF EXISTS Carrito;
DELIMITER // 
CREATE PROCEDURE Carrito(IN CodigoB VARCHAR(45), IN CantidadP INT, IN Id_Aux_VentaP INT)
BEGIN
    DECLARE TotalP INT;
    DECLARE PrecioP INT;
    DECLARE Aux_Cantidad INT;
    DECLARE AUX INT;
    DECLARE Nombre_CompletoP VARCHAR(45);
    DECLARE ExistenciaP VARCHAR(45);
    IF NOT EXISTS(SELECT Nombre FROM Producto WHERE Codigo_Barras = CodigoB)
    THEN
		SET @RESPUESTA = 'El producto no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF EXISTS(SELECT Nombre FROM Producto WHERE Codigo_Barras = CodigoB)
		THEN
        
            SELECT Cantidad INTO Aux_Cantidad FROM Producto WHERE Codigo_Barras = CodigoB;
            
            IF(CantidadP <= Aux_Cantidad)
			THEN
				SET @RESPUESTA = 'Producto suficiente';
				SELECT @RESPUESTA AS respuesta;
				SELECT (Precio_vent * CantidadP) INTO TotalP FROM Producto WHERE Codigo_Barras = CodigoB;
				SELECT Precio_vent INTO PrecioP FROM Producto WHERE Codigo_Barras = CodigoB;
				SELECT concat(Nombre," ",Descripcion) INTO Nombre_CompletoP FROM Producto WHERE Codigo_Barras = CodigoB;
				INSERT INTO CarritoDeCompra(Nombre_Completo, Cantidad, Precio, Total, Id_Aux_Venta) VALUES(Nombre_CompletoP, CantidadP, PrecioP, TotalP, Id_Aux_VentaP);
                
                UPDATE Producto SET Cantidad=(Aux_Cantidad - CantidadP) WHERE Codigo_Barras = CodigoB;
			ELSE
				SET @RESPUESTA = 'No hay suficientes productos';
				SELECT @RESPUESTA AS respuesta;
			END IF;
		END IF;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS InsertLogin;
DELIMITER // 
CREATE PROCEDURE InsertLogin(IN UsuarioP VARCHAR(45), IN PassP VARCHAR(45))
BEGIN
    DECLARE AuxIdEmpleado INT;
    IF NOT EXISTS(SELECT Id_empleado FROM Empleado WHERE Usuario = UsuarioP AND Pass = PassP)
    THEN
        SET @RESPUESTA = 'Datos incorrectos';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF EXISTS(SELECT Id_empleado FROM Empleado WHERE Usuario = UsuarioP AND Pass = PassP)
        THEN

            SELECT Id_empleado INTO AuxIdEmpleado FROM Empleado WHERE Usuario = UsuarioP AND Pass = PassP;
            INSERT INTO Login(Id_empleado_FK,FechaYHora) VALUES (AuxIdEmpleado, NOW());
            SET @RESPUESTA = 'Bienvenido!!';
            SELECT @RESPUESTA AS respuesta;

        END IF;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS ExtraerId;
DELIMITER // 
CREATE PROCEDURE ExtraerId()
BEGIN
    DECLARE AUX INT;
     IF NOT EXISTS(SELECT Id_venta FROM Venta )
    THEN
        SET @RESPUESTA = '0';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF EXISTS(SELECT MAX(Id_venta) FROM Venta)
        THEN
            SELECT MAX(Id_venta) INTO AUX FROM Venta;
            SET @RESPUESTA = AUX;
            SELECT @RESPUESTA AS respuesta;
            END IF;
    END IF;

END //
DELIMITER ;

DROP PROCEDURE IF EXISTS InsertProducto;
DELIMITER // 
CREATE PROCEDURE InsertProducto( IN NombreP VARCHAR(45), IN DescripcionP VARCHAR(45), IN Precio_provP INT, IN Precio_ventP INT, IN MarcaP VARCHAR(45), IN CantidadP INT, IN Codigo_BarrasP VARCHAR(45), IN Id_tienda_FKP INT, IN NombreDepartamento VARCHAR(45), IN EmpresaP VARCHAR(45))
BEGIN
    DECLARE AuxIdDep INT;
    DECLARE AuxIdProv INT;

    IF NOT EXISTS(SELECT Nombre FROM Departamento WHERE Nombre = NombreDepartamento)
    THEN
        SET @RESPUESTA = 'El departamento no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF NOT EXISTS(SELECT Empresa FROM Proveedor WHERE EmpresaP = EmpresaP)
        THEN
            SET @RESPUESTA = 'La empresa no existe';
            SELECT @RESPUESTA AS respuesta;
            ELSE IF EXISTS(SELECT Empresa FROM Proveedor WHERE Empresa = EmpresaP)
                THEN
					SET @RESPUESTA = 'Producto encontrado';
					SELECT @RESPUESTA AS respuesta;
                    SELECT Id_departamento INTO AuxIdDep FROM Departamento WHERE Nombre = NombreDepartamento;
                    SELECT Id_proveedor INTO AuxIdProv FROM Proveedor WHERE Empresa = EmpresaP;
                    INSERT INTO Producto(Nombre, Descripcion, Precio_prov, Precio_vent, Marca, Cantidad, Codigo_Barras, Id_tienda_FK, Id_departamento_FK, Id_proveedor_FK) 
                    Values (NombreP, DescripcionP, Precio_provP,Precio_ventP, MarcaP, CantidadP, Codigo_BarrasP, Id_tienda_FKP, AuxIdDep, AuxIdProv);
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS InsertEmpleado;
DELIMITER // 
CREATE PROCEDURE InsertEmpleado( IN NombreP VARCHAR(45), IN Apellido_PP VARCHAR(45), IN Apellido_MP VARCHAR(45), IN DireccionP VARCHAR(45), IN TelefonoP INT, IN UsuarioP VARCHAR(45), IN PassP VARCHAR(45), IN TiendaP VARCHAR(45), IN PuestoP VARCHAR(45))
BEGIN
    DECLARE AuxIdTienda INT;
    DECLARE AuxIdPuesto INT;

    IF NOT EXISTS(SELECT Nombre FROM Tienda WHERE Nombre = TiendaP)
    THEN
        SET @RESPUESTA = 'La tienda no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF NOT EXISTS(SELECT Nombre FROM Puesto WHERE Nombre = PuestoP)
        THEN
            SET @RESPUESTA = 'El Puesto no existe';
            SELECT @RESPUESTA AS respuesta;
            ELSE IF EXISTS(SELECT Nombre FROM Puesto WHERE Nombre = PuestoP)
                THEN
                    SELECT Id_tienda INTO AuxIdTienda FROM Tienda WHERE Nombre = TiendaP;
                    SELECT Id_puesto INTO AuxIdPuesto FROM Puesto WHERE Nombre = PuestoP;
                    INSERT INTO Empleado(Nombre, Apellido_P, Apellido_M, Direccion, Telefono, Usuario, Pass, Id_tienda_FK, Id_puesto_FK)
                        VALUES(NombreP, Apellido_PP, Apellido_MP, DireccionP, TelefonoP, UsuarioP, PassP, AuxIdTienda, AuxIdPuesto);
                    SET @RESPUESTA = 'Registro Completado';
                    SELECT @RESPUESTA AS respuesta;
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS ActualizarUsuario;
DELIMITER // 
CREATE PROCEDURE ActualizarUsuario( IN NombreP VARCHAR(45), IN Apellido_PP VARCHAR(45), IN Apellido_MP VARCHAR(45), IN DireccionP VARCHAR(45), IN TelefonoP INT, IN UsuarioP VARCHAR(45), IN PassP VARCHAR(45), IN TiendaP VARCHAR(45), IN PuestoP VARCHAR(45))
BEGIN
    DECLARE AuxIdTienda INT;
    DECLARE AuxIdPuesto INT;

    IF NOT EXISTS(SELECT Nombre FROM Tienda WHERE Nombre = TiendaP)
    THEN
        SET @RESPUESTA = 'La tienda no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF NOT EXISTS(SELECT Nombre FROM Puesto WHERE Nombre = PuestoP)
        THEN
            SET @RESPUESTA = 'El Puesto no existe';
            SELECT @RESPUESTA AS respuesta;
            ELSE IF EXISTS(SELECT Nombre FROM Puesto WHERE Nombre = PuestoP)
                THEN
                    SELECT Id_tienda INTO AuxIdTienda FROM Tienda WHERE Nombre = TiendaP;
                    SELECT Id_puesto INTO AuxIdPuesto FROM Puesto WHERE Nombre = PuestoP;
                    UPDATE Empleado SET Nombre = NombreP, Apellido_P = Apellido_PP, Apellido_M = Apellido_MP, Direccion = DireccionP, Telefono = TelefonoP, Pass = PassP, Id_tienda_FK = AuxIdTienda, Id_puesto_FK = AuxIdPuesto WHERE Usuario = UsuarioP;
                    SET @RESPUESTA = 'Actualizacon Completada';
                    SELECT @RESPUESTA AS respuesta;
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS ActualizarUsuarioNombre;
DELIMITER // 
CREATE PROCEDURE ActualizarUsuarioNombre( IN NombreP VARCHAR(45), IN Apellido_PP VARCHAR(45), IN Apellido_MP VARCHAR(45), IN DireccionP VARCHAR(45), IN TelefonoP INT, IN UsuarioP VARCHAR(45), IN PassP VARCHAR(45), IN TiendaP VARCHAR(45), IN PuestoP VARCHAR(45))
BEGIN
    DECLARE AuxIdTienda INT;
    DECLARE AuxIdPuesto INT;

    IF NOT EXISTS(SELECT Nombre FROM Tienda WHERE Nombre = TiendaP)
    THEN
        SET @RESPUESTA = 'La tienda no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF NOT EXISTS(SELECT Nombre FROM Puesto WHERE Nombre = PuestoP)
        THEN
            SET @RESPUESTA = 'El Puesto no existe';
            SELECT @RESPUESTA AS respuesta;
            ELSE IF EXISTS(SELECT Nombre FROM Puesto WHERE Nombre = PuestoP)
                THEN
                    SELECT Id_tienda INTO AuxIdTienda FROM Tienda WHERE Nombre = TiendaP;
                    SELECT Id_puesto INTO AuxIdPuesto FROM Puesto WHERE Nombre = PuestoP;
                    UPDATE Empleado SET Apellido_P = Apellido_PP, Apellido_M = Apellido_MP, Direccion = DireccionP, Telefono = TelefonoP, Usuario = UsuarioP, Pass = PassP, Id_tienda_FK = AuxIdTienda, Id_puesto_FK = AuxIdPuesto WHERE Nombre = NombreP;
                    SET @RESPUESTA = 'Actualizacon Completada';
                    SELECT @RESPUESTA AS respuesta;
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS UpdateProductoPorNombre;
DELIMITER // 
CREATE PROCEDURE UpdateProductoPorNombre( IN NombreP VARCHAR(45), IN DescripcionP VARCHAR(45), IN Precio_provP INT, IN Precio_ventP INT, IN MarcaP VARCHAR(45), IN CantidadP INT, IN Codigo_BarrasP VARCHAR(45), IN NombreDepartamento VARCHAR(45), IN EmpresaP VARCHAR(45))
BEGIN
    DECLARE AuxIdDep INT;
    DECLARE AuxIdProv INT;

    IF NOT EXISTS(SELECT Nombre FROM Departamento WHERE Nombre = NombreDepartamento)
    THEN
        SET @RESPUESTA = 'El departamento no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF NOT EXISTS(SELECT Empresa FROM Proveedor WHERE Empresa = EmpresaP)
        THEN
            SET @RESPUESTA = 'El proveedor no existe';
            SELECT @RESPUESTA AS respuesta;
            ELSE IF EXISTS(SELECT Nombre FROM Producto WHERE Nombre = NombreP)
                THEN
                    SELECT Id_departamento INTO AuxIdDep FROM Departamento WHERE Nombre = NombreDepartamento;
                    SELECT Id_proveedor INTO AuxIdProv FROM Proveedor WHERE Empresa = EmpresaP;

                    UPDATE Producto SET Descripcion = DescripcionP, Precio_prov = Precio_provP, Precio_vent = Precio_ventP, Marca = MarcaP, Cantidad = CantidadP, Codigo_Barras = Codigo_BarrasP, Id_departamento_FK = AuxIdDep, Id_proveedor_FK = AuxIdProv WHERE Nombre = NombreP;
                    SET @RESPUESTA = 'Cambio realizado con exito';
                    SELECT @RESPUESTA AS respuesta;
                    ELSE 
                        SET @RESPUESTA = 'No existe Nombre';
                        SELECT @RESPUESTA AS respuesta;
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS UpdateProductoPorCB;
DELIMITER // 
CREATE PROCEDURE UpdateProductoPorCB( IN NombreP VARCHAR(45), IN DescripcionP VARCHAR(45), IN Precio_provP INT, IN Precio_ventP INT, IN MarcaP VARCHAR(45), IN CantidadP INT, IN Codigo_BarrasP VARCHAR(45), IN NombreDepartamento VARCHAR(45), IN EmpresaP VARCHAR(45))
BEGIN
    DECLARE AuxIdDep INT;
    DECLARE AuxIdProv INT;

    IF NOT EXISTS(SELECT Nombre FROM Departamento WHERE Nombre = NombreDepartamento)
    THEN
        SET @RESPUESTA = 'El departamento no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF NOT EXISTS(SELECT Empresa FROM Proveedor WHERE Empresa = EmpresaP)
        THEN
            SET @RESPUESTA = 'El proveedor no existe';
            SELECT @RESPUESTA AS respuesta;
            ELSE IF EXISTS(SELECT Codigo_Barras FROM Producto WHERE Codigo_Barras = Codigo_BarrasP)
                THEN
                    SELECT Id_departamento INTO AuxIdDep FROM Departamento WHERE Nombre = NombreDepartamento;
                    SELECT Id_proveedor INTO AuxIdProv FROM Proveedor WHERE Empresa = EmpresaP;

                    UPDATE Producto SET Nombre = NombreP, Descripcion = DescripcionP, Precio_prov = Precio_provP, Precio_vent = Precio_ventP, Marca = MarcaP, Cantidad = CantidadP, Id_departamento_FK = AuxIdDep, Id_proveedor_FK = AuxIdProv WHERE Codigo_Barras = Codigo_BarrasP;
                    SET @RESPUESTA = 'Cambio realizado con exito';
                    SELECT @RESPUESTA AS respuesta;
                    ELSE 
                        SET @RESPUESTA = 'No existe codigo de barra';
                        SELECT @RESPUESTA AS respuesta;
            END IF;
        END IF;
    END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS P_Inventario;
DELIMITER // 
CREATE PROCEDURE P_Inventario(IN Dato VARCHAR(59))
BEGIN
    IF NOT EXISTS(SELECT Codigo_Barras, CONCAT(Nombre,"  " ,Descripcion) AS Producto, Precio_prov, Precio_vent, Cantidad FROM V_Producto WHERE Empresa = Dato OR Codigo_Barras = Dato)
    THEN
        SET @RESPUESTA = 'El producto no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF EXISTS(SELECT Codigo_Barras, CONCAT(Nombre,"  " ,Descripcion) AS Producto, Precio_prov, Precio_vent, Cantidad FROM V_Producto WHERE Empresa = Dato OR Codigo_Barras = Dato)
        THEN
            SET @RESPUESTA = 'Producto encontrado';
            SELECT @RESPUESTA AS respuesta;
        END IF;
    END IF;
END //
DELIMITER ;

-- Vistas
DROP VIEW  IF EXISTS V_Empleados;
CREATE VIEW V_Empleados AS SELECT Empleado.Nombre, Empleado.Apellido_P, Empleado.Apellido_M, Empleado.Direccion, Empleado.Telefono, Empleado.Usuario, Empleado.Pass, Puesto.Nombre AS Nombre_Puesto, Tienda.Nombre AS Nombre_Tienda FROM Empleado
LEFT JOIN Tienda ON Tienda.Id_tienda = Empleado.Id_tienda_FK
LEFT JOIN Puesto ON Puesto.Id_puesto = Empleado.Id_puesto_FK;

DROP VIEW  IF EXISTS V_Producto;
CREATE VIEW V_Producto AS SELECT Producto.Nombre, Producto.Descripcion, Producto.Precio_prov, Producto.Precio_vent, Producto.Marca, Producto.Cantidad, Producto.Codigo_Barras, Tienda.Nombre AS Tienda, Departamento.Nombre AS Departamento, Proveedor.Empresa AS Empresa FROM Producto
INNER JOIN Tienda ON Tienda.Id_tienda = Producto.Id_tienda_FK
INNER JOIN Departamento ON Departamento.Id_departamento = Producto.Id_departamento_FK
INNER JOIN Proveedor ON Proveedor.Id_proveedor = Producto.Id_proveedor_FK;

-- INSERT-- 
insert into Tienda(Nombre, Direccion, RFC, Ciudad, Telefono)Values("LG", "Forjadores", "abcde", "La paz", "1234567");
insert into Proveedor(Nombre, RFC, Telefono, Empresa, Direccion, Estado, Municipio) Values ("Rodolfo", "R6969", "111111", "Pepsico", "Cardonal", "B.C.S.", "La paz");
INSERT INTO Puesto(Nombre)VALUES("Administrador");
insert into Departamento(Nombre) Values("Salchichoneria"),("Frutas y Verduras"),("Abarrotes"),("Bebidas");
insert into Producto(Nombre, Descripcion, Precio_prov, Precio_vent, Marca, Cantidad, Codigo_Barras, Id_tienda_FK, Id_departamento_FK, Id_proveedor_FK) Values
    ("Pepsi","600ml",13 ,15, "Pepsi",100,"P01",1,4,1),("Vita","600ml", 13, 15,"Pepsi",100,"V01",1,4,1),("Mirinda","1Lt", 22, 25,"Pepsi",100,"M02",1,4,1);
insert into Empleado(Nombre, Apellido_P, Apellido_M, Direccion, Telefono, Usuario, Pass, Id_tienda_FK, Id_puesto_FK)Values("Jair", "Estrada", "Palomino",
"Marquez de leon", "123456", "est", "1", 1, 1);
-- INSERT INTO Login(Id_empleado_FK)VALUES(1);
-- INSERT INTO Venta(FechaHora,Total,Cambio,Pago,Cantidad,Id_empleado_FK) VALUES (NOW(),100,0,100,2,1);
INSERT INTO Venta(Fecha, Hora,Total,Cambio,Pago,Cantidad,Id_empleado_FK) VALUES ("2021-01-07","10:16:31",100,0,100,2,1);



-- SELECT --
SELECT Nombre, Apellido_P FROM Empleado where Usuario = "Jest" AND Pass = "1234";
SELECT * FROM Tienda;
SELECT * FROM Proveedor;
SELECT * FROM Departamento;
SELECT * FROM Producto;
SELECT * FROM Puesto;
SELECT * FROM Empleado;
SELECT * FROM Compra;
SELECT * FROM Login;
SELECT * FROM Venta;
SELECT * FROM CarritoDeCompra;
SELECT * FROM V_Producto;
SELECT * FROM Corte;
SELECT NOW() AS FechaYHora;
SELECT MAX(FechaYHora) AS Fecha_Y_Hora FROM Login;
SELECT sum(Total) as TotalV FROM Venta where FechaHora BETWEEN '2021-04-01 10:57:30' AND '2021-04-01 10:59:41';
SELECT CONCAT(Empleado.Nombre," ",Empleado.Apellido_P, " ", Empleado.Apellido_M) AS Cajero , COUNT(*) AS "Numero de ventas", SUM(Total) as "Total Ventas" FROM Venta 
INNER JOIN Empleado ON Venta.Id_empleado_FK = Empleado.Id_empleado
where FechaHora BETWEEN '2021-04-01 10:57:30' AND '2021-04-01 10:59:41';
SELECT MAX(Id_venta) FROM Venta;
SELECT Codigo_Barras, CONCAT(Nombre,"  " ,Descripcion) AS Producto, Precio_prov, Precio_vent, Cantidad FROM V_Producto WHERE Empresa = "HDR" OR Codigo_Barras = "HDR";
SELECT Codigo_Barras, CONCAT(Nombre,'  ', Descripcion) AS Producto, Precio_prov, Precio_vent, Cantidad FROM Producto;
SELECT Nombre, Descripcion, Precio_vent FROM Producto WHERE Codigo_Barras = "M02";
SELECT * FROM V_Empleados where Nombre = 'Jair Isaac';

-- Llamada al procedimiento!
CALL Carrito("M02",9,1);
CALL ExtraerId();
CALL InsertProducto("CascaNuces", "1lt", 20, 24, "Chata", 4, "HDR", 1, "Abarrotes", "Coca Cola");
-- Id_Departamento, Id_Tienda, Id_Proveedor

Delete from Producto where Id_producto = 6;
