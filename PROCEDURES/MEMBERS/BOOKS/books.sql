
/*
 * Stored Procedure: book_cards
 * Description: Generates book listings with filtering and sorting options
 * Parameters:
 *   - p_search_title: Search term for book title (VARCHAR(255))
 *   - p_category_id: Filter by category ID (INT)
 *   - p_sort_by_title: Sort alphabetically by title when true (BOOLEAN)
 * Returns: Book details including title, authors, categories and availability
 * Example Usage: CALL book_cards('Harry', 1, true)
 * Notes:
 *   - Only shows available books
 *   - Authors and categories are concatenated lists
 *   - Supports partial title matching
 */
CREATE PROCEDURE book_cards(
    IN p_search_title VARCHAR(255),
    IN p_category_id INT,
    IN p_sort_by_title BOOLEAN
)
BEGIN
    SELECT 
        b.title,
        GROUP_CONCAT(DISTINCT a.full_name) as authors,
        GROUP_CONCAT(DISTINCT c.category_name) as categories,
        b.copies_available
    FROM books b
    LEFT JOIN book_authors ba ON b.book_id = ba.book_id
    LEFT JOIN authors a ON ba.author_id = a.author_id
    LEFT JOIN book_category bc ON b.book_id = bc.book_id
    LEFT JOIN categories c ON bc.category_id = c.category_id
    WHERE b.copies_available > 0
    AND (p_search_title IS NULL OR b.title LIKE CONCAT('%', p_search_title, '%'))
    AND (p_category_id IS NULL OR c.category_id = p_category_id)
    GROUP BY b.book_id
    ORDER BY 
        CASE WHEN p_sort_by_title = 1 THEN b.title END ASC,
        CASE WHEN p_sort_by_title = 0 OR p_sort_by_title IS NULL THEN b.book_id END ASC;
END //