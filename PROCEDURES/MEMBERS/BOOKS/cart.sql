
/*
 * Stored Procedure: member_cart
 * Description: Lists all books in a member's cart
 * Parameters:
 *   - p_member_id: ID of the member (INT)
 * Returns: Titles of books in cart
 * Example Usage: CALL member_cart(1)
 * Notes:
 *   - Uses RIGHT JOIN to ensure all cart items are included
 */
CREATE PROCEDURE member_cart(
    IN p_member_id INT
)
BEGIN
    SELECT b.title
    FROM book_cart bc
    RIGHT JOIN books b ON bc.book_id = b.book_id
    WHERE bc.member_id = p_member_id;
END //
