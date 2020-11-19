<html>
    <body>

<?php
    include 'connect_db.php';

    $VAT_doctor = $_REQUEST['VAT_doctor'];
    $date_timestamp = $_REQUEST['date_timestamp'];
    $VAT_client = $_REQUEST['VAT_client'];
    $description = $_REQUEST['description'];

    $sql = "INSERT INTO appointment VALUES(?,?,?,?)";
    $stat = $connection->prepare($sql);

    //Checks if error exists in prepare
    if (false===$stat) 
    {
        die('prepare() failed: ' . htmlspecialchars($mysqli->error));
    }
    
    $result = $stat->execute([$VAT_doctor, $date_timestamp, $description, $VAT_client]);

    //Checks if error exists in execute
    if ($result == FALSE)
    {
      $info = $stat->errorInfo();
      echo("<p>Error exec: {$info[2]}</p>");
      exit();
    }

    echo("<h3>Appointment Created</h3>");
    echo("<table border=\"1\">");
    echo("<tr><td>VAT Doctor</td><td>Date Time</td><td>Description</td><td>VAT Client</td></tr>");

    echo("<tr><td>");
    echo($VAT_doctor);
    echo("</td><td>");
    echo($date_timestamp);
    echo("</td><td>");
    echo($description);
    echo("</td><td>");
    echo($VAT_client);
    echo("</td></tr>");
    echo("</table>");

    echo("<p><a href=\"search_clients.php\">Search Clients</a></p>");
?>
    </body>
</html>