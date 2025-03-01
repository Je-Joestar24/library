
/*
 * Stored Procedure: change_member_password
 * Description: Updates password for a specific member after verification
 * Parameters:
 *   - p_member_id: ID of the member (INT)
 *   - p_old_password: Current password for verification (VARCHAR(256))
 *   - p_new_password: New password to set (VARCHAR(256))
 * Returns: Success/failure message
 * Example Usage: CALL change_member_password(1, 'oldpass123', 'newpass123')
 * Notes:
 *   - Verifies old password before allowing change
 *   - Passwords are hashed using SHA2
 *   - Updates timestamp on successful change
 */
CREATE PROCEDURE change_member_password(
    IN p_member_id INT,
    IN p_old_password VARCHAR(256),
    IN p_new_password VARCHAR(256)
)
BEGIN
    DECLARE password_matches INT;
    
    -- Check if old password matches
    SELECT COUNT(*) INTO password_matches
    FROM members
    WHERE member_id = p_member_id 
    AND password = SHA2(p_old_password, 256);
    
    IF password_matches = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Current password is incorrect';
    ELSE
        UPDATE members
        SET 
            password = SHA2(p_new_password, 256),
            updated_at = CURRENT_TIMESTAMP
        WHERE member_id = p_member_id;
        
        SELECT 'Password updated successfully' as message;
    END IF;
END //