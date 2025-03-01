
/*
 * Stored Procedure: edit_member_profile
 * Description: Updates profile information for a specific member
 * Parameters:
 *   - p_member_id: ID of the member to update (INT)
 *   - p_first_name: New first name (VARCHAR(100))
 *   - p_last_name: New last name (VARCHAR(100))
 *   - p_phone_number: New phone number (VARCHAR(20))
 *   - p_address: New address (TEXT)
 * Returns: Updated member profile
 * Example Usage: CALL edit_member_profile(1, 'John', 'Smith', '+1234567890', '123 Main St')
 * Notes:
 *   - Uses COALESCE to only update provided fields
 *   - Automatically updates timestamp
 */
CREATE PROCEDURE edit_member_profile(
    IN p_member_id INT,
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_phone_number VARCHAR(20),
    IN p_address TEXT
)
BEGIN
    UPDATE members
    SET 
        first_name = COALESCE(p_first_name, first_name),
        last_name = COALESCE(p_last_name, last_name),
        phone_number = COALESCE(p_phone_number, phone_number),
        address = COALESCE(p_address, address),
        updated_at = CURRENT_TIMESTAMP
    WHERE member_id = p_member_id;
    
    -- Return updated profile
    SELECT * FROM members WHERE member_id = p_member_id;
END //