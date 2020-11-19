<html>
    <body>
        <form action="create_appointment.php?" method="post">
        <h3>Add a description for the appointment</h3>
        <p><input type="test" name="description" maxlength="255"/></p>
        
<?php
    include 'connect_db.php';
?>
        </p>
        <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
        <input type="hidden" name="VAT_doctor" value="<?=$_REQUEST['VAT_doctor']?>">
        <input type="hidden" name="date_timestamp" value="<?=$_REQUEST['date_timestamp']?>">
        <p><input type="submit" value="Add description"/></p>
        </form>

    </body>
</html>