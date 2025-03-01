
/*
 * View Specific Book Details
 * -------------------------
 * Retrieves detailed information about a specific book including authors and categories
 *
 * Parameters:
 * - p_book_id: The ID of the book to view
 *
 * Returns: Complete book details including:
 * - Book ID, title, publication year, ISBN
 * - Number of available copies
 * - Comma-separated list of authors
 * - Comma-separated list of categories
 */
CREATE PROCEDURE view_book_details(
    IN p_book_id INT
)
BEGIN
    SELECT 
        b.book_id,
        b.title,
        b.publication_year,
        b.isbn,
        b.copies_available,
        GROUP_CONCAT(DISTINCT a.full_name) as authors,
        GROUP_CONCAT(DISTINCT c.category_name) as categories
    FROM books b
    LEFT JOIN book_authors ba ON b.book_id = ba.book_id
    LEFT JOIN authors a ON ba.author_id = a.author_id
    LEFT JOIN book_category bc ON b.book_id = bc.book_id
    LEFT JOIN categories c ON bc.category_id = c.category_id
    WHERE b.book_id = p_book_id
    GROUP BY b.book_id;
END //