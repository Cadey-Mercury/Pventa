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
    FOREIGN KEY (Id_empleado_FK) REFERENCES Empleado(Id_empleado)
)ENGINE = INNODB;

-- drop table if exists Venta;
CREATE TABLE Venta(
    Id_venta INT PRIMARY KEY AUTO_INCREMENT,
    FechaHora DATETIME NOT NULL,
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
    Id_producto_FK INT,
    FOREIGN KEY (Id_producto_FK) REFERENCES Producto(Id_producto)
)ENGINE = INNODB;

CREATE TABLE Corte(
    Id_corte INT PRIMARY KEY AUTO_INCREMENT,
    FechaHora DATETIME NOT NULL,
    Id_empleado_FK INT,
    Id_producto_FK INT,
    FOREIGN KEY (Id_empleado_FK) REFERENCES Empleado(Id_empleado),
    FOREIGN KEY (Id_producto_FK) REFERENCES Producto(Id_producto)
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
			SET @RESPUESTA = 'Producto encontrado';
			SELECT @RESPUESTA AS respuesta;
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
CREATE PROCEDURE InsertProducto( IN NombreP VARCHAR(45), IN DescripcionP VARCHAR(45), IN Precio_provP INT, IN Precio_ventP INT, IN MarcaP VARCHAR(45), IN CantidadP INT, IN Codigo_BarrasP VARCHAR(45), IN Id_tienda_FKP INT, IN NombreDepartamento VARCHAR(45), IN NombreProveedor VARCHAR(45))
BEGIN
    DECLARE AuxIdDep INT;
    DECLARE AuxIdProv INT;

    IF NOT EXISTS(SELECT Nombre FROM Departamento WHERE Nombre = NombreDepartamento)
    THEN
        SET @RESPUESTA = 'El departamento no existe';
        SELECT @RESPUESTA AS respuesta;
    ELSE IF NOT EXISTS(SELECT Nombre FROM Proveedor WHERE Nombre = NombreProveedor)
        THEN
            SET @RESPUESTA = 'El proveedor no existe';
            SELECT @RESPUESTA AS respuesta;
            ELSE IF EXISTS(SELECT Nombre FROM Proveedor WHERE Nombre = NombreProveedor)
                THEN
                    SELECT Id_departamento INTO AuxIdDep FROM Departamento WHERE Nombre = NombreDepartamento;
                    SELECT Id_proveedor INTO AuxIdProv FROM Proveedor WHERE Nombre = NombreProveedor;
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

-- INSERT-- 
insert into Tienda(Nombre, Direccion, RFC, Ciudad, Telefono)Values("LG", "Forjadores", "abcde", "La paz", "1234567");
insert into Proveedor(Nombre, RFC, Telefono, Empresa, Direccion, Estado, Municipio) Values ("Rodolfo", "R6969", "111111", "Pepsico", "Cardonal", "B.C.S.", "La paz");
INSERT INTO Puesto(Nombre)VALUES("Administrador");
insert into Departamento(Nombre) Values("Salchichoneria"),("Frutas y Verduras"),("Abarrotes"),("Bebidas");
insert into Producto(Nombre, Descripcion, Precio_prov, Precio_vent, Marca, Cantidad, Codigo_Barras, Id_tienda_FK, Id_departamento_FK, Id_proveedor_FK) Values
    ("Pepsi","600ml",13 ,15, "Pepsi",10,"P01",1,4,1),("Vita","600ml", 13, 15,"Pepsi",5,"V01",1,4,1),("Mirinda","1Lt", 22, 25,"Pepsi",8,"M02",1,4,1);
insert into Empleado(Nombre, Apellido_P, Apellido_M, Direccion, Telefono, Usuario, Pass, Id_tienda_FK, Id_puesto_FK)Values("Jair", "Estrada", "Palomino",
 "Marquez de leon", "123456", "Jest", "1234", 1, 1);
INSERT INTO Login(Id_empleado_FK)VALUES(1);
-- INSERT INTO Venta(FechaHora,Total,Cambio,Pago,Cantidad,Id_empleado_FK) VALUES (NOW(),100,0,100,2,1);



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
SELECT MAX(Id_venta) FROM Venta;
SELECT Nombre, Descripcion, Precio_vent FROM Producto WHERE Codigo_Barras = "M02";

-- Llamada al procedimiento!
CALL Carrito("M02",8,2);
CALL ExtraerId();
CALL InsertProducto("Pepsi Ligth", "600ml", 13, 15, "Pepsi", 12, "PL01", 1, "Bebidas", "Rodolfo");
-- Id_Departamento, Id_Tienda, Id_Proveedor