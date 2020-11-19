<html>
  <head>
    <title>Consultation Info</title>
  </head>
   <body>
   <h3>Information about Consultation with Doctor <?=$_REQUEST['VAT_doctor']?> on Date <?=$_REQUEST['date_timestamp']?></h3>
   <h4>General Information: </h4>
   <?php
     include 'connect_db.php';

     $sql = "SELECT c.VAT_doctor, c.date_timestamp, c.SOAP_S, c.SOAP_O, c.SOAP_A, c.SOAP_P
     FROM consultation as c WHERE c.VAT_doctor= ?
     AND c.date_timestamp=?";

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
     echo("<tr><td>VAT Doctor</td><td>Data</td><td>SOAP S</td><td>SOAP O</td><td>SOAP A</td><td>SOAP P</td></tr>");
     $result = $stat->fetchAll();
     foreach($result as $row)
     {
       echo("<tr><td>");
       echo($row['VAT_doctor']);
       echo("</td><td>");
       echo($row['date_timestamp']);
       echo("</td><td>");
       echo($row['SOAP_S']);
       echo("</td><td>");
       echo($row['SOAP_O']);
       echo("</td><td>");
       echo($row['SOAP_A']);
       echo("</td><td>");
       echo($row['SOAP_P']);
       echo("</td></tr>");
     }
     echo("</table>");
      $connection = null;
   ?>
   <h4>Diagnostic Info: </h4>
   <?php
     include 'connect_db.php';

     $sql = "SELECT cd.ID, dc.description
     FROM consultation as c
     LEFT JOIN consultation_diagnostic as cd ON c.VAT_doctor = cd.VAT_doctor AND c.date_timestamp = cd.date_timestamp
     LEFT JOIN  diagnostic_code  as dc ON cd.ID = dc.ID
     WHERE c.VAT_doctor= ? AND c.date_timestamp= ? ";

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
     echo("<tr><td>Diagnostic Code</td><td>Diagnostic Description</td></tr>");
     $result = $stat->fetchAll();
     foreach($result as $row)
     {
       echo("<tr><td>");
       echo($row['ID']);
       echo("</td><td>");
       echo($row['description']);
       echo("</td></tr>");
     }
     echo("</table>");
      $connection = null;
   ?>
   <h4>Prescription Info: </h4>
   <?php
     include 'connect_db.php';

     $VAT_doctor_SELECTED = $_REQUEST['VAT_doctor'];
     $date_timestamp_SELECTED = $_REQUEST['date_timestamp'];

     $sql = "SELECT cd.ID, p.name_, p.lab, p.dosage, p.description_
     FROM consultation as c
     LEFT JOIN consultation_diagnostic as cd ON c.VAT_doctor = cd.VAT_doctor AND c.date_timestamp = cd.date_timestamp
     LEFT JOIN prescription as p ON c.VAT_doctor = p.VAT_doctor AND c.date_timestamp = p.date_timestamp AND cd.ID = p.ID
     WHERE c.VAT_doctor= ? AND c.date_timestamp= ?";
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
     echo("<tr><td>Diagnostic Code</td><td>Medication Name</td><td>Laboratory</td><td>Dosage</td><td>Description</td></tr>");
     $result = $stat->fetchAll();
     foreach($result as $row)
     {
       echo("<tr><td>");
       echo($row['ID']);
       echo("</td><td>");
       echo($row['name_']);
       echo("</td><td>");
       echo($row['lab']);
       echo("</td><td>");
       echo($row['dosage']);
       echo("</td><td>");
       echo($row['description_']);
       echo("</td></tr>");
     }
     echo("</table>");
      $connection = null;
   ?>
   <h4>Assistant Info: </h4>
   <?php
     include 'connect_db.php';

     $sql = "SELECT cs.VAT_nurse
     FROM consultation as c
     LEFT JOIN consultation_assistant as cs ON cs.VAT_doctor = c.VAT_doctor AND cs.date_timestamp = c.date_timestamp
     WHERE c.VAT_doctor= ? AND c.date_timestamp= ?";
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
     echo("<tr><td>VAT Nurse</td></tr>");
     $result = $stat->fetchAll();
     foreach($result as $row)
     {
       echo("<tr><td>");
       echo($row['VAT_nurse']);
       echo("</td></tr>");
     }
     echo("</table>");
      $connection = null;
   ?>
   <h4>Procedures: </h4>
   <?php
     include 'connect_db.php';

     $sql = "SELECT p.name_, p.type_
     FROM consultation as c
     LEFT JOIN procedure_in_consultation as pc ON pc.VAT_doctor = c.VAT_doctor AND pc.date_timestamp = c.date_timestamp
     LEFT JOIN procedure_ as p ON pc.name_ = p.name_
     WHERE c.VAT_doctor= ? AND c.date_timestamp= ?";
     $stat = $connection->prepare($sql);
     // prepare() can fail because of syntax errors, missing privileges, ....
     if (false===$stat)
     {
        die('prepare() failed: ' . htmlspecialchars($mysqli->error));
     }

     $VAT_doctor_SELECTED = $_REQUEST['VAT_doctor'];
     $date_timestamp_SELECTED = $_REQUEST['date_timestamp'];
     $VAT_client = $_REQUEST['VAT_client'];

     $result = $stat->execute([$VAT_doctor_SELECTED, $date_timestamp_SELECTED]);
     if ($result == FALSE)
     {
       $info = $connection->errorInfo();
       echo("<p>Error: {$info[2]}</p>");
       exit();
     }

     echo("<table border=\"1\">");
     echo("<tr><td>Name </td><td>Type </td><td>Edit Info </td></tr>");
     $result = $stat->fetchAll();
     foreach($result as $row)
     {
       echo("<tr><td>");
       echo($row['name_']);
       echo('</td><td>');
       echo($row['type_']);
       if($row['type_']=='dental charting'){
         echo('</td><td>');
         echo("<a href=\"add_info_consultation_charting.php?VAT_doctor=" . $VAT_doctor_SELECTED . "&date_timestamp=" . $date_timestamp_SELECTED . "&name_=" . $row['name_'] . "&VAT_client=" . $VAT_client);
         echo("\">Edit Info </a></td>\n");
       }
       else{
         echo('</td><td>');
         echo('Cant edit');
       }
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
