
/*
 * Display Borrowed Books
 * --------------------
 * Shows all book borrowings with detailed member information and status
 *
 * Parameters:
 * - p_search_term: Optional search term to filter by member name, email, or phone
 * - p_filter_status: Optional filter for borrowing status (borrowed/returned/overdue)
 * - p_sort_by_book_name: When true, sorts results alphabetically by book title
 *                        When false/null, sorts by borrowing ID
 *
 * Returns: Borrowing details including:
 * - Borrowing ID, book title
 * - Member's full name, email, phone
 * - Due date and return status
 */
CREATE PROCEDURE display_borrowed_books(
    IN p_search_term VARCHAR(255),
    IN p_filter_status ENUM('borrowed', 'returned', 'overdue'),
    IN p_sort_by_book_name BOOLEAN
)
BEGIN
    SELECT 
        br.borrowing_id,
        b.title as book_name,
        m.full_name as member_name,
        m.email,
        m.phone_number,
        br.due_date,
        CASE 
            WHEN br.returned_at IS NOT NULL THEN 'Returned'
            ELSE 'Not Returned'
        END as return_status
    FROM borrowings br
    INNER JOIN books b ON br.book_id = b.book_id
    INNER JOIN members m ON br.member_id = m.member_id
    WHERE 
        (p_search_term IS NULL OR
        m.full_name LIKE CONCAT('%', p_search_term, '%') OR
        m.email LIKE CONCAT('%', p_search_term, '%') OR
        m.phone_number LIKE CONCAT('%', p_search_term, '%'))
        AND (p_filter_status IS NULL OR br.status = p_filter_status)
    ORDER BY
        CASE WHEN p_sort_by_book_name = 1 THEN b.title END ASC,
        CASE WHEN p_sort_by_book_name = 0 OR p_sort_by_book_name IS NULL THEN br.borrowing_id END ASC;
END //