<html>
    <body>
        <form action="select_doctor.php?" method="post">
        <h3>Choose a date for the appointment</h3>
        <p>Date: <input type="date" name="date" min="<?php echo date('Y-m-d');?>" required/></p>
        <p>Time:
            <select name="time">
<?php
    include 'connect_db.php';

    $VAT_client = $_REQUEST['VAT_client'];

    for($hours=9; $hours<18; $hours++)
    { 
        $time = str_pad($hours,2,'0',STR_PAD_LEFT).':00:00';
        echo '<option value= "'.$time.'">'.$time.'</option>';
    }
?>
            </select>
        </p>
        <input type="hidden" name="VAT_client" value=<?=$_REQUEST['VAT_client']?>>
        <p><input type="submit" value="Check Available Doctors"/></p>
        </form>

    </body>
</html>