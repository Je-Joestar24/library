
/*
 * Stored Procedure: signup_member
 * Description: Creates a new library member record with basic information
 * Parameters:
 *   - p_first_name: Member's first name (VARCHAR(100))
 *   - p_last_name: Member's last name (VARCHAR(100)) 
 *   - p_email: Member's email address (VARCHAR(255))
 *   - p_phone_number: Member's contact number (VARCHAR(20))
 *   - p_address: Member's physical address (TEXT)
 * Returns: None
 * Notes: 
 *   - Does not perform email validation or duplicate checking
 */

CREATE PROCEDURE signup_member(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email VARCHAR(255),
    IN p_pass VARCHAR(200),
    IN p_phone_number VARCHAR(20),
    IN p_address TEXT
)
BEGIN
    INSERT INTO members (first_name, last_name, email, password, phone_number, address)
    VALUES (p_first_name, p_last_name, p_email, SHA2(p_pass, 256), p_phone_number, p_address);
END //