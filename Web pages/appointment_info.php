<html>
  <head>
    <title>Appointment/Consultation Info</title>
  </head>
 <body>
   <h2>Consultations/Appointments for Client = <?=$_REQUEST['VAT_client']?></h2>
   <h3>Appointments</h3>
    <?php

      include 'connect_db.php';

      $sql = "SELECT a.VAT_doctor,a.date_timestamp, c.SOAP_S FROM appointment as a
      LEFT JOIN consultation as c ON c.VAT_doctor = a.VAT_doctor AND c.date_timestamp = a.date_timestamp
      WHERE a.VAT_client= ?
      ORDER BY a.date_timestamp DESC";

      $VAT_client_SELECTED = $_REQUEST['VAT_client'];

      $stat = $connection->prepare($sql);
      // prepare() can fail because of syntax errors, missing privileges, ....
      if (false===$stat)
      {
         die('prepare() failed: ' . htmlspecialchars($mysqli->error));
      }

      $result = $stat->execute([$VAT_client_SELECTED]);
      if ($result == FALSE)
      {
        $info = $connection->errorInfo();
        echo("<p>Error: {$info[2]}</p>");
        exit();
      }

      echo("<table border=\"1\">");
      echo("<tr><td>Data</td><td>More Info</td><td>Appointment Type</td><td>Add More Info</td></tr>");
      //Fetch the result
      $result = $stat->fetchAll();
      foreach($result as $row)
      {
        echo("<tr><td>");
        echo($row['date_timestamp']);
        echo("</td><td>");
        echo("<a href=\"info_appointment.php?VAT_doctor=" . $row['VAT_doctor'] . "&date_timestamp=" . $row['date_timestamp']  ."&VAT_client=" . $VAT_client_SELECTED);
        echo("\">Get Info</a>\n");

        if(is_null($row['SOAP_S'])){
          echo("</td><td>");
          echo("Not a Consultation");
          echo("</td><td>");
          echo("<a href=\"add_info_consultation_pre.php?VAT_doctor=" . $row['VAT_doctor'] . "&date_timestamp=" . $row['date_timestamp']  ."&VAT_client=" . $VAT_client_SELECTED);
          echo("\">+ADD Info</a></td>\n");
        }
        else{
          echo("</td><td>");
          echo("Already a Consultation");
          echo("</td><td>");
          echo("Cant Edit</td>");
        }
        echo("</tr>");
      }
      echo("</table>");
      $connection = null;
    ?>
<h3>Consultations</h3>
<?php
  include 'connect_db.php';

  $sql = "SELECT * FROM appointment as a
  INNER JOIN consultation as c ON a.VAT_doctor = c.VAT_doctor AND a.date_timestamp = c.date_timestamp
  WHERE a.VAT_client= ?
  ORDER BY c.date_timestamp DESC";

  $stat = $connection->prepare($sql);
  // prepare() can fail because of syntax errors, missing privileges, ....
  if (false===$stat)
  {
     die('prepare() failed: ' . htmlspecialchars($mysqli->error));
  }

  $VAT_client_SELECTED = $_REQUEST['VAT_client'];

  $result = $stat->execute([$VAT_client_SELECTED]);
  if ($result == FALSE)
  {
    $info = $connection->errorInfo();
    echo("<p>Error: {$info[2]}</p>");
    exit();
  }
  echo("<table border=\"1\">");
  echo("<tr><td>Data</td></tr>");

  //Fetch the result
  $result = $stat->fetchAll();
  foreach($result as $row)
  {
    echo("<tr><td>");
    echo($row['date_timestamp']);
    echo("</td><td>");
    echo("<a href=\"info_consultation.php?VAT_doctor=" . $row['VAT_doctor'] . "&date_timestamp=" . $row['date_timestamp']  ."&VAT_client=" . $VAT_client_SELECTED);
    echo("\">Get Info</a></td>\n");
    echo("</tr>");
  }
  echo("</table>");

  echo("<p><a href=\"search_clients.php\">Search Clients</a></p>");

  $connection = null;
?>
 </body>
</html>
