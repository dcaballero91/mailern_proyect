<?php
    
    session_start();

    #recupera o almacena un mensaje de sesion
    function msg_sesion($msg=""){
        if(empty($msg)){
            
            if(isset($_SESSION["msg"])){
                
                $msg=$_SESSION["msg"];
                $_SESSION["msg"]="";
                return $msg;
                
            }else{
                
                return "";
                
            }
            
        }else{
            
            $_SESSION["msg"]=$msg;
            
        }
        
    }
    
    #verificar la sesion
    function verifico(){
        if(!estas_logeado()){
                msg_sesion("Debes iniciar sesión para ingresar");
                header("Location:../index.php");
                exit();
        }
    }
    
    #indica si el usuario ha iniciado la funcion
    function estas_logeado(){
        return isset($_SESSION["id"]);
    }
?>