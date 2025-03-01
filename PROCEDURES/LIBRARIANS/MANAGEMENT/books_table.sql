
/*
 * Display Books Table
 * ------------------
 * Allows librarians to view and filter the book inventory
 *
 * Parameters:
 * - p_search_title: Optional search term to filter books by title
 * - p_filter_available: When true, shows only books with copies available
 *                      When false, shows only books with no copies
 *                      When null, shows all books
 * - p_sort_by_title: When true, sorts results alphabetically by title
 *                    When false/null, sorts by book ID
 *
 * Returns: Book ID, title, creation date, and available copies
 */
CREATE PROCEDURE display_books(
    IN p_search_title VARCHAR(255),
    IN p_filter_available BOOLEAN,
    IN p_sort_by_title BOOLEAN
)
BEGIN
    SELECT 
        b.book_id,
        b.title,
        b.created_at,
        b.copies_available
    FROM books b
    WHERE 
        (p_search_title IS NULL OR b.title LIKE CONCAT('%', p_search_title, '%'))
        AND (p_filter_available IS NULL OR 
            CASE 
                WHEN p_filter_available = 1 THEN b.copies_available > 0
                ELSE b.copies_available = 0
            END)
    ORDER BY
        CASE WHEN p_sort_by_title = 1 THEN b.title END ASC,
        CASE WHEN p_sort_by_title = 0 OR p_sort_by_title IS NULL THEN b.book_id END ASC;
END //