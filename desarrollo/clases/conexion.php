<?php
class conexion {
    public $host="172.17.0.3";
    public $db="corregido";
    public $puerto="5432";
    public $user="postgres";
    public $password="123";
    public $pdo; // Objeto PDO para la conexión

    function __construct(){
        $this->conectar();
    }

    // Función para establecer la conexión utilizando PDO
    function conectar(){
        $dsn = "pgsql:host={$this->host};port={$this->puerto};dbname={$this->db}";
        try {
            $this->pdo = new PDO($dsn, $this->user, $this->password);
            $this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            return true;
        } catch (PDOException $e) {
            die("Error al conectar con la base de datos: " . $e->getMessage());
        }
    }

    // Función para ejecutar una consulta
    public function query($query) {
        try {
            return $this->pdo->query($query);
        } catch (PDOException $e) {
            die("Error en la consulta: " . $e->getMessage());
        }
    }

    // Función para realizar una consulta SELECT y devolver los resultados
    public function select($query){
        $stmt = $this->query($query);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    // Otras funciones (select_array, contar, sp, etc.) pueden ser adaptadas de manera similar
     //funcion select array
     public function select_array($query){
        $result = $this -> query($query);
        $num = $result->rowCount();
        $rows = 0;
        while ($row = $result->fetch(PDO::FETCH_ASSOC)) {
            if ($num == 0){
                $rows = 0;
            }else{
                $rows = $row;
            }
        }
        return $rows;
    }
    //Funcion cantidad de registros
    function contar($query){
        try {
            $stmt = $this->pdo->query($query);
            return $stmt->rowCount(); // Devuelve el número de filas en el resultado
        } catch (PDOException $e) {
            die("Error al contar: " . $e->getMessage());
        }
    }
    //funcion ejecutar SP
    public function sp($query){
        $this -> query($query);
        $noticia = pg_last_notice($this->url);
        return str_replace("NOTICE: ","",$noticia);
    }
    //función para destruir la conexión.
    function destruir(){
            pg_close($this->url);
    }

}
?>
