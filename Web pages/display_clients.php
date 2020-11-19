<html>
    <body>

<?php
    include 'connect_db.php';

    $VAT = $_REQUEST['VAT'];
    $name_ = $_REQUEST['name_'];
    $street = $_REQUEST['street'];
    $city = $_REQUEST['city'];
    $zip = $_REQUEST['zip'];

    if(empty($VAT)) 
    {
        $sql = "SELECT * FROM client WHERE name_ LIKE ?
        AND street LIKE ? AND city LIKE ? AND zip LIKE ?";
        $stat = $connection->prepare($sql);

        //Checks if error exists in prepare
        if (false===$stat) 
        {
            echo('prepare() failed: ');
            exit();
        }

        $sth = $stat->execute(['%' . $name_ . '%', '%' . $street . '%', '%' . $city . '%', '%' . $zip . '%']);
    }
    else
    {
        $sql = "SELECT * FROM client WHERE VAT = ?";
        $stat = $connection->prepare($sql);

        //Checks if error exists in prepare
        if (false===$stat) 
        {
            echo('prepare() failed: ');
            exit();
        }

        $sth=$stat->execute([$VAT]);
    }

    //Checks if error exists in execute
    if ($sth == FALSE)
    {
      $info = $stat->errorInfo();
      echo("<p>Error exec: {$info[2]}</p>");
      exit();
    }

    echo("<table border=\"1\">");
    echo("<tr><td>VAT</td><td>Name</td><td>Birth Date</td><td>Street</td><td>City</td><td>Zip</td><td>Gender</td><td>Age</td></tr>");
    
    $result = $stat->fetchAll();
    foreach($result as $row)
    {
        echo("<tr><td>");
        echo($row['VAT']);
        echo("</td><td>");
        echo($row['name_']);
        echo("</td><td>");
        echo($row['birth_date']);
        echo("</td><td>");
        echo($row['street']);
        echo("</td><td>");
        echo($row['city']);
        echo("</td><td>");
        echo($row['zip']);
        echo("</td><td>");
        echo($row['gender']);
        echo("</td><td>");
        echo($row['age']);
        echo("</td><td>");
        echo("<a href=\"select_date_appointment.php?VAT_client=");
        echo($row['VAT']);
        echo("\">Create Appointment</a>\n");
        echo("</td><td>");
        echo("<a href=\"appointment_info.php?VAT_client=");
        echo($row['VAT']);
        echo("\">Info Appointment</a>\n");
        echo("</td></tr>");
    }
    echo("</table>");

    echo("<p><a href=\"search_clients.php\">Search Clients</a></p>");
    $connection = null;
?>

        <form action="insert_new_client.php" method="post">
        <p><input type="submit" value="New Client"/></p>
        </form> 

    </body>
</html>