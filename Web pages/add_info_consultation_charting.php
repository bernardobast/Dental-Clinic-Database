<html>
 <body>
    <form action="update_info_consultation_dcharting.php" method="post"
    VAT_doctor=VAT_doctor Date=Date name_=name_ VAT_client=VAT_client
    Description=Description Measure=Measure>
      <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
      <input type="hidden" name="VAT_doctor" value="<?=$_REQUEST['VAT_doctor']?>">
      <input type="hidden" name="Date" value="<?=$_REQUEST['date_timestamp']?>">
      <input type="hidden" name="name_" value="<?=$_REQUEST['name_']?>">
    <h4>Dental Charting Form : </h4>
    <?php
      include 'connect_db.php';

      $sql = "SELECT * FROM teeth;";
      $stat = $connection->prepare($sql);
      // prepare() can fail because of syntax errors, missing privileges, ....
      if (false===$stat)
      {
         die('prepare() failed: ' . htmlspecialchars($mysqli->error));
      }

      $result = $stat->execute();
      if ($result == FALSE)
      {
        $info = $connection->errorInfo();
        echo("<p>Error: {$info[2]}</p>");
        exit();
      }
      echo("<table border=\"1\">");
      echo("<tr><td>Quadrant</td><td>Number</td><td>Name</td><td>Description</td><td>Measure</td></tr>");
      $result = $stat->fetchAll();
      foreach($result as $row)
      {
        echo("<tr><td>");
        echo($row['quadrant']);
        echo("</td><td>");
        echo($row['number_']);
        echo("</td><td>");
        echo($row['name_']);
        echo("</td><td>");
        ?>
          <p><input type="text" name="Description[]"/></p>
        <?php echo("</td><td>");?>
          <p><input type="text" name="Measure[]"/></p>
        <?php
        echo("</td></tr>");
      }
      echo("</table>");
       $connection = null;
    ?>
      <p><input type="submit" value="Insert Dental Charting"/></p>
    </form>
    <h4>Go back to list: </h4>
    <form action="appointment_info.php" method="post" VAT_client = VAT_client>
        <p><input type="submit" value="Back to Appointment/Consultation list"/></p>
        <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
    </form>
 </body>
</html>
