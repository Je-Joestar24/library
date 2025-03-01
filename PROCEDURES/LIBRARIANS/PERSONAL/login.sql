
/*
 * Stored Procedure: librarian_login
 * Description: Authenticates a library staff member using email and password
 * Parameters:
 *   - p_email: Librarian's registered email address (VARCHAR(255))
 *   - p_password: Librarian's password, will be hashed with SHA2 (VARCHAR(255))
 * Returns: Librarian details (ID, name, email) if credentials match
 * Example Usage: CALL librarian_login('staff@library.com', 'staffpass')
 * Notes:
 *   - Password is hashed using SHA2 with 256-bit output
 *   - Returns empty result if credentials don't match
 */
CREATE PROCEDURE librarian_login(
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE librarian_exists INT;
    
    -- Check if credentials match
    SELECT 
        librarian_id,
        first_name, 
        last_name,
        email
    FROM librarians
    WHERE email = p_email
    AND password = SHA2(p_password, 256);
    
END //
