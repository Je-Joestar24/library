
/*
 * Stored Procedure: edit_librarian_profile
 * Description: Updates profile information for a specific librarian
 * Parameters:
 *   - p_librarian_id: ID of the librarian to update (INT)
 *   - p_first_name: New first name (VARCHAR(100))
 *   - p_last_name: New last name (VARCHAR(100))
 * Returns: Updated librarian profile
 * Example Usage: CALL edit_librarian_profile(1, 'Jane', 'Doe')
 * Notes:
 *   - Uses COALESCE to only update provided fields
 *   - Limited to name changes only for security
 */
CREATE PROCEDURE edit_librarian_profile(
    IN p_librarian_id INT,
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100)
)
BEGIN
    UPDATE librarians
    SET 
        first_name = COALESCE(p_first_name, first_name),
        last_name = COALESCE(p_last_name, last_name)
    WHERE librarian_id = p_librarian_id;
    
    -- Return updated profile
    SELECT * FROM librarians WHERE librarian_id = p_librarian_id;
END //