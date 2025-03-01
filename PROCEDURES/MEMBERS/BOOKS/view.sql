
/*
 * Stored Procedure: book_view
 * Description: Retrieves detailed information for a specific book
 * Parameters:
 *   - p_book_id: ID of the book to view (INT)
 * Returns: Book details including title, authors, categories, availability and borrow history
 * Example Usage: CALL book_view(1)
 * Notes:
 *   - Authors and categories are concatenated lists
 *   - Includes total times borrowed count
 */
CREATE PROCEDURE book_view(
    IN p_book_id INT
)
BEGIN
    SELECT 
        b.title,
        GROUP_CONCAT(DISTINCT a.full_name) as authors,
        GROUP_CONCAT(DISTINCT c.category_name) as categories,
        b.copies_available,
        COUNT(DISTINCT orrowing_id) as times_borrowed
    FROM books b
    LEFT JOIN book_authors ba ON b.book_id = ba.book_id
    LEFT JOIN authors a ON ba.author_id = a.author_id
    LEFT JOIN book_category bc ON b.book_id = bc.book_id
    LEFT JOIN categories c ON bc.category_id = c.category_id
    LEFT JOIN borrowings br ON b.book_id = br.book_id
    WHERE b.book_id = p_book_id
    GROUP BY b.book_id;
END //