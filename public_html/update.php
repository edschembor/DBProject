<head>
  <title>Change student's midterm scores</title>
 </head>
<body>

<?php

$dbhost = 'dbase.cs.jhu.edu';
$dbuser = 'cs41515_vamaral1';
$dbpass = 'TOYNJAAE';

// Create connection
$conn = mysql_connect($dbhost, $dbuser, $dbpass);
// Check connection
if (!$conn) {
    die("Connection failed");
} else {

  $pass = $_POST['password'];
  $ssn = $_POST['ssn'];
  $new_score = $_POST['new_score'];

  mysql_select_db("cs41515_vamaral1_db", $conn);
  $result = mysql_query("CALL UpdateMidterm('".$pass."'," .$ssn."," .$new_score.");") or die(mysql_error()); 
  if (!$result) {

    echo "Query failed!\n";
    print mysql_error();

  } else {

    echo "<table border=1>\n";
    echo "<tr><td>SSN</td><td>LName</td><td>FName</td><td>Section</td><td>HW1</td><td>HW2a</td><td>HW2b</td><td>Midterm</td><td>HW3</td><td>FExam</td></tr>\n";

    while ($myrow = mysql_fetch_array($result)) {
      printf("<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $myrow["SSN"], $myrow["LName"], $myrow["FName"], $myrow["Section"], $myrow["HW1"], $myrow["HW2a"], $myrow["HW2b"], $myrow["Midterm"], $myrow["HW3"], $myrow["FExam"]);
    }

    echo "</table>\n";

  }
}

mysql_close($conn);
?>

</body>