<?php
    require "sesion.php";
    require "funciones.php";

    $_SESSION=array();
    session_destroy();
    llevame_a("../index.php");
    
?>