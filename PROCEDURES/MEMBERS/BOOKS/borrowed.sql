
/*
 * Stored Procedure: member_borrowed_books
 * Description: Lists all books currently borrowed by a member
 * Parameters:
 *   - p_member_id: ID of the member (INT)
 * Returns: Titles of books currently borrowed
 * Example Usage: CALL member_borrowed_books(1)
 * Notes:
 *   - Only shows unreturned books
 *   - Uses RIGHT JOIN to ensure all borrowed books are included
 */
CREATE PROCEDURE member_borrowed_books(
    IN p_member_id INT
)
BEGIN
    SELECT b.title
    FROM borrowings br
    RIGHT JOIN books b ON br.book_id = b.book_id
    WHERE br.member_id = p_member_id
    AND br.returned_at IS NULL;
END //