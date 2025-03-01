
/*
 * Display Categories
 * ----------------
 * Lists all book categories with their book counts and optional filtering/sorting
 *
 * Parameters:
 * - p_search_name: Optional search term to filter categories by name
 * - p_sort_by_name: When true, sorts results alphabetically by category name
 *                   When false/null, sorts by category ID
 *
 * Returns: Category ID, name, and total number of books in category
 */
CREATE PROCEDURE display_categories(
    IN p_search_name VARCHAR(100),
    IN p_sort_by_name BOOLEAN
)
BEGIN
    SELECT 
        c.category_id,
        c.category_name,
        COUNT(DISTINCT bc.book_id) as number_of_books
    FROM categories c
    LEFT JOIN book_category bc ON c.category_id = bc.category_id
    WHERE 
        p_search_name IS NULL OR 
        c.category_name LIKE CONCAT('%', p_search_name, '%')
    GROUP BY c.category_id
    ORDER BY
        CASE WHEN p_sort_by_name = 1 THEN c.category_name END ASC,
        CASE WHEN p_sort_by_name = 0 OR p_sort_by_name IS NULL THEN c.category_id END ASC;
END //