<html>
    <body>
<?php
    include 'connect_db.php';

    $sql = "INSERT INTO client VALUES(?,?,?,?,?,?,?,?)";
    $stat = $connection->prepare($sql);

    //Checks if error exists in prepare
    if (false===$stat) 
    {
        die('prepare() failed: ' . htmlspecialchars($mysqli->error));
    }

    $VAT = $_REQUEST['VAT'];
    $name_ = $_REQUEST['name_'];
    $birth_date =$_REQUEST['birth_date'];
    $street = $_REQUEST['street'];
    $city = $_REQUEST['city'];
    $zip = $_REQUEST['zip'];
    $gender = $_REQUEST['gender'];
    $age = $_REQUEST['age'];
    $phone_number = $_REQUEST['phone_number'];

    $result = $stat->execute([$VAT, $name_, $birth_date, $street, $city, $zip, $gender, $age]);

    //Checks if error exists in execute
    if ($result == FALSE)
    {
      $info = $stat->errorInfo();
      echo("<p>Error exec: {$info[2]}</p>");
      exit();
    }

    $sql = "INSERT INTO phone_number_client VALUES(?,?)";
    $stat = $connection->prepare($sql);

    //Checks if error exists in prepare
    if (false===$stat) 
    {
        echo('prepare() failed: ' );
        exit();
    }

    $result = $stat->execute([$VAT, $phone_number]);

    //Checks if error exists in execute
    if ($result == FALSE)
    {
      $info = $stat->errorInfo();
      echo("<p>Error exec: {$info[2]}</p>");
      exit();
    }

    //Display the new client

    echo("<table border=\"1\">");
    echo("<tr><td>VAT</td><td>Name</td><td>Birth Date</td><td>Street</td><td>City</td><td>Zip</td><td>Gender</td><td>Age</td><td>Phone Number</td></tr>");

    echo("<tr><td>");
    echo($VAT);
    echo("</td><td>");
    echo($name_);
    echo("</td><td>");
    echo($birth_date);
    echo("</td><td>");
    echo($street);
    echo("</td><td>");
    echo($city);
    echo("</td><td>");
    echo($zip);
    echo("</td><td>");
    echo($gender);
    echo("</td><td>");
    echo($age);
    echo("</td><td>");
    echo($phone_number);
    echo("</td><td>");
    echo("<a href=\"select_date_appointment.php?VAT_client=");
    echo($VAT);
    echo("\">Create Appointment</a>\n");
    echo("</td></tr>");
    echo("</table>");

    echo("<p><a href=\"search_clients.php\">Search Clients</a></p>");
    $connection = null;
?>
    </body>
</html>