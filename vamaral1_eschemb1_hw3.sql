Query A:

DELIMITER //
DROP PROCEDURE IF EXISTS ShowRawScores;
CREATE PROCEDURE ShowRawScores(IN ssn INT)
BEGIN
IF EXISTS(SELECT * FROM Rawscores as R WHERE R.SSN = ssn) THEN
    BEGIN
	SELECT * FROM Rawscores as R WHERE R.SSN = ssn;
	END;
ELSE
    BEGIN
	SELECT "SSN Incorrect";
	END;
END IF;
END//
DELIMITER ;


Query B:

DELIMITER //
DROP PROCEDURE IF EXISTS ShowPercentages;
CREATE PROCEDURE ShowPercentages(IN ssn INT)
BEGIN
IF EXISTS(SELECT * FROM Rawscores as R WHERE R.SSN = ssn) THEN
    BEGIN
	SELECT (R.HW1*((1/R2.HW1)*Weight.HW1)+(R.HW2a*(1/R2.HW2a)*Weight.HW2a) +(R.HW2b*(1/R2.HW2b)*Weight.HW2b)+(R.Midterm*(1/R2.Midterm)*Weight.Midterm)+(R.HW3*(1/R2.HW3)*Weight.HW3)+(R.FExam*(1/R2.FExam)*Weight.FExam))*100 as WeightedAvg, ((R.HW1/R2.HW1)*100) as HW1, ((R.HW2a/R2.HW2a)*100) as HW2a, ((R.HW2b/R2.HW2b)*100) as HW2b, ((R.Midterm/R2.Midterm)*100) as Midterm, ((R.HW3/R2.HW3)*100) as HW3, ((R.FExam/R2.FExam)*100) as Final FROM Rawscores as R, Rawscores as R2, Rawscores as Weight WHERE R.SSN = ssn and R2.SSN = "0001" and Weight.SSN = "0002";
	END;
ELSE
    BEGIN
	SELECT "SSN Incorrect";
	END;
END IF;
END//
DELIMITER ;



Query C:

DELIMITER //
DROP PROCEDURE IF EXISTS AllRawScores;
CREATE PROCEDURE AllRawScores(IN pass VARCHAR(20))
BEGIN
IF EXISTS(SELECT CurPasswords FROM Passwords WHERE CurPasswords = pass) THEN
    BEGIN
	SELECT * FROM Rawscores WHERE Rawscores.SSN <> 0001 AND Rawscores.SSN <> 0002;
	END;
ELSE
    BEGIN
	SELECT "Password Incorrect";
	END;
END IF;
END//
DELIMITER ;


Query D:

DELIMITER //
DROP PROCEDURE IF EXISTS AllPercentages;
CREATE PROCEDURE AllPercentages(IN pass VARCHAR(20))
BEGIN

IF EXISTS(SELECT CurPasswords FROM Passwords WHERE CurPasswords = pass) THEN
    BEGIN
    SELECT R.SSN, ((R.HW1*(1/Total.HW1)*Weight.HW1)+(R.HW2a*(1/Total.HW2a)*Weight.HW2a) +(R.HW2b*(1/Total.HW2b)*Weight.HW2b)+(R.Midterm*(1/Total.Midterm)*Weight.Midterm)+(R.HW3*(1/Total.HW3)*Weight.HW3)+(R.FExam*(1/Total.FExam)*Weight.FExam))*100 as WeightedAvg, ((R.HW1/Total.HW1)*100) as HW1, ((R.HW2a/Total.HW2a)*100) as HW2a, ((R.HW2b/Total.HW2b)*100) as HW2b, ((R.Midterm/Total.Midterm)*100) as Midterm, ((R.HW3/Total.HW3)*100) as HW3, ((R.FExam/Total.FExam)*100) as FExam FROM Rawscores as R, Rawscores as Total, Rawscores as Weight WHERE Total.SSN = "0001" and Weight.SSN = "0002" and R.SSN <> "0001" and R.SSN <> "0002" ORDER BY R.Section, WeightedAvg;
	END;
ELSE
    BEGIN
	SELECT "Password Incorrect";
	END;
END IF;
END//
DELIMITER ;


Query E:

DELIMITER //
DROP PROCEDURE IF EXISTS Stats;
CREATE PROCEDURE Stats(IN pass VARCHAR(20))
BEGIN

IF EXISTS(SELECT CurPasswords FROM Passwords WHERE CurPasswords = pass) THEN
    BEGIN
	
	/* All Percentages */
	CALL AllPercentages(pass);

    /* Mean */
    SELECT "Mean" as Statistic, avg(R.HW1)/R2.HW1*100 as HW1, avg(R.HW2a)/R2.HW2a*100 as HW2a, avg(R.HW2b)/R2.HW2b*100 as HW2b, avg(R.Midterm)/R2.Midterm*100 as Midterm, avg(R.HW3)/R2.HW3*100 as HW3, avg(R.FExam)/R2.FExam*100 as FExam, avg((R.HW1*((1/R2.HW1)*Weight.HW1)+(R.HW2a*(1/R2.HW2a)*Weight.HW2a) +(R.HW2b*(1/R2.HW2b)*Weight.HW2b)+(R.Midterm*(1/R2.Midterm)*Weight.Midterm)+(R.HW3*(1/R2.HW3)*Weight.HW3)+(R.FExam*(1/R2.FExam)*Weight.FExam))*100) as CumAvg FROM Rawscores as R, Rawscores as R2, Rawscores as Weight WHERE R2.SSN = "0001" and R.SSN != "0001" and R.SSN != "0002" and Weight.SSN = "0002";
	
	/* Max */
	SELECT "Maximum" as Statistic, max(R.HW1)/R2.hw1*100 as HW1, max(R.HW2a)/R2.HW2a*100 as HW2a, max(R.HW2b)/R2.HW2b*100 as HW2b, max(R.Midterm)/R2.Midterm*100 as Midterm, max(R.HW3)/R2.HW3*100 as HW3, max(R.FExam)/R2.FExam*100 as FExam, max((R.HW1*((1/R2.HW1)*Weight.HW1)+(R.HW2a*(1/R2.HW2a)*Weight.HW2a) +(R.HW2b*(1/R2.HW2b)*Weight.HW2b)+(R.Midterm*(1/R2.Midterm)*Weight.Midterm)+(R.HW3*(1/R2.HW3)*Weight.HW3)+(R.FExam*(1/R2.FExam)*Weight.FExam))*100) as CumAvg FROM Rawscores as R, Rawscores as R2, Rawscores as Weight WHERE R2.SSN = "0001" and R.SSN != "0001" and R.SSN != "0002" and Weight.SSN = "0002";
	
    /* Min */
	SELECT "Minimum" as Statistic, min(R.HW1)/R2.hw1*100 as HW1, min(R.HW2a)/R2.HW2a*100 as HW2a, min(R.HW2b)/R2.HW2b*100 as HW2b, min(R.Midterm)/R2.Midterm*100 as Midterm, min(R.HW3)/R2.HW3*100 as HW3, min(R.FExam)/R2.FExam*100 as FExam, min((R.HW1*((1/R2.HW1)*Weight.HW1)+(R.HW2a*(1/R2.HW2a)*Weight.HW2a) +(R.HW2b*(1/R2.HW2b)*Weight.HW2b)+(R.Midterm*(1/R2.Midterm)*Weight.Midterm)+(R.HW3*(1/R2.HW3)*Weight.HW3)+(R.FExam*(1/R2.FExam)*Weight.FExam))*100) as CumAvg FROM Rawscores as R, Rawscores as R2, Rawscores as Weight WHERE R2.SSN = "0001" and R.SSN != "0001" and R.SSN != "0002" and Weight.SSN = "0002";
	
	/* Std Dev*/
	SELECT "StdDeviation" as Statistic, std(R.HW1) as HW1, std(R.HW2a) as HW2a, std(R.HW2b) as HW2b, std(R.Midterm) as Midterm, std(R.HW3) as HW3, std(R.FExam) as FExam, std((R.HW1*((1/R2.HW1)*Weight.HW1)+(R.HW2a*(1/R2.HW2a)*Weight.HW2a) +(R.HW2b*(1/R2.HW2b)*Weight.HW2b)+(R.Midterm*(1/R2.Midterm)*Weight.Midterm)+(R.HW3*(1/R2.HW3)*Weight.HW3)+(R.FExam*(1/R2.FExam)*Weight.FExam))*100) as CumAvg FROM Rawscores as R, Rawscores as R2, Rawscores as Weight WHERE R2.SSN = "0001" and R.SSN != "0001" and R.SSN != "0002" and Weight.SSN = "0002";
	
	END;
ELSE
    BEGIN
	SELECT "Password Incorrect";
	END;
END IF;
END//
DELIMITER ;



Query F:

DELIMITER //
DROP PROCEDURE IF EXISTS ChangeScores;
CREATE PROCEDURE ChangeScores(IN pass VARCHAR(20), IN ssn INT, IN assignmentName VARCHAR(20), IN newVal DOUBLE)
BEGIN
IF EXISTS(SELECT CurPasswords FROM Passwords WHERE CurPasswords = pass) THEN
    BEGIN
	SELECT * FROM Rawscores as R, Passwords as P WHERE P.CurPasswords = pass and R.SSN <> 0001 and R.SSN <> 0002;
	SET @sql = CONCAT('UPDATE Rawscores SET ', assignmentName, ' = ', newVal, ' WHERE Rawscores.SSN = ', ssn, ';');
  	PREPARE stmt FROM @sql;
  	EXECUTE stmt;
  	DEALLOCATE PREPARE stmt;
  	SELECT * FROM Rawscores as R, Passwords as P WHERE P.CurPasswords = pass and R.SSN <> 0001 and R.SSN <> 0002;
	END;
ELSE
    BEGIN
	SELECT "Password Incorrect";
	END;
END IF;
END//
DELIMITER ;



Query G:

DELIMITER //
DROP PROCEDURE IF EXISTS UpdateMidterm;
CREATE PROCEDURE UpdateMidterm(IN pass VARCHAR(20), IN ssn INT, IN newVal DOUBLE)
BEGIN
IF EXISTS(SELECT CurPasswords FROM Passwords WHERE CurPasswords = pass) THEN
	SET @sql = CONCAT('UPDATE Rawscores SET Rawscores.Midterm = ', newVal, ' WHERE Rawscores.SSN = ', ssn, ';');
  	PREPARE stmt FROM @sql;
  	EXECUTE stmt;
  	DEALLOCATE PREPARE stmt;
  	SELECT * FROM Rawscores as R, Passwords as P WHERE P.CurPasswords = pass and R.SSN <> 0001 and R.SSN <> 0002;
ELSE
    BEGIN
	SELECT "Password Incorrect";
	END;
END IF;
END//
DELIMITER ;
