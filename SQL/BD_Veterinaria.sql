-- Creación de la base de Datos

Drop database if exists db_Veterinaria;
create database db_Veterinaria;
use db_Veterinaria;

-- Declaración de las Tablas 

Drop table if exists Persona;
CREATE TABLE Persona (
    cedula INT NOT NULL UNIQUE,
    Primer_nombre VARCHAR(30) NOT NULL,
    Segundo_nombre VARCHAR(30) NULL,
    Primer_Apellido VARCHAR(30) NOT NULL,
    Segundo_Apellido VARCHAR(30) NOT NULL,
    edad INT NOT NULL,
    IdRol INT NOT NULL,
    PRIMARY KEY (cedula)
);

Drop table if exists Rol;
CREATE TABLE Rol (
    IdRol INT NOT NULL AUTO_INCREMENT,
    NombreRol VARCHAR(20) NOT NULL,
    PRIMARY KEY (IdRol)
);

Drop table if exists Mascota;
CREATE TABLE Mascota (
    IdMascota INT NOT NULL UNIQUE AUTO_INCREMENT,
    Nombre VARCHAR(20) NOT NULL,
    Edad INT NOT NULL,
    Especie VARCHAR(20) NOT NULL,
    Raza VARCHAR(20) NOT NULL,
    Color VARCHAR(20) NOT NULL,
    Tamaño VARCHAR(10) NOT NULL,
    Peso VARCHAR(10) NOT NULL,
    IdDuenio INT NOT NULL,
    IdHistoria INT NOT NULL,
    PRIMARY KEY (IdMascota)
);

Drop table if exists Historia_Clinica;
create table Historia_Clinica(
	IdHistoria INT NOT NULL UNIQUE AUTO_INCREMENT,
    IdMascota INT NOT NULL,
    primary key (IdHistoria)
);

Drop table if exists Registro_Historia_Clinica;
CREATE TABLE Registro_Historia_Clinica (
    IdRegistro INT NOT NULL UNIQUE AUTO_INCREMENT,
    Fecha DATE NOT NULL,
    Motivo VARCHAR(200) NOT NULL,
    Sintomatologia TINYTEXT NOT NULL,
    Diagnostico TEXT NOT NULL,
    Procedimiento TEXT NULL,
    Medicamento VARCHAR(100) NULL,
    Dosis VARCHAR(50) NULL,
    Vacuna VARCHAR(100) NULL,
    MedicamentosAlergia VARCHAR(100) NOT NULL,
    DetalleProcedimiento TEXT NULL,
    Anulacion BOOLEAN NOT NULL DEFAULT FALSE,
    IdHistoria INT NOT NULL,
    IdOrden INT NULL,
    IdVeterinario INT NOT NULL,
    PRIMARY KEY (IdRegistro)
);

Drop table if exists Orden;
create table Orden(
	IdOrden INT NOT NULL UNIQUE AUTO_INCREMENT,
    IdMascota INT NOT NULL,
    IdVeterinario INT NOT NULL,
    primary key (IdOrden)
);

Drop table if exists Factura;
CREATE TABLE Factura (
    IdFactura INT NOT NULL UNIQUE AUTO_INCREMENT,
    Producto VARCHAR(50) NOT NULL,
    valor FLOAT NOT NULL,
    cantidad TINYINT NOT NULL,
    fecha DATE NOT NULL,
    IdOrden INT NULL,
    IdDuenio INT NOT NULL,
    PRIMARY KEY (IdFactura)
);


/* Declaración de Constraints*/

alter table Persona add foreign key (Idrol) references Rol(IdRol);

alter table Mascota add(
	foreign key (IdDuenio) references Persona(cedula),
	foreign key (IdHistoria) references Historia_Clinica(IdHistoria)
);

alter table Historia_Clinica add foreign key(IdMascota) references Mascota(IdMascota);

alter table Registro_Historia_Clinica add(
	foreign key (IdHistoria) references Historia_Clinica(IdHistoria),
    foreign key (IdOrden) references Orden(IdOrden),
	foreign key (IdVeterinario) references Persona(Cedula)
);

alter table Orden add (
	foreign key (IdMascota) references Mascota(IdMascota),
    foreign key (IdVeterinario) references Persona(Cedula)
);

alter table Factura add (
	foreign key (IdOrden) references Orden(IdOrden),
    foreign key (IdDuenio) references Persona(Cedula)
);

-- Inserción de los roles

insert into rol (nombreRol) values
("Administrador"),
("Veterinario"),
("Vendedor"),
("Dueño");


-- Creación de Roles 
Drop role if exists 'Admin', 'Veterinario', 'Vendedor', 'Duenio';
create role 'Admin', 'Veterinario', 'Vendedor', 'Duenio';

GRANT SELECT, INSERT, UPDATE, DELETE ON db_veterinaria.* TO 'Admin';

GRANT SELECT, INSERT, UPDATE ON db_veterinaria.historia_clinica TO 'Veterinario';
GRANT SELECT, INSERT, UPDATE ON db_veterinaria.Mascota TO 'Veterinario';
GRANT SELECT, INSERT, UPDATE ON db_veterinaria.registro_historia_clinica TO 'Veterinario';
GRANT SELECT, INSERT, UPDATE ON db_veterinaria.Orden TO 'Veterinario';

GRANT SELECT, INSERT, UPDATE ON db_veterinaria.Factura TO 'Vendedor';
GRANT SELECT ON db_veterinaria.Orden TO 'Vendedor';

GRANT SELECT, INSERT, UPDATE ON db_veterinaria.mascota TO 'Duenio';
GRANT SELECT ON db_veterinaria.historia_clinica TO 'Duenio';
GRANT SELECT ON db_veterinaria.orden TO 'Duenio';
GRANT SELECT ON db_veterinaria.registro_historia_clinica TO 'Duenio';

-- creación de los Usuarios

Drop user if exists 'User_Administrador'@'localhost', 'User_Veterinario'@'localhost', 'User_Vendedor'@'localhost', 'User_Duenio'@'localhost';
CREATE USER 'User_Administrador'@'localhost' IDENTIFIED BY 'admin123';
CREATE USER 'User_Veterinario'@'localhost' IDENTIFIED BY 'veterinario123';
CREATE USER 'User_Vendedor'@'localhost' IDENTIFIED BY 'vendedor123';
CREATE USER 'User_Duenio'@'localhost' IDENTIFIED BY 'duenio123';

-- Asignar Roles

GRANT 'Admin' TO 'User_Administrador'@'localhost';
GRANT 'Veterinario' TO 'User_Veterinario'@'localhost';
GRANT 'Vendedor' TO 'User_Vendedor'@'localhost';
GRANT 'Duenio' TO 'User_Duenio'@'localhost';

-- select * From mysql.user;

/* Prosedimientos almacenados CRUD */

--  CRUD Persona

Drop procedure if exists Create_Persona;
DELIMITER &&  
CREATE PROCEDURE Create_Persona (in cedula INT,
    in Primer_nombre VARCHAR(30) ,
    in Segundo_nombre VARCHAR(30),
    in Primer_Apellido VARCHAR(30),
    in Segundo_Apellido VARCHAR(30),
    in edad INT,
    in IdRol INT)
BEGIN    
	insert into Persona values (cedula,Primer_nombre,Segundo_nombre,Primer_Apellido,Segundo_Apellido,edad,IdRol);
END &&  
DELIMITER ;   

Drop procedure if exists Actualizar_Persona;
DELIMITER &&  
CREATE PROCEDURE Actualizar_Persona (in id INT,
    in P_nombre VARCHAR(30) ,
    in S_nombre VARCHAR(30),
    in P_Apellido VARCHAR(30),
    in S_Apellido VARCHAR(30),
    in P_edad INT,
    in Rol INT)
BEGIN    
	 update Persona set Primer_nombre = P_nombre , Segundo_nombre = S_nombre,
     Primer_Apellido = P_Apellido, Segundo_Apellido = S_Apellido,edad = P_edad, IdRol = Rol 
     where cedula=id;
END &&  
DELIMITER ;

Drop procedure if exists Consultar_Persona;
DELIMITER &&  
CREATE PROCEDURE Consultar_Persona (in id INT)
BEGIN    
	 select * from Persona where cedula=id;
END &&  
DELIMITER ;

Drop procedure if exists Eliminar_Persona;
DELIMITER &&  
CREATE PROCEDURE Eliminar_Persona (in id INT)
BEGIN    
	 delete from Persona where cedula=id;
END &&  
DELIMITER ;

-- CRUD Mascota

Drop procedure if exists Crear_Mascota;
DELIMITER &&  
CREATE PROCEDURE Crear_Mascota (in Nombre VARCHAR(20),
    in Edad INT,
    in Especie VARCHAR(20),
    in Raza VARCHAR(20),
    in Color VARCHAR(20),
    in Tamaño VARCHAR(10),
    in Peso VARCHAR(10),
    in IdDuenio INT,
    in IdHistoria INT)
BEGIN    
	 insert into Mascota (Nombre,Edad,Especie,Raza,Color,Tamaño,Peso,IdDuenio,IdHistoria) 
     values (Nombre,Edad,Especie,Raza,Color,Tamaño,Peso,IdDuenio,IdHistoria);
END &&  
DELIMITER ;

Drop procedure if exists Actualizar_Mascota;
DELIMITER &&  
CREATE PROCEDURE Actualizar_Mascota (in ID int,
	in P_Nombre VARCHAR(20),
    in P_Edad INT,
    in P_Especie VARCHAR(20),
    in P_Raza VARCHAR(20),
    in P_Color VARCHAR(20),
    in P_Tamaño VARCHAR(10),
    in P_Peso VARCHAR(10))
BEGIN    
	 update Mascota set Nombre = P_Nombre, Edad = P_Edad, Especie = P_Especie, Raza = P_Raza,
     Color = P_Color, Tamaño = P_Tamaño, Peso = P_Peso where IdMascota = ID;
END &&  
DELIMITER ;

Drop procedure if exists Consultar_Mascota;
DELIMITER &&  
CREATE PROCEDURE Consultar_Mascota (in id INT)
BEGIN    
	 select * from Mascota where IdMascota=id;
END &&  
DELIMITER ;

Drop procedure if exists Eliminar_Mascota;
DELIMITER &&  
CREATE PROCEDURE Eliminar_Mascota (in id INT)
BEGIN    
	 delete from Mascota where IdMascota=id;
END &&  
DELIMITER ;

-- DRUD historia_clinica

Drop procedure if exists Crear_H_clinica;
DELIMITER &&  
CREATE PROCEDURE Crear_H_clinica (in idMascota INT)
BEGIN    
	 insert into historia_clinica (idMascota) values (idMascota);
END &&  
DELIMITER ;

Drop procedure if exists Actualizar_H_clinica;
DELIMITER &&  
CREATE PROCEDURE Actualizar_H_clinica (in id INT, in P_idMascota INT)
BEGIN    
	 update historia_clinica set IdMascota = P_idMascota where IdHistoria = id;
END &&  
DELIMITER ;

Drop procedure if exists Consultar_H_clinica;
DELIMITER &&  
CREATE PROCEDURE Consultar_H_clinica (in id INT)
BEGIN    
	 select * from historia_clinica where IdHistoria = id;
END &&  
DELIMITER ;

Drop procedure if exists Eliminar_H_clinica;
DELIMITER &&  
CREATE PROCEDURE Eliminar_H_clinica (in id INT)
BEGIN    
	 delete from historia_clinica where IdHistoria = id;
END &&  
DELIMITER ;

-- CRUD registro_historia_clinica

Drop procedure if exists Crear_Registro_HC;
DELIMITER &&  
CREATE PROCEDURE Crear_Registro_HC (
    in Fecha DATE,
    in Motivo VARCHAR(200),
    in Sintomatologia TINYTEXT ,
    in Diagnostico TEXT,
    in Procedimiento TEXT,
    in Medicamento VARCHAR(100),
    in Dosis VARCHAR(50),
    in Vacuna VARCHAR(100),
    in MedicamentosAlergia VARCHAR(100),
    in DetalleProcedimiento TEXT ,
    in IdHistoria INT,
    in IdOrden INT,
    in IdVeterinario INT)
BEGIN    
	 insert into registro_historia_clinica 
     (Fecha, Motivo, Sintomatologia, Diagnostico, Procedimiento, Medicamento, Dosis,
     Vacuna, MedicamentosAlergia, DetalleProcedimiento, IdHistoria, IdOrden, IdVeterinario)
     values(Fecha, Motivo, Sintomatologia, Diagnostico, Procedimiento, Medicamento, Dosis,
     Vacuna, MedicamentosAlergia, DetalleProcedimiento, IdHistoria, IdOrden, IdVeterinario);
END &&  

Drop procedure if exists Actualizar_Registro_HC;
DELIMITER &&  
CREATE PROCEDURE Actualizar_Registro_HC (
	in id INT,
    in P_Fecha DATE,
    in P_Motivo VARCHAR(200),
    in P_Sintomatologia TINYTEXT ,
    in P_Diagnostico TEXT,
    in P_P_Procedimiento TEXT,
    in P_Medicamento VARCHAR(100),
    in P_Dosis VARCHAR(50),
    in P_Vacuna VARCHAR(100),
    in P_MedicamentosAlergia VARCHAR(100),
    in P_DetalleProcedimiento TEXT ,
    in P_IdHistoria INT,
    in P_IdOrden INT,
    in P_IdVeterinario INT)
BEGIN    
	 update registro_historia_clinica set Fecha = P_Fecha, Motivo = P_Motivo, Sintomatologia = P_Sintomatologia, 
     Diagnostico = P_Diagnostico ,Procedimiento = P_Procedimiento, Medicamento = p_Medicamento, Dosis = P_Dosis, 
     Vacuna = P_Vacuna, MedicamentosAlergia = P_MedicamentosAlergia, DetalleProcedimiento = P_DetalleProcedimiento, 
     Anulacion = P_Anulacion, IdHistoria = P_IdHistoria,IdOrden = P_IdOrden, IdVeterinario = P_IdVeterinario where IdRegistro = id;
END &&

Drop procedure if exists Consultar_Registro_HC;
DELIMITER &&  
CREATE PROCEDURE Consultar_Registro_HC (in id INT)
BEGIN    
	 select * from registro_historia_clinica where IdRegistro = id;
END &&  
DELIMITER ;

Drop procedure if exists Eliminar_Registro_HC;
DELIMITER &&  
CREATE PROCEDURE Eliminar_Registro_HC (in id INT)
BEGIN    
	 delete from registro_historia_clinica where IdRegistro = id;
END &&  
DELIMITER ;

-- CRUD Orden

Drop procedure if exists Crear_Orden;
DELIMITER &&  
CREATE PROCEDURE Crear_Orden (in IdMascota INT, in IdVeterinario INT)
BEGIN    
	 insert into Orden (IdMascota,IdVeterinario) values (IdMascota,IdVeterinario);
END &&  
DELIMITER ;

Drop procedure if exists Actualizar_Orden;
DELIMITER &&  
CREATE PROCEDURE Actualizar_Orden (in id INT, in P_IdMascota INT, in P_IdVeterinario INT)
BEGIN    
	 insert into Orden (IdMascota,IdVeterinario) values (IdMascota,IdVeterinario);
     update Orden set IdMascota = P_IdMascota, IdVeterinario = P_IdVeterinario where IdOrden = id;
END &&  
DELIMITER ;

Drop procedure if exists Consultar_Orden;
DELIMITER &&  
CREATE PROCEDURE Consultar_Orden(in id INT)
BEGIN    
	 select * from Orden where IdOrden = id;
END &&  
DELIMITER ;

Drop procedure if exists Eliminar_Orden;
DELIMITER &&  
CREATE PROCEDURE Eliminar_Orden (in id INT)
BEGIN    
	 delete from Orden where IdOrden = id;
END &&  
DELIMITER ;

-- crud Factura

Drop procedure if exists Crear_Factura;
DELIMITER &&  
CREATE PROCEDURE Crear_Factura(in Producto VARCHAR(50),
    in valor FLOAT,
    in cantidad TINYINT,
    in fecha DATE,
    in IdOrden INT,
    in IdDuenio INT)
BEGIN    
	 insert into factura (Producto,valor,cantidad,fecha,IdOrden,IdDuenio) 
     values (Producto,valor,cantidad,fecha,IdOrden,IdDuenio);
END &&  
DELIMITER ;

Drop procedure if exists Actualizar_Factura;
DELIMITER &&  
CREATE PROCEDURE Actualizar_Factura(
	in id int,
    in P_Producto VARCHAR(50),
    in P_valor FLOAT,
    in P_cantidad TINYINT,
    in P_fecha DATE,
    in P_IdOrden INT,
    in P_IdDuenio INT)
BEGIN    
	 update Factura set Producto = P_Producto, valor = P_valor, cantidad = P_cantidad, 
     fecha = P_fecha, IdOrden = P_IdOrden, IdDuenio = P_IdDuenio where IdFactura = id;
END &&  
DELIMITER ;

Drop procedure if exists Consultar_Factura;
DELIMITER &&  
CREATE PROCEDURE Consultar_Factura(in id INT)
BEGIN    
	 select * from factura where IdFactura = id;
END &&  
DELIMITER ;

Drop procedure if exists Eliminar_Factura;
DELIMITER &&  
CREATE PROCEDURE Eliminar_Factura (in id INT)
BEGIN    
	 delete from factura where IdFactura = id;
END &&  
DELIMITER ;