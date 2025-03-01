
/*
 * Stored Procedure: member_login
 * Description: Authenticates a library member using email and password
 * Parameters:
 *   - p_email: Member's registered email address (VARCHAR(255))
 *   - p_password: Member's password, will be hashed with SHA2 (VARCHAR(255))
 * Returns: Member details (ID, name, email) if credentials match
 * Example Usage: CALL member_login('john@email.com', 'password123')
 * Notes:
 *   - Password is hashed using SHA2 with 256-bit output
 *   - Returns empty result if credentials don't match
 */
CREATE PROCEDURE member_login(
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE member_exists INT;
    
    -- Check if credentials match
    SELECT 
        member_id,
        first_name,
        last_name,
        email
    FROM members 
    WHERE email = p_email 
    AND password = SHA2(p_password, 256);
    
END //