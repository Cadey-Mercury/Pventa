
package com.mycompany.conexion;

import com.mycompany.pventa.LogIn;
import com.mycompany.pventa.Main;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;


public class Conexion {
    //Variables para la conexion a la BD
    private static Connection conn;
    private static final String driver = "com.mysql.cj.jdbc.Driver";
    private static final String User = "root";
    private static final String Password = "";
    private static final String url = "jdbc:mysql://localhost:3306/PVenta";
    
    private static Statement stmt;
    private static ResultSet rs;
    
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
            rs = stmt.executeQuery("SELECT Nombre, Apellido_P, Usuario, Pass FROM Empleado WHERE Usuario ='" + Usuario + "' AND Pass ='" + Contraseña + "' ");
            rs.next();
            do{
               
                
                if(rs.getString("Usuario").equals(Usuario) && rs.getString("Pass").equals(Contraseña)){
                    Dato = rs.getString("Nombre") + " " + rs.getString("Apellido_P");
                }
                
            }while(rs.next());
            
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "Error, intente nuevamente... ");
        }
        return Dato;
    }
    
    /*public void BuscarProducto(String Codigo, int Cantidad){
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery("SELECT Nombre, Descripcion, Precio_vent FROM Producto WHERE Codigo_Barras ='" + Codigo + "' ");
            ResultSetMetaData rsMd = rs.getMetaData();
            //int cantidadColumnas = rsMd.getColumnCount():
            
            rs.next();
            do{
               
                
                
            }while(rs.next());
            
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null, "Error, intente nuevamente... ");
        }
    }*/
}
