/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mycompany.pventa;

import com.mycompany.conexion.Conexion;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JOptionPane;

/**
 *
 * @author Mi-PC
 */
public class AdminUsuario extends javax.swing.JFrame {

    Conexion con;
    Connection bd;
    boolean FlagNombre = false;
    boolean FlagUsuario = false;
    boolean Flag = false;
    
    public AdminUsuario() {
        initComponents();
        this.setLocationRelativeTo(null);
        String Empresa = "<html><body><b>Abarrotes Garcia S.A.de C.V. <br> Río grande e/ Río tigris #820 <br> Col. Lagunitas </b></body></html>";
        jLabel10.setText(Empresa);
        try{
            
        con = new Conexion();
        bd = con.getConnection();
            
        }catch(SQLException ex){
            Logger.getLogger(LogIn.class.getName()).log(Level.SEVERE, null, ex);
        }
    }


    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jLabel3 = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jLabel7 = new javax.swing.JLabel();
        jLabel8 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        txtTienda = new javax.swing.JTextField();
        txtPass = new javax.swing.JTextField();
        txtUser = new javax.swing.JTextField();
        txtDireccion = new javax.swing.JTextField();
        txtPuesto = new javax.swing.JTextField();
        txtTel = new javax.swing.JTextField();
        txtA_M = new javax.swing.JTextField();
        txtA_P = new javax.swing.JTextField();
        txtNombre = new javax.swing.JTextField();
        btnRegistrar = new javax.swing.JButton();
        btnModificar = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jLabel10 = new javax.swing.JLabel();
        btnBuscar = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setPreferredSize(new java.awt.Dimension(750, 750));
        setResizable(false);
        getContentPane().setLayout(null);

        jPanel1.setBackground(new java.awt.Color(0, 255, 255));
        jPanel1.setPreferredSize(new java.awt.Dimension(750, 750));
        jPanel1.setLayout(null);

        jLabel1.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel1.setText("Nombre:");
        jPanel1.add(jLabel1);
        jLabel1.setBounds(180, 126, 61, 17);

        jLabel2.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel2.setText("Apellido Paterno:");
        jPanel1.add(jLabel2);
        jLabel2.setBounds(180, 168, 118, 17);

        jLabel3.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel3.setText("Apellido Materno:");
        jPanel1.add(jLabel3);
        jLabel3.setBounds(180, 210, 121, 17);

        jLabel4.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel4.setText("Telefono:");
        jPanel1.add(jLabel4);
        jLabel4.setBounds(180, 252, 65, 17);

        jLabel5.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel5.setText("Puesto:");
        jPanel1.add(jLabel5);
        jLabel5.setBounds(180, 294, 53, 17);

        jLabel6.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel6.setText("Direccion:");
        jPanel1.add(jLabel6);
        jLabel6.setBounds(180, 336, 67, 17);

        jLabel7.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel7.setText("Usuario:");
        jPanel1.add(jLabel7);
        jLabel7.setBounds(180, 378, 57, 17);

        jLabel8.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel8.setText("Contraseña:");
        jPanel1.add(jLabel8);
        jLabel8.setBounds(180, 416, 85, 17);

        jLabel9.setFont(new java.awt.Font("Tahoma", 1, 14)); // NOI18N
        jLabel9.setText("Tienda");
        jPanel1.add(jLabel9);
        jLabel9.setBounds(180, 458, 46, 17);
        jPanel1.add(txtTienda);
        txtTienda.setBounds(319, 455, 300, 24);
        jPanel1.add(txtPass);
        txtPass.setBounds(319, 413, 300, 24);
        jPanel1.add(txtUser);
        txtUser.setBounds(319, 371, 300, 24);
        jPanel1.add(txtDireccion);
        txtDireccion.setBounds(319, 329, 300, 24);
        jPanel1.add(txtPuesto);
        txtPuesto.setBounds(319, 287, 300, 24);
        jPanel1.add(txtTel);
        txtTel.setBounds(319, 245, 300, 24);
        jPanel1.add(txtA_M);
        txtA_M.setBounds(319, 203, 300, 24);
        jPanel1.add(txtA_P);
        txtA_P.setBounds(319, 161, 300, 24);
        jPanel1.add(txtNombre);
        txtNombre.setBounds(319, 119, 300, 24);

        btnRegistrar.setText("Registrar");
        btnRegistrar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnRegistrarActionPerformed(evt);
            }
        });
        jPanel1.add(btnRegistrar);
        btnRegistrar.setBounds(180, 578, 120, 24);

        btnModificar.setText("Modificar");
        btnModificar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnModificarActionPerformed(evt);
            }
        });
        jPanel1.add(btnModificar);
        btnModificar.setBounds(328, 578, 120, 24);

        jButton3.setText("Eliminar");
        jPanel1.add(jButton3);
        jButton3.setBounds(499, 578, 120, 24);

        jLabel10.setFont(new java.awt.Font("Arial", 0, 18)); // NOI18N
        jPanel1.add(jLabel10);
        jLabel10.setBounds(319, 26, 0, 0);

        btnBuscar.setText("Buscar");
        btnBuscar.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                btnBuscarActionPerformed(evt);
            }
        });
        jPanel1.add(btnBuscar);
        btnBuscar.setBounds(646, 119, 91, 24);

        getContentPane().add(jPanel1);
        jPanel1.setBounds(0, 0, 750, 750);

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void btnRegistrarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnRegistrarActionPerformed
        String Nombre, Apellido_P, Apellido_M, Direccion, Usuario, Contraseña, Puesto, Tienda;
        int Tel;
        
        Nombre = txtNombre.getText();
        Apellido_P = txtA_P.getText();
        Apellido_M = txtA_M.getText();
        Tel = Integer.parseInt(txtTel.getText());
        Direccion = txtDireccion.getText();
        Usuario = txtUser.getText();
        Contraseña = txtPass.getText();
        Puesto = txtPuesto.getText();
        Tienda = txtTienda.getText();
        con.InsertarEmpleados(Nombre, Apellido_P, Apellido_M, Tel, Puesto, Direccion, Usuario, Contraseña, Tienda);
        Limpiar();
    }//GEN-LAST:event_btnRegistrarActionPerformed

    private void btnBuscarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnBuscarActionPerformed
        String[] Datos = new String[8];
        String Nombre, Usuario;
        Nombre = txtNombre.getText().trim();
        Usuario = txtUser.getText().trim();
        
        if(Nombre.equals("") == false){
            
            Datos = con.BuscarEmpleadoNombre(Nombre);
            
            for(int i = 0; i < Datos.length; i++){
                
                if(Datos[i].equals(null)){
                    
                    Flag = true;
                    
                    break;
                    
                }
            }
            if(Flag){
                
                JOptionPane.showMessageDialog(null, "No existe el nombre");
                
            }else{
                
                txtNombre.setEnabled(false);
                txtA_P.setText(Datos[0]);
                txtA_M.setText(Datos[1]);
                txtDireccion.setText(Datos[2]);
                txtTel.setText(Datos[3]);
                txtUser.setText(Datos[4]);
                txtPass.setText(Datos[5]);
                txtTienda.setText(Datos[6]);
                txtPuesto.setText(Datos[7]);
                btnBuscar.setVisible(false);
                FlagNombre = true;
                
            }
            
        }else{
            
            if(Usuario.equals("") == false){
                Datos = con.BuscarEmpleadoUsuario(Usuario);
                
                for(int i = 0; i < Datos.length; i++){
                    
                    if(Datos[i].equals(null)){
                        
                        Flag = true;
                        
                        break;
                    }
                }
                if(Flag){
                    
                     JOptionPane.showMessageDialog(null, "No existe Usuario");
                     
                }else{
                    
                    txtUser.setEnabled(false);
                    txtNombre.setText(Datos[0]);
                    txtA_P.setText(Datos[1]);
                    txtA_M.setText(Datos[2]);
                    txtDireccion.setText(Datos[3]);
                    txtTel.setText(Datos[4]);
                    txtPass.setText(Datos[5]);
                    txtTienda.setText(Datos[6]);
                    txtPuesto.setText(Datos[7]);
                    btnBuscar.setVisible(false);
                    FlagUsuario = true;
                }
                
            }else{
                
                JOptionPane.showMessageDialog(null, "Faltan campos por rellenar!");
                
            }
        }
    }//GEN-LAST:event_btnBuscarActionPerformed

    private void btnModificarActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_btnModificarActionPerformed
        String Nombre, Apellido_P, Apellido_M, Direccion, Usuario, Contraseña, Puesto, Tienda;
        int Tel;
        
        Nombre = txtNombre.getText();
        Apellido_P = txtA_P.getText();
        Apellido_M = txtA_M.getText();
        Tel = Integer.parseInt(txtTel.getText());
        Direccion = txtDireccion.getText();
        Usuario = txtUser.getText();
        Contraseña = txtPass.getText();
        Puesto = txtPuesto.getText();
        Tienda = txtTienda.getText();
        con.ActualizarEmpleadoPorNombreAndUsuario(Nombre, Apellido_P, Apellido_M, Tel, Puesto, Direccion, Usuario, Contraseña, Tienda, FlagNombre, FlagUsuario);
        Limpiar();
    }//GEN-LAST:event_btnModificarActionPerformed

    public void Limpiar(){
        txtNombre.setText(null);
        txtA_P.setText(null);
        txtA_M.setText(null);
        txtTel.setText(null);
        txtDireccion.setText(null);
        txtUser.setText(null);
        txtPass.setText(null);
        txtPuesto.setText(null);
        txtTienda.setText(null);
        txtNombre.setEnabled(true);
        txtUser.setEnabled(true);
        btnBuscar.setVisible(true);
        txtNombre.requestFocus();
    }
    
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(AdminUsuario.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(AdminUsuario.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(AdminUsuario.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(AdminUsuario.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new AdminUsuario().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton btnBuscar;
    private javax.swing.JButton btnModificar;
    private javax.swing.JButton btnRegistrar;
    private javax.swing.JButton jButton3;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JTextField txtA_M;
    private javax.swing.JTextField txtA_P;
    private javax.swing.JTextField txtDireccion;
    private javax.swing.JTextField txtNombre;
    private javax.swing.JTextField txtPass;
    private javax.swing.JTextField txtPuesto;
    private javax.swing.JTextField txtTel;
    private javax.swing.JTextField txtTienda;
    private javax.swing.JTextField txtUser;
    // End of variables declaration//GEN-END:variables
}
