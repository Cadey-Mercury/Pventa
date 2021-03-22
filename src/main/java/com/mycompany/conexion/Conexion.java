
package com.mycompany.conexion;

import com.mycompany.pventa.LogIn;
import com.mycompany.pventa.Main;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;


public class Conexion {
    //Variables para la conexion a la BD
    private static Connection conn;
    private static final String driver = "com.mysql.cj.jdbc.Driver";
    private static final String User = "root";
    private static final String Password = "";
    private static final String url = "jdbc:mysql://localhost:3306/PVenta";
    
    private static Statement stmt;
    //private static CallableStatement cst;
    private static ResultSet rs;
    public static String Id_Empleado = "";
    
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
    
    public DefaultTableModel BuscarProducto(String Codigo, int Cantidad, int Id){
        
        DefaultTableModel modelo = new DefaultTableModel();
        String Respuesta = "";
        try {
            
            CallableStatement cst = conn.prepareCall("{CALL Carrito(?,?,?)}");
            cst.setString(1, Codigo);
            cst.setInt(2, Cantidad);
            cst.setInt(3, Id);
            rs = cst.executeQuery();
            
            while(rs.next()){
                Respuesta = rs.getString(1).toString();
            }
            
            if(Respuesta.equals("El producto no existe")){
                JOptionPane.showMessageDialog(null, Respuesta);
            }
            
            
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Nombre_Completo, Cantidad, Precio, Total FROM CarritoDeCompra");
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
            
            JOptionPane.showMessageDialog(null, "Producto no encontrado... ");
        }
        
        return modelo;
    }
}
