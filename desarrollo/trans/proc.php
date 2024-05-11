<?php
require "../clases/conexion.php";

$q=$_POST['q'];
$cn = new conexion();
$cn->conectar();
$sql = pg_query('select * from v_tan_deta where nro_tranfer='.$q.'');
?>
<div class="col-md-2">
<div class="form-group">
<label>Nro.Equipo</label>
<select class="form-control selectpicker" data-size="10" data-live-search="true" id="art">

<?php while($fila=pg_fetch_array($sql)){ ?>
<option value="<?php echo $fila['item_cod']; ?>"><?php echo $fila['item_des']; ?></option>
<?php } ?>

</select>
</div>
</div>

						

								