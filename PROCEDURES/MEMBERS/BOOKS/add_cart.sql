
/*
 * Stored Procedure: add_to_cart
 * Description: Adds a book to a member's cart for later borrowing
 * Parameters:
 *   - p_member_id: ID of the member adding to cart (INT)
 *   - p_book_id: ID of the book to add (INT)
 * Returns: None
 * Example Usage: CALL add_to_cart(1, 5)
 * Notes:
 *   - Creates a new cart entry linking the member and book
 *   - Does not check book availability
 */
CREATE PROCEDURE add_to_cart(
    IN p_member_id INT,
    IN p_book_id INT
)
BEGIN
    INSERT INTO book_cart (member_id, book_id)
    VALUES (p_member_id, p_book_id);
END //
