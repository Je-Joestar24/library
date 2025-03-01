
/*
 * Display Users
 * ------------
 * Lists library members with optional search and sorting capabilities
 *
 * Parameters:
 * - p_search_term: Optional search term to filter users by name, email, or phone
 * - p_sort_by_name: When true, sorts results alphabetically by member name
 *                   When false/null, sorts by member ID
 *
 * Returns: Member's first name, last name, email, and phone number
 */
CREATE PROCEDURE display_users(
    IN p_search_term VARCHAR(255),
    IN p_sort_by_name BOOLEAN
)
BEGIN
    SELECT 
        first_name,
        last_name,
        email,
        phone_number
    FROM members
    WHERE 
        p_search_term IS NULL OR
        first_name LIKE CONCAT('%', p_search_term, '%') OR
        last_name LIKE CONCAT('%', p_search_term, '%') OR
        email LIKE CONCAT('%', p_search_term, '%') OR
        phone_number LIKE CONCAT('%', p_search_term, '%')
    ORDER BY
        CASE WHEN p_sort_by_name = 1 THEN full_name END ASC,
        CASE WHEN p_sort_by_name = 0 OR p_sort_by_name IS NULL THEN member_id END ASC;
END //