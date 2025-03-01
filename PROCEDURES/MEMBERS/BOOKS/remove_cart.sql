
/*
 * Stored Procedure: remove_from_cart
 * Description: Removes a book from a member's cart
 * Parameters:
 *   - p_member_id: ID of the member removing from cart (INT)
 *   - p_book_id: ID of the book to remove (INT)
 * Returns: None
 * Example Usage: CALL remove_from_cart(1, 5)
 * Notes:
 *   - Deletes the cart entry for the specified member and book
 *   - No error if entry doesn't exist
 */
CREATE PROCEDURE remove_from_cart(
    IN p_member_id INT,
    IN p_book_id INT
)
BEGIN
    DELETE FROM book_cart 
    WHERE member_id = p_member_id AND book_id = p_book_id;
END //
