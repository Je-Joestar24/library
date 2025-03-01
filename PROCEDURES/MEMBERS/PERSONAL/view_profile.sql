
/*
 * Stored Procedure: view_member_profile
 * Description: Retrieves profile information for a specific member
 * Parameters:
 *   - p_member_id: ID of the member to view (INT)
 * Returns: Member's full profile including contact details
 * Example Usage: CALL view_member_profile(1)
 * Notes:
 *   - Returns all non-sensitive member information
 *   - Password is excluded from results
 */
CREATE PROCEDURE view_member_profile(
    IN p_member_id INT
)
BEGIN
    SELECT 
        member_id,
        first_name,
        last_name,
        email,
        phone_number,
        address
    FROM members
    WHERE member_id = p_member_id;
END //