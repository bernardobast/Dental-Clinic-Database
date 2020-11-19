<html>
  <head>
    <title>Appointment Info</title>
  </head>
   <body>
   <h3>Information about Appointment with Doctor <?=$_REQUEST['VAT_doctor']?> on Date <?=$_REQUEST['date_timestamp']?></h3>
   <h4>General Information:</h4>
   <?php
     include 'connect_db.php';

     $sql = "SELECT * FROM appointment WHERE VAT_doctor= ? AND date_timestamp= ? ORDER BY date_timestamp DESC";
     $stat = $connection->prepare($sql);
     // prepare() can fail because of syntax errors, missing privileges, ....
     if (false===$stat)
     {
        die('prepare() failed: ' . htmlspecialchars($mysqli->error));
     }

     $VAT_doctor_SELECTED = $_REQUEST['VAT_doctor'];
     $date_timestamp_SELECTED = $_REQUEST['date_timestamp'];

     $result = $stat->execute([$VAT_doctor_SELECTED, $date_timestamp_SELECTED]);
     if ($result == FALSE)
     {
       $info = $connection->errorInfo();
       echo("<p>Error: {$info[2]}</p>");
       exit();
     }

     echo("<table border=\"1\">");
     echo("<tr><td>VAT Doctor</td><td>Date</td><td>Description</td><td>VAT Client</td></tr>");
     $result = $stat->fetchAll();
     foreach($result as $row)
     {
       echo("<tr><td>");
       echo($row['VAT_doctor']);
       echo("</td><td>");
       echo($row['date_timestamp']);
       echo("</td><td>");
       echo($row['description_']);
       echo("</td><td>");
       echo($row['VAT_client']);
       echo("</td></tr>");
     }
     echo("</table>");
      $connection = null;
   ?>
   <form action="appointment_info.php" method="post" VAT_client = VAT_client>
     <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
       <p><input type="submit" value="Back to Appointment/Consultation list"/></p>
   </form>
   </body>
</html>
