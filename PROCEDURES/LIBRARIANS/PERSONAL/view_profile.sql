
/*
 * Stored Procedure: view_librarian_profile
 * Description: Retrieves profile information for a specific librarian
 * Parameters:
 *   - p_librarian_id: ID of the librarian to view (INT)
 * Returns: Librarian's basic profile information
 * Example Usage: CALL view_librarian_profile(1)
 * Notes:
 *   - Returns only basic librarian information
 *   - Password is excluded from results
 */
CREATE PROCEDURE view_librarian_profile(
    IN p_librarian_id INT
)
BEGIN
    SELECT 
        librarian_id,
        first_name,
        last_name,
        email
    FROM librarians
    WHERE librarian_id = p_librarian_id;
END //