
/*
 * Stored Procedure: return_book
 * Description: Processes a book return and updates inventory
 * Parameters:
 *   - p_borrowing_id: ID of the borrowing record (INT)
 * Returns: None
 * Example Usage: CALL return_book(1)
 * Notes:
 *   - Updates borrowing status to 'returned'
 *   - Records return timestamp
 *   - Increments available copies count
 */
CREATE PROCEDURE return_book(
    IN p_borrowing_id INT
)
BEGIN
    DECLARE v_book_id INT;
    
    SELECT book_id INTO v_book_id
    FROM borrowings
    WHERE borrowing_id = p_borrowing_id;
    
    UPDATE borrowings 
    SET returned_at = CURRENT_TIMESTAMP,
        status = 'returned'
    WHERE borrowing_id = p_borrowing_id;
    
    UPDATE books
    SET copies_available = copies_available + 1
    WHERE book_id = v_book_id;
END //