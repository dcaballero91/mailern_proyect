<?php
require "../clases/conexion.php";

$q=$_POST['q']; 
$con = new conexion();
$con->conectar();
$sql = pg_query('select * from v_transferencias_det where trans_cod ='.$q); //where trans_cod='.$q.'
?>
<div class="col-md-2">
<div class="form-group">
<label>Item</label>
<select class="form-control" id="item2">

<?php while($fila=pg_fetch_array($sql)){ ?>
<option value="<?php echo $fila['item_cod']; ?>"><?php echo $fila['item_desc']; ?></option>
<?php } ?>

</select>
</div>
</div>

						

								