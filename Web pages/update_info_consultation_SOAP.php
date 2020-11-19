<html>
 <body>
    <?php
      include 'connect_db.php';

      $sql = "INSERT INTO consultation VALUES(?,?,?,?,?,?);'";
      $stat = $connection->prepare($sql);
      // prepare() can fail because of syntax errors, missing privileges, ....
      if (false===$stat)
      {
         die('prepare() failed: ' . htmlspecialchars($mysqli->error));
      }

      $VAT_doctor_UPDATE = $_REQUEST['VAT_doctor'];
      $Date_UPDATE = $_REQUEST['Date'];
      $SOAP_S_UPDATE = $_REQUEST['SOAP_S'];
      $SOAP_O_UPDATE = $_REQUEST['SOAP_O'];
      $SOAP_A_UPDATE = $_REQUEST['SOAP_A'];
      $SOAP_P_UPDATE = $_REQUEST['SOAP_P'];

      $result = $stat->execute([$VAT_doctor_UPDATE, $Date_UPDATE, $SOAP_S_UPDATE, $SOAP_O_UPDATE, $SOAP_A_UPDATE, $SOAP_P_UPDATE]);
      if ($result == FALSE)
      {
        $info = $connection->errorInfo();
        echo("<p>Error: {$info[2]}</p>");
        exit();
      }

      $connection = null;
    ?>
    <h4>Information Was Updated! Add Nurses/Diagnostic/Percription More Info: </h4>
    <form action="add_info_consultation.php" method="post" VAT_doctor=VAT_doctor Date=Date VAT_client=VAT_client>
      <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
      <input type="hidden" name="VAT_doctor" value="<?=$_REQUEST['VAT_doctor']?>">
      <input type="hidden" name="Date" value="<?=$_REQUEST['Date']?>">
        <p><input type="submit" value="Add Nurses/Diagnostic/Percription"/></p>
    </form>
    <h4>Atention! Once you go back, you cant add more info!: </h4>
    <form action="appointment_info.php" method="post" VAT_client=VAT_client>
        <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
        <p><input type="submit" value="Back to Appointment/Consultation list"/></p>
    </form>
 </body>
</html>
