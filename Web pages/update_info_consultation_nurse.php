<html>
 <body>
    <?php
      include 'connect_db.php';

      $sql = "INSERT INTO consultation_assistant VALUES(?,?,?);'";
      $stat = $connection->prepare($sql);
      // prepare() can fail because of syntax errors, missing privileges, ....
      if (false===$stat)
      {
         die('prepare() failed: ' . htmlspecialchars($mysqli->error));
      }

      $VAT_doctor_UPDATE = $_REQUEST['VAT_doctor'];
      $Date_UPDATE = $_REQUEST['Date'];
      $VAT_nurse_UPDATE = $_REQUEST['VAT_nurse'];

      $result = $stat->execute([$VAT_doctor_UPDATE, $Date_UPDATE, $VAT_nurse_UPDATE]);
      if ($result == FALSE)
      {
        $info = $connection->errorInfo();
        echo("<p>Error: {$info[2]}</p>");
        exit();
      }

      $connection = null;
    ?>
    <h4>Add more Information to Consultation: </h4>
    <form action="add_info_consultation.php" method="post" VAT_doctor=VAT_doctor Date=Date VAT_client=VAT_client>
      <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
      <input type="hidden" name="VAT_doctor" value="<?=$_REQUEST['VAT_doctor']?>">
      <input type="hidden" name="Date" value="<?=$_REQUEST['Date']?>">
        <p><input type="submit" value="Add More Info"/></p>
    </form>
    <h4>Information Was Updated! Finish Adding Information: </h4>
    <form action="appointment_info.php" method="post" VAT_client=VAT_client>
      <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
        <p><input type="submit" value="Back to Appointment/Consultation list"/></p>
    </form>
 </body>
</html>
