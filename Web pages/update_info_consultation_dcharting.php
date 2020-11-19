<html>
 <body>
   <?php
      include 'connect_db.php';
      $index = 0;

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

     $result = $stat->fetchAll();
     foreach($result as $row)
     {
      $quadrant[$index] = $row['quadrant'];
      $number_[$index] = $row['number_'];
      $name_[$index] = $row['name_'];
      $index=$index+1;
    }
      $connection = null;
   ?>
    <?php
      include 'connect_db.php';

      $VAT_doctor_UPDATE = $_REQUEST['VAT_doctor'];
      $Date_UPDATE = $_REQUEST['Date'];
      $measure = $_REQUEST['Measure'];
      $description = $_REQUEST['Description'];
      $name_ = $_REQUEST['name_'];

      //Initiates transaction
      $connection->beginTransaction();

      for($i=0; $i < sizeof($measure); $i++){
        if(empty($measure[$i])){
          $measure_insert = 0;
        }
        else{
          $measure_insert = $measure[$i];
        }
        if(empty($description[$i])){
          $description_insert = 'No Description Added';
        }
        else{
          $description_insert = $description[$i];
        }

        $sql = "INSERT INTO procedure_charting VALUES (?,?,?,?,?,?,?);";
        $stat = $connection->prepare($sql);
        // prepare() can fail because of syntax errors, missing privileges, ....
        if (false===$stat)
        {
           die('prepare() failed: ' . htmlspecialchars($mysqli->error));
        }

        $stat->execute([$name_,$VAT_doctor_UPDATE,$Date_UPDATE,$quadrant[$i],$number_[$i],$description_insert,$measure_insert]);
      }

      //Executes the transaction
      $result = $connection->commit();
      //Checks if error exists
      if ($result == FALSE)
      {
        $info = $connection->errorInfo();
        echo("<p>Error: {$info[2]}</p>");
        exit();
      }
      $connection = null;
    ?>
    <h4>Information Was Updated! Go back to list: </h4>
    <form action="appointment_info.php" method="post" VAT_client=VAT_client>
      <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
        <p><input type="submit" value="Back to Appointment/Consultation list"/></p>
    </form>
 </body>
</html>
