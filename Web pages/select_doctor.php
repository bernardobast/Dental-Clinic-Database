<html>
    <body>
<?php
    include 'connect_db.php';

    $date = $_REQUEST['date'];
    $time = $_REQUEST['time'];
    $VAT_client = $_REQUEST['VAT_client'];

    $date_timestamp = strval($date).' '. strval($time);


    $sql = "SELECT e.name_, e.VAT FROM employee as e, doctor as d WHERE e.VAT NOT IN
            (SELECT VAT_doctor FROM appointment as a
            WHERE a.date_timestamp = '$date_timestamp') AND e.VAT = d.VAT";
    
    $stat = $connection->prepare($sql);
    
    //Checks if error exists in prepare
    if (false===$stat) 
    {
        echo('prepare() failed: ');
        exit();
    }

    $sth=$stat->execute([$date_timestamp]);

    //Checks if error exists in execute
    if ($sth == FALSE)
    {
      $info = $stat->errorInfo();
      echo("<p>Error exec: {$info[2]}</p>");
      exit();
    }

    echo("<h3>Available Doctors</3>");
    echo("<table border=\"1\">");
    echo("<tr><td>VAT</td><td>Name</td></tr>");
    
    $result = $stat->fetchAll();
    foreach($result as $row)
    {
        echo("<tr><td>");
        echo($row['VAT']);
        echo("</td><td>");
        echo($row['name_']);
        echo("</td><td>");
        echo("<a href=\"add_description.php?VAT_doctor=". $row['VAT'] ."&". "date_timestamp=". $date_timestamp ."&". "VAT_client=". $VAT_client);
        echo("\">Create Appointment</a>\n");
        echo("</td></tr>");
    }
    echo("</table>");
    $connection = null;
?>
    </body>
</html>