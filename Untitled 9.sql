DELIMITER $$

DROP PROCEDURE IF EXISTS sp_CreateEmp $$

CREATE PROCEDURE `sp_CreateEmp`(
    IN p_EmpImg LONGBLOB, 
    IN p_EmpName VARCHAR(255),
    IN p_HashedPassword VARCHAR(255),
    IN p_EmpFatherName VARCHAR(255),
    IN p_MobileNo VARCHAR(100),
    IN p_Address VARCHAR(255),
    IN p_NRC VARCHAR(255),
    IN p_Salary INT,
    IN p_BirthDate DATE,
    IN p_HiredDate DATE,
    IN p_Position VARCHAR(100),
    IN p_Gender VARCHAR(100),
    IN p_MaritalStatus VARCHAR(100)
)
BEGIN
    -- Declare error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction in case of an error
        ROLLBACK;
        -- Optionally, log the error here for debugging purposes
    END;

    -- Start a transaction
    START TRANSACTION;
    
    -- Insert into hr_emp_lists table
    INSERT INTO hr_emp_lists (
        e_photo, 
        e_name, 
        department, 
        tel_no, 
        hire_date, 
        retired_date, 
        nrc, 
        birth_date, 
        home_address, 
        father_name, 
        current_fixed_salary_amount, 
        active_yn, 
        `gender_m/w`
    ) 
    VALUES (
        p_EmpImg, 
        p_EmpName, 
        p_Position, 
        p_MobileNo, 
        p_HiredDate, 
        NULL, 
        p_NRC, 
        p_BirthDate, 
        p_Address, 
        p_EmpFatherName, 
        p_Salary, 
        'Y', 
        CASE 
            WHEN p_Gender = 'Male' THEN 'M'
            WHEN p_Gender = 'Female' THEN 'W'
            ELSE 'O' 
        END
    );

    -- Insert into Teller table
    INSERT INTO Teller (
        TellerID,
        TellerName, 
        TellerAddress, 
        TellerIP, 
        TellerMachine, 
        TellerPassword, 
        LastChangedDate, 
        LastLoginDate, 
        LastLogoutDate, 
        CreatedAt, 
        UpdatedAt
    ) 
    VALUES (
        (SELECT e_id FROM hr_emp_lists WHERE e_name = p_EmpName AND father_name = p_EmpFatherName AND nrc = p_NRC LIMIT 1),
        p_EmpName, 
        p_Address, 
        '127.0.0.1', -- Replace with the dynamic IP if available
        'TellerMachineName', -- Replace with an actual machine name
        p_HashedPassword, 
        CURDATE(), 
        NOW(), 
        NULL, 
        NOW(), 
        NOW()
    );

    -- Commit the transaction
    COMMIT;
END $$

DELIMITER ;
