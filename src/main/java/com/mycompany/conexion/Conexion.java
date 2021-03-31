
package com.mycompany.conexion;

import com.mycompany.pventa.LogIn;
import com.mycompany.pventa.Main;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;
import javax.swing.JTextField;
import javax.swing.table.DefaultTableModel;


public class Conexion {
    //Variables para la conexion a la BD
    private static Connection conn;
    private static final String driver = "com.mysql.cj.jdbc.Driver";
    private static final String User = "root";
    private static final String Password = "";
    private static final String url = "jdbc:mysql://localhost:3306/PVenta";
    
    private static Statement stmt;
    PreparedStatement ps;
    private static ResultSet rs;
    public static String Id_Empleado = "";
    public static String Id_Departamento = "";
    public static String Id_Tienda = "";
    public static String Id_Proveedor = "";
    
    
    public Conexion() throws SQLException{
        
        //Conexion a la BD
        
        conn = null;
        
        try {
            Class.forName(driver);
            conn = DriverManager.getConnection(url, User, Password);
            if(conn != null){
                System.out.print("Conexion establecida...");
            }
        } catch (ClassNotFoundException  | SQLException e) {
           
            System.out.println("Error al conectar..." + e);
        }
    }
    
    public Connection getConnection(){
        //Respuesta de la BD
        return conn;
    }
    
    public String LogIn(String Usuario, String Contraseña){
        
        //Verificacion del usuario que inicia sesion
        
       String Dato = null;
        
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Id_empleado, Nombre, Apellido_P, Usuario, Pass FROM Empleado WHERE Usuario ='" + Usuario + "' AND Pass ='" + Contraseña + "' ");
            rs.next();
            do{
               
                
                if(rs.getString("Usuario").equals(Usuario) && rs.getString("Pass").equals(Contraseña)){
                    Dato = rs.getString("Nombre") + " " + rs.getString("Apellido_P");
                    Id_Empleado = rs.getString("Id_empleado");
                }
                
            }while(rs.next());
            
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "Error, intente nuevamente... ");
        }
        return Dato;
    }
    
    public DefaultTableModel BuscarProducto(String Codigo, int Cantidad){
        
        DefaultTableModel modelo = new DefaultTableModel();
        String Respuesta = "";
        int Id_Carrito = 0;
        try {
            
            CallableStatement cst1 = conn.prepareCall("{CALL ExtraerId()}");
            rs = cst1.executeQuery();
            
            while(rs.next()){
                Id_Carrito = Integer.parseInt(rs.getString(1).toString()) + 1;
            }
           
            CallableStatement cst = conn.prepareCall("{CALL Carrito(?,?,?)}");
            cst.setString(1, Codigo);
            cst.setInt(2, Cantidad);
            cst.setInt(3, Id_Carrito);
            rs = cst.executeQuery();
            
            while(rs.next()){
                Respuesta = rs.getString(1).toString();
            }
            
            if(Respuesta.equals("El producto no existe")){
                JOptionPane.showMessageDialog(null, Respuesta);
            }
            if(Respuesta.equals("No hay suficientes productos")){
                JOptionPane.showMessageDialog(null, Respuesta);
            }
            
            
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Nombre_Completo, Cantidad, Precio, Total FROM CarritoDeCompra WHERE Id_Aux_Venta ='" + Id_Carrito + "'");
            rs.next();
            
            ResultSetMetaData rsMd = rs.getMetaData();
            int cantidadColumnas = rsMd.getColumnCount();
            
            modelo.addColumn("Nombre");
            modelo.addColumn("Cantidad");
            modelo.addColumn("Precio");
            modelo.addColumn("Total");
        
        
            do{
                Object[] filas = new Object[cantidadColumnas];
                
                for(int i = 0; i < cantidadColumnas; i++){
                    
                    filas[i] = rs.getObject(i + 1);
                    
                }
                
                modelo.addRow(filas);
                
            }while(rs.next());
            
        } catch (SQLException ex) {
            
            JOptionPane.showMessageDialog(null, "No hay productos agregados todavia");
        }
        
        return modelo;
    }
    
    public void InsertarVenta(int TotalVenta, int Cambio, int Pago, int Cantidad, int Id_Empleado){
        
        try {
            
            ps = conn.prepareStatement("INSERT INTO Venta(FechaHora,Total,Cambio,Pago,Cantidad,Id_empleado_FK) VALUES (NOW(), ?, ?, ?, ?, ?)");
            ps.setInt(1, TotalVenta);  
            ps.setInt(2, Cambio);  
            ps.setInt(3, Pago);  
            ps.setInt(4, Cantidad);
            ps.setInt(5, Id_Empleado);
            ps.executeUpdate();
            JOptionPane.showMessageDialog(null, "Regrese pronto!");
            
        } catch (SQLException ex) {
            
            JOptionPane.showMessageDialog(null, "Error intente de nuevo");
        }
    }
    
    public DefaultTableModel LimpiarJTable(){
        DefaultTableModel modelo = new DefaultTableModel();
        modelo.addColumn("Nombre");
        modelo.addColumn("Cantidad");
        modelo.addColumn("Precio");
        modelo.addColumn("Total");
        modelo.setRowCount(0);
        
       return modelo; 
    }
    
    public String ExtraerDepartamento(){
        
        String Dato = null;
        
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Id_departamento, Nombre FROM Departamento");
            rs.next();
            do{
               
                Dato = rs.getString("Nombre");
                
            }while(rs.next());
            
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "Error, intente nuevamente... ");
        }
        
        return Dato;
        
    }
    
    public void InsertarEmpleados(String Nombre, String Apellido_P, String Apellido_M, int Telefono, String Puesto, String Direccion, String Usuario, String Contraseña, String Tienda){
        
        String Respuesta = "";
        
        try {
            
            CallableStatement cst = conn.prepareCall("{CALL InsertEmpleado(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
            cst.setString(1, Nombre);
            cst.setString(2, Apellido_P);
            cst.setString(3, Apellido_M);
            cst.setString(4, Direccion);
            cst.setInt(5, Telefono);
            cst.setString(6, Usuario);
            cst.setString(7, Contraseña);
            cst.setString(8, Tienda);
            cst.setString(9, Puesto);
            rs = cst.executeQuery();
            
            while(rs.next()){
                
                Respuesta = rs.getString(1).toString();
                
            }
            
            JOptionPane.showMessageDialog(null, "Mensaje: " + Respuesta);
            
        } catch (SQLException ex) {
            
            JOptionPane.showMessageDialog(null, "Mensaje: " + ex);
        }
    }
    
    public String[] BuscarEmpleadoNombre(String Nombre){
        
        String[] txt = new String[8];
        
        try{
            
            stmt = conn.createStatement();
            
            rs = stmt.executeQuery("SELECT Apellido_P, Apellido_M, Direccion, Telefono, Usuario, pass, Nombre_Tienda, Nombre_Puesto FROM V_Empleados WHERE Nombre ='" + Nombre + "'");
            
            rs.next();
            
            do{
                
                for(int i = 0; i < 8; i++){
                    
                    txt[i] = rs.getString(i + 1);
                    
                }
                
            }while(rs.next());
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!" + ex);
        }
        
        return txt;
    }
    
    public String[] BuscarEmpleadoUsuario(String Usuario){
        
        String[] txt = new String[8];
        
        try{
            
            stmt = conn.createStatement();
            
            rs = stmt.executeQuery("SELECT Nombre, Apellido_P, Apellido_M, Direccion, Telefono, pass,Nombre_Tienda, Nombre_Puesto FROM V_Empleados WHERE Usuario ='" + Usuario + "'");
            
            rs.next();
            
            do{
                
                for(int i = 0; i < 8; i++){
                    
                    txt[i] = rs.getString(i + 1);
                    
                }
                
            }while(rs.next());
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!");
        }
        
        return txt;
    }
    
    public void InsertarProveedor(String Proveedor, String Rfc, String Tel, String Empresa, String Direccion, String Estado, String Municipio){
        
        try {
            
            ps = conn.prepareStatement("INSERT INTO Proveedor(Nombre, RFC, Telefono, Empresa, Direccion, Estado, Municipio)VALUES(?, ?, ?, ?, ?, ?, ?)");
            ps.setString(1, Proveedor);  
            ps.setString(2, Rfc);  
            ps.setString(3, Tel);  
            ps.setString(4, Empresa);
            ps.setString(5, Direccion);
            ps.setString(6, Estado);
            ps.setString(7, Municipio);
            ps.executeUpdate();
            JOptionPane.showMessageDialog(null, "Registro completado!");
            
        } catch (SQLException ex) {
            
            JOptionPane.showMessageDialog(null, "Error intente de nuevo" + ex);
        }
    }
    
    public String[] BuscarPorProveedor(String Proveedor){
        
        String[] txt = new String[6];
        
        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT RFC, Telefono, Empresa, Direccion, Estado, Municipio FROM Proveedor WHERE Nombre ='" + Proveedor + "'");
            rs.next();
            
            do{
                for(int i = 0; i < 6; i++){
                    txt[i] = rs.getString(i + 1);
                }
                
            }while(rs.next());
            
        }catch(SQLException ex){
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!");
        }
        
        return txt;
    }
    
    public String[] BuscarPorRfc(String Rfc){
        
        String[] txt = new String[6];
        
        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Nombre, Telefono, Empresa, Direccion, Estado, Municipio FROM Proveedor WHERE RFC ='" + Rfc + "'" );
            rs.next();
            
            do{
                for(int i = 0; i < 6; i++){
                    txt[i] = rs.getString(i + 1);
                }
                
            }while(rs.next());
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!");
            
        }
        
        return txt;
    }
    
    public void ActualizarPorProveedorAndRfc(String Nombre, String Rfc, String Tel, String Empresa, String Direccion, String Estado, String Municipio, boolean FlagProveedor, boolean FlagRfc){
        
        try{
           
           if(FlagProveedor){
               
               ps = conn.prepareStatement("UPDATE Proveedor SET RFC=?, Telefono=?, Empresa=?, Direccion=?, Estado=?, Municipio=? WHERE Nombre = ?");
               ps.setString(1, Rfc);
               ps.setString(2, Tel);
               ps.setString(3, Empresa);
               ps.setString(4, Direccion);
               ps.setString(5, Estado);
               ps.setString(6, Municipio);
               ps.setString(7, Nombre);
               ps.executeUpdate();
               JOptionPane.showMessageDialog(null, "Se ha actualizado correctamente!");
               
           }else{
               
               if(FlagRfc){
                   
                   ps = conn.prepareStatement("UPDATE Proveedor SET Nombre=?, Telefono=?, Empresa=?, Direccion=?, Estado=?, Municipio=? WHERE RFC = ?");
                   ps.setString(1, Nombre);
                   ps.setString(2, Tel);
                   ps.setString(3, Empresa);
                   ps.setString(4, Direccion);
                   ps.setString(5, Estado);
                   ps.setString(6, Municipio);
                   ps.setString(7, Rfc);
                   ps.executeUpdate();
                   JOptionPane.showMessageDialog(null, "Se ha actualizado correctamente!");
                   
               }else{
                   JOptionPane.showMessageDialog(null, "Le faltan datos!");
               }
           }
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!");
            
        }
    }
    
    public DefaultTableModel BuscarDepartamento(){
        
        DefaultTableModel modelo = new DefaultTableModel();
        String Respuesta = "";
        
        try {
            
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Nombre FROM Departamento");
            rs.next();
            
            ResultSetMetaData rsMd = rs.getMetaData();
            int cantidadColumnas = rsMd.getColumnCount();
            
            modelo.addColumn("Nombre");
        
        
            do{
                Object[] filas = new Object[cantidadColumnas];
                
                for(int i = 0; i < cantidadColumnas; i++){
                    
                    filas[i] = rs.getObject(i + 1);
                    
                }
                
                modelo.addRow(filas);
                
            }while(rs.next());
            
        } catch (SQLException ex) {
            
            JOptionPane.showMessageDialog(null, "No hay departamento" + ex);
        }
        
        return modelo;
    }
    
    public void ActualziarDepartamento(String Actual, String Nuevo){
        
        try{
            
            ps = conn.prepareStatement("UPDATE Departamento SET Nombre=? WHERE Nombre=?");
            ps.setString(1, Nuevo);
            ps.setString(2, Actual);
               
            ps.executeUpdate();
            JOptionPane.showMessageDialog(null, "Se ha actualizado correctamente!");
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!");
            
        }
    }
    
    public void ActualizarEmpleadoPorNombreAndUsuario(String Nombre, String Apellido_P, String Apellido_M, int Telefono, String Puesto, String Direccion, String Usuario, String Contraseña, String Tienda, boolean FlagNombre, boolean FlagUsuario){
        
        String Respuesta = "";
        
        try {
            
            if(FlagNombre){
                CallableStatement cst = conn.prepareCall("{CALL ActualizarUsuarioNombre(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                cst.setString(1, Nombre);
                cst.setString(2, Apellido_P);
                cst.setString(3, Apellido_M);
                cst.setString(4, Direccion);
                cst.setInt(5, Telefono);
                cst.setString(6, Usuario);
                cst.setString(7, Contraseña);
                cst.setString(8, Tienda);
                cst.setString(9, Puesto);
                rs = cst.executeQuery();
            
                while(rs.next()){
                
                    Respuesta = rs.getString(1).toString();
                
                }
            
                JOptionPane.showMessageDialog(null, "Mensaje: " + Respuesta);
                
            }else{
                
                if(FlagUsuario){
                    
                    CallableStatement cst = conn.prepareCall("{CALL ActualizarUsuario(?, ?, ?, ?, ?, ?, ?, ?, ?)}");
                    cst.setString(1, Nombre);
                    cst.setString(2, Apellido_P);
                    cst.setString(3, Apellido_M);
                    cst.setString(4, Direccion);
                    cst.setInt(5, Telefono);
                    cst.setString(6, Usuario);
                    cst.setString(7, Contraseña);
                    cst.setString(8, Tienda);
                    cst.setString(9, Puesto);
                    rs = cst.executeQuery();
            
                    while(rs.next()){
                
                        Respuesta = rs.getString(1).toString();
                
                    }
            
                    JOptionPane.showMessageDialog(null, "Mensaje: " + Respuesta);
                    
                }else{
                    JOptionPane.showMessageDialog(null, "Le faltan datos!");
                }
            }
            
        } catch (SQLException ex) {
            
            JOptionPane.showMessageDialog(null, "Mensaje: " + ex);
        }
    }
    
    public String[] SelectDepartamentos(int Tamaño){
        
        
        String[] txt = new String[Tamaño]; 
        
        try{
            
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Nombre FROM Departamento");
            rs.next();
            int contador = 0;
            do{
                
                txt[contador] = rs.getString("Nombre");
                contador++;
                
            }while(rs.next());
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!" + ex);
             
        }
         return txt;
    }
    
    public int TamañoDepartamento(){
        
        int contador = 0;
        
        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Nombre FROM Departamento");
            rs.next();
            
            do{
                
                contador++;
                
            }while(rs.next());
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!" + ex);
             
        }
         return contador;
    }
    
    public int TamañoProveedor(){
        
        int contador = 0;
        
        try{
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Empresa FROM Proveedor");
            rs.next();
            
            do{
                
                contador++;
            }while(rs.next());
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!" + ex);
             
        }
         return contador;
    }
    
    public String[] SelectProveedores(int Tamaño){
        
        
        String[] txt = new String[Tamaño]; 
        
        try{
            
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Empresa FROM Proveedor");
            rs.next();
            int contador = 0;
            do{
                
                txt[contador] = rs.getString("Empresa");
                contador++;
                
            }while(rs.next());
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, "Error intente nuevamente!" + ex);
             
        }
         return txt;
    }
    
    public void InsertarProductos(String Nombre, String Descripcion, String Marca, String CodigoBarras, String Departamento, String Proveedor, int Precio_Prove, int Precio_Venta, int Cantidad, int Tienda){
        
        String Respuesta = "";
        
        try {
            
            CallableStatement cst = conn.prepareCall("{CALL InsertProducto(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)}");
            cst.setString(1, Nombre);
            cst.setString(2, Descripcion);
            cst.setInt(3, Precio_Prove);
            cst.setInt(4, Precio_Venta);
            cst.setString(5, Marca);
            cst.setInt(6, Cantidad);
            cst.setString(7, CodigoBarras);
            cst.setInt(8, Tienda);
            cst.setString(9, Departamento);
            cst.setString(10, Proveedor);
            rs = cst.executeQuery();
            
            while(rs.next()){
                
                Respuesta = rs.getString(1).toString();
                
            }
            
            JOptionPane.showMessageDialog(null, "Se ha registrado un producto");
            
        } catch (SQLException ex) {
            
            JOptionPane.showMessageDialog(null, "Mensaje: " + ex);
        }
    }
    
}
