<html>
  <head>
    <title>Add Appointment Info</title>
  </head>
  <h3>Insert More Info into with Doctor <?=$_REQUEST['VAT_doctor']?> on Date <?=$_REQUEST['Date']?></h3>
   <body>
     <h4> Add Nurse: </h4>
     <form action="update_info_consultation_nurse.php" method="post"
        VAT_doctor = VAT_doctor Date=Date VAT_nurse = VAT_nurse VAT_client=VAT_client>
        <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
        <input type="hidden" name="VAT_doctor" value="<?=$_REQUEST['VAT_doctor']?>">
        <input type="hidden" name="Date" value="<?=$_REQUEST['Date']?>">
        <p>Available VAT Nurse:
          <select name="VAT_nurse" required>
          <?php
            include 'connect_db.php';

            /*Sees the available nurses at that time*/
            $sql = "SELECT DISTINCT VAT_nurse FROM consultation_assistant
            WHERE VAT_nurse NOT IN (SELECT DISTINCT VAT_nurse FROM consultation_assistant as cs
            WHERE cs.date_timestamp= ?);";
            $stat = $connection->prepare($sql);
            // prepare() can fail because of syntax errors, missing privileges, ....
            if (false===$stat)
            {
               die('prepare() failed: ' . htmlspecialchars($mysqli->error));
            }

            $date_timestamp_SELECTED = $_REQUEST['Date'];

            $result = $stat->execute([$date_timestamp_SELECTED]);
            if ($result == FALSE)
            {
              $info = $connection->errorInfo();
              echo("<p>Error: {$info[2]}</p>");
              exit();
            }

            echo("<table border=\"1\">");
            $result = $stat->fetchAll();
            foreach($result as $row)
            {
               $VAT_nurse = $row['VAT_nurse'];
               echo("<option value=\"$VAT_nurse\">$VAT_nurse</option>");
             }
             $connection = null;
          ?>
         </select>
       </p>
        <p><input type="submit" value="Add Nurse"/></p>
      </form>
      <h4> Add Diagnostic: </h4>
      <form action="update_info_consultation_diagnostic.php" method="post"
         VAT_doctor = VAT_doctor Date=Date VAT_client=VAT_client
         Diagnostic_ID=Diagnostic_ID>
         <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
         <input type="hidden" name="VAT_doctor" value="<?=$_REQUEST['VAT_doctor']?>">
         <input type="hidden" name="Date" value="<?=$_REQUEST['Date']?>">
         <p>Availabe Diagnostic ID and Description:
           <select name="Diagnostic_ID" required>
           <?php
             include 'connect_db.php';

             /*Selects the remaining diagnostic codes*/
             $sql = "SELECT DISTINCT ID, description FROM diagnostic_code
             WHERE ID NOT IN (SELECT DISTINCT ID FROM consultation_diagnostic as cd
             WHERE cd.date_timestamp= ? AND cd.VAT_doctor = ? );";
             $stat = $connection->prepare($sql);
             // prepare() can fail because of syntax errors, missing privileges, ....
             if (false===$stat)
             {
                die('prepare() failed: ' . htmlspecialchars($mysqli->error));
             }

             $VAT_doctor_SELECTED = $_REQUEST['VAT_doctor'];
             $date_timestamp_SELECTED = $_REQUEST['Date'];

             $result = $stat->execute([$date_timestamp_SELECTED, $VAT_doctor_SELECTED]);
             if ($result == FALSE)
             {
               $info = $connection->errorInfo();
               echo("<p>Error: {$info[2]}</p>");
               exit();
             }

             $result = $stat->fetchAll();
             foreach($result as $row)
             {
                $Diagnostic_ID = $row['ID'];
                $Description = $row['ID'].", ".$row['description'];
                echo("<option value=\"$Diagnostic_ID\">$Description</option>");
              }
              $connection = null;
           ?>
          </select>
        </p>
        <p><input type="submit" value="Add Diagnostic Code"/></p>
      </form>
      <h4> Add Prescription: </h4>
      <form action="update_info_consultation_prescription.php" method="post"
         VAT_doctor = VAT_doctor Date=Date ID_diagnostic_prescription=ID_diagnostic_prescription VAT_client=VAT_client
         Medication_Name=Medication_Name dosage=dosage description=description>
         <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
         <input type="hidden" name="VAT_doctor" value="<?=$_REQUEST['VAT_doctor']?>">
         <input type="hidden" name="Date" value="<?=$_REQUEST['Date']?>">
         <p>Available Diagnostic Code:
           <select name="ID_diagnostic_prescription" required>
           <?php
             include 'connect_db.php';

             /*Selects the remaining diagnostic codes*/
             $sql = "SELECT DISTINCT ID FROM consultation_diagnostic as cd
             WHERE cd.date_timestamp='$date_timestamp_SELECTED'
             AND cd.VAT_doctor = '$VAT_doctor_SELECTED'
             AND ID NOT IN (SELECT DISTINCT ID FROM prescription as p
             WHERE p.date_timestamp= ? AND p.VAT_doctor = ? );";
             $stat = $connection->prepare($sql);
             // prepare() can fail because of syntax errors, missing privileges, ....
             if (false===$stat)
             {
                die('prepare() failed: ' . htmlspecialchars($mysqli->error));
             }

             $VAT_doctor_SELECTED = $_REQUEST['VAT_doctor'];
             $date_timestamp_SELECTED = $_REQUEST['Date'];

             $result = $stat->execute([$date_timestamp_SELECTED, $VAT_doctor_SELECTED]);
             if ($result == FALSE)
             {
               $info = $connection->errorInfo();
               echo("<p>Error: {$info[2]}</p>");
               exit();
             }

             echo("<table border=\"1\">");
             $result = $stat->fetchAll();
             foreach($result as $row)
             {
                $ID_diagnostic_prescription = $row['ID'];
                echo("<option value=\"$ID_diagnostic_prescription\">$ID_diagnostic_prescription</option>");
              }
              $connection = null;
           ?>
          </select>
        </p>
         <p>Prescription Info:
           <select name="Medication_Name" required>
           <?php
             include 'connect_db.php';

             $sql = "SELECT * FROM medication;";
             $stat = $connection->prepare($sql);
             // prepare() can fail because of syntax errors, missing privileges, ....
             if (false===$stat)
             {
                die('prepare() failed: ' . htmlspecialchars($mysqli->error));
             }

             $VAT_doctor_SELECTED = $_REQUEST['VAT_doctor'];
             $date_timestamp_SELECTED = $_REQUEST['Date'];

             $result = $stat->execute();
             if ($result == FALSE)
             {
               $info = $connection->errorInfo();
               echo("<p>Error: {$info[2]}</p>");
               exit();
             }

             echo("<table border=\"1\">");
             $result = $stat->fetchAll();
             foreach($result as $row)
             {
                $name = $row['name_'];
                $Medication_Lab = $row['lab'];
                $Medication_Name = $name.", ".$Medication_Lab;
                echo("<option value=\"$Medication_Name\">$Medication_Name</option>");
              }
              $connection = null;
           ?>
          </select>
        </p>
        <p>Dosage : <input type="text" name="dosage" required/></p>
        <p>Description : <input type="text" name="description" required/></p>
        <p><input type="submit" value="Add Prescription"/></p>
      </form>
      <h4>Atention! Once you go back, you cant add more info!: </h4>
      <form action="appointment_info.php" method="post" VAT_client=VAT_client>
        <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
          <p><input type="submit" value="Back to Appointment/Consultation list"/></p>
      </form>
   </body>
</html>
