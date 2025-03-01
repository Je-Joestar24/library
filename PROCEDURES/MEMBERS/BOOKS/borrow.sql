
/*
 * Stored Procedure: borrow_book
 * Description: Records a book borrowing and updates inventory
 * Parameters:
 *   - p_member_id: ID of the borrowing member (INT)
 *   - p_book_id: ID of the book being borrowed (INT)
 * Returns: None
 * Example Usage: CALL borrow_book(1, 5)
 * Notes:
 *   - Creates borrowing record with 14 day due date
 *   - Decrements available copies count
 *   - Does not validate copy availability
 */
CREATE PROCEDURE borrow_book(
    IN p_member_id INT,
    IN p_book_id INT
)
BEGIN
    INSERT INTO borrowings (member_id, book_id, due_date)
    VALUES (p_member_id, p_book_id, DATE_ADD(CURRENT_DATE, INTERVAL 14 DAY));
    
    UPDATE books 
    SET copies_available = copies_available - 1
    WHERE book_id = p_book_id;
END //
