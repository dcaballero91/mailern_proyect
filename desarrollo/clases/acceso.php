<?php
require "conexion.php";
require 'funciones.php';
require 'sesion.php';

 $usu = isset($_POST["usu"])?$_POST["usu"]:"";
 $pass = isset($_POST["pass"])?$_POST["pass"]:"";

   // $usu = $_POST["usu"];
   // $pass = $_POST["pass"];


    if(empty($usu) || empty($pass)){
      msg_sesion("Todos los campos son necesarios!!");
        llevame_a("../index.php");
    }
    
   $con= new conexion();
   $con->conectar();
    
    //  $sql="select * from v_usuarios where usu_pass= md5('$pass');";
   $sql="select * from v_usuarios where usu_name = '$usu' and usu_pass= '$pass'";
   #echo "Consulta SQL: " . $sql; 
    $num = $con->contar($sql);

   if($num == 1){
        $res = $con->select_array($sql);
        if($res["usu_pass"]= $pass){
            $_SESSION["usu"] = $usu;
            $_SESSION["pass"] = $pass;
            $_SESSION["id"] = $res["usu_cod"];
            $_SESSION["fun_cod"] = $res["fun_cod"];
            $_SESSION["fun_nom"] = $res["fun_nom"];
            //$_SESSION["fun_ape"] = $res["fun_ape"];

            #$_SESSION["emp_cod"] = $res["emp_cod"];
            #$_SESSION["emp_nom"] = $res["emp_nom"];
            #$_SESSION["emp_ruc"] = $res["emp_ruc"];
            $_SESSION["suc_cod"] = $res["suc_cod"];
            $_SESSION["suc_nom"] = $res["suc_nom"];
            $_SESSION["gru_id"] = $res["gru_id"];
            //$_SESSION["foto"] = $res["foto"];
          // $_SESSION["foto"]=$foto;
            $usu_cod = $res["usu_cod"];
            
            $con->query("UPDATE usuarios SET usu_estado = 'ONLINE' WHERE usu_name = '$usu';");
           // $grupo = $res["gru_descrip"];
            //$permisos = $con->select("select * from v_permisos where gru_descrip = '$grupo'");
            //$_SESSION["permisos"] = $permisos;
            msg_sesion("Ha iniciado sesion");
            #llevame_a("http://localhost/desarrollo/controles/inicio.php");
            llevame_a("../controles/inicio.php");
        }else{
            msg_sesion("La contraseña es incorrecta");
            llevame_a("../index.php");
        }
   }else{
       msg_sesion("El nombre del usuario no existe");
       llevame_a("../index.php");
   }
?>