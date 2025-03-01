
/*
 * Stored Procedure: change_librarian_password
 * Description: Updates password for a specific librarian after verification
 * Parameters:
 *   - p_librarian_id: ID of the librarian (INT)
 *   - p_old_password: Current password for verification (VARCHAR(256))
 *   - p_new_password: New password to set (VARCHAR(256))
 * Returns: Success/failure message
 * Example Usage: CALL change_librarian_password(1, 'oldpass123', 'newpass123')
 * Notes:
 *   - Verifies old password before allowing change
 *   - Passwords are hashed using SHA2
 */
CREATE PROCEDURE change_librarian_password(
    IN p_librarian_id INT,
    IN p_old_password VARCHAR(256),
    IN p_new_password VARCHAR(256)
)
BEGIN
    DECLARE password_matches INT;
    
    -- Check if old password matches
    SELECT COUNT(*) INTO password_matches
    FROM librarians
    WHERE librarian_id = p_librarian_id 
    AND password = SHA2(p_old_password, 256);
    
    IF password_matches = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Current password is incorrect';
    ELSE
        UPDATE librarians
        SET password = SHA2(p_new_password, 256)
        WHERE librarian_id = p_librarian_id;
        
        SELECT 'Password updated successfully' as message;
    END IF;
END //
