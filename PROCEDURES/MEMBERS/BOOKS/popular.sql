
/*
 * Stored Procedure: popular_available_books
 * Description: Lists the most frequently borrowed books that are currently available
 * Parameters: None
 * Returns: Book titles and their borrow counts
 * Example Usage: CALL popular_available_books()
 * Notes:
 *   - Only includes books with at least one borrow
 *   - Limited to top 5 most borrowed
 *   - Only shows currently available books
 */
CREATE PROCEDURE popular_available_books()
BEGIN
    SELECT 
        b.title,
        COUNT(br.borrowing_id) as borrow_count
    FROM books b
    LEFT JOIN borrowings br ON b.book_id = br.book_id
    WHERE b.copies_available > 0
    GROUP BY b.book_id, b.title
    HAVING COUNT(br.borrowing_id) > 0
    ORDER BY borrow_count DESC
    LIMIT 5;
END //