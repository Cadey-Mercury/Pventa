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
    Precio_prov VARCHAR(45) NOT NULL,
    Precio_vent VARCHAR(45) NOT NULL,
    Marca VARCHAR(45) NOT NULL,
    Cantidad VARCHAR(45) NOT NULL,
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

CREATE TABLE Venta(
    Id_venta INT PRIMARY KEY AUTO_INCREMENT,
    FechaHora DATETIME NOT NULL,
    Total INT NOT NULL,
    Cambio VARCHAR(45) NOT NULL,
    Pago INT NOT NULL,
    Cantidad INT NOT NULL,
    Imagen VARCHAR(45),
    Id_empleado_FK INT,
    FOREIGN KEY (Id_empleado_FK) REFERENCES Empleado(Id_empleado)
)ENGINE = INNODB;

CREATE TABLE CarritoDeCompra(
	Id_Carrito INT PRIMARY KEY AUTO_INCREMENT,
	Nombre_Completo VARCHAR(45) NOT NULL,
	Cantidad INT NOT NULL,
	Total INT NOT NULL,
	Id_Aux_Venta INT NOT NULL
)ENGINE = INNODB;

CREATE TABLE Compra(
    Id_compra INT PRIMARY KEY AUTO_INCREMENT,
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


insert into Tienda(Nombre, Direccion, RFC, Ciudad, Telefono)Values("LG", "Forjadores", "abcde", "La paz", "1234567");
insert into Proveedor(Nombre, RFC, Telefono, Empresa, Direccion, Estado, Municipio) Values ("Rodolfo", "R6969", "111111", "Pepsico", "Cardonal", "B.C.S.", "La paz");
INSERT INTO Puesto(Nombre)VALUES("Administrador");
insert into Departamento(Nombre) Values("Salchichoneria"),("Frutas y Verduras"),("Abarrotes"),("Bebidas");
insert into Producto(Nombre, Descripcion, Precio_prov, Precio_vent, Marca, Cantidad, Codigo_Barras, Id_tienda_FK, Id_departamento_FK, Id_proveedor_FK) Values
    ("Pepsi","600ml","13","15","Pepsi","10","P01",1,4,1),("Vita","600ml","13","15","Pepsi","5","V01",1,4,1),("Mirinda","1Lt","22","25","Pepsi","8","M02",1,4,1);
insert into Empleado(Nombre, Apellido_P, Apellido_M, Direccion, Telefono, Usuario, Pass, Id_tienda_FK, Id_puesto_FK)Values("Jair", "Estrada", "Palomino",
 "Marquez de leon", "123456", "Jest", "1234", 1, 1);
INSERT INTO Login(Id_empleado_FK)VALUES(1);
SELECT Nombre, Apellido_P FROM Empleado where Usuario = "Jest" AND Pass = "1234";
SELECT * FROM Tienda;
SELECT * FROM Proveedor;
SELECT * FROM Departamento;
SELECT * FROM Producto;
SELECT * FROM Puesto;
SELECT * FROM Empleado;
SELECT * FROM Login;

SELECT Nombre, Descripcion, Precio_vent FROM Producto WHERE Codigo_Barras = "M02";