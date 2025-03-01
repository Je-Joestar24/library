
/*
 * Display Authors
 * --------------
 * Lists all authors with their book counts and optional filtering/sorting
 *
 * Parameters:
 * - p_search_name: Optional search term to filter authors by name
 * - p_sort_by_name: When true, sorts results alphabetically by author name
 *                   When false/null, sorts by author ID
 *
 * Returns: Author ID, full name, and total number of books by author
 */
CREATE PROCEDURE display_authors(
    IN p_search_name VARCHAR(255),
    IN p_sort_by_name BOOLEAN
)
BEGIN
    SELECT 
        a.author_id,
        a.full_name,
        COUNT(DISTINCT ba.book_id) as number_of_books
    FROM authors a
    LEFT JOIN book_authors ba ON a.author_id = ba.author_id
    WHERE 
        p_search_name IS NULL OR 
        a.full_name LIKE CONCAT('%', p_search_name, '%')
    GROUP BY a.author_id
    ORDER BY
        CASE WHEN p_sort_by_name = 1 THEN a.full_name END ASC,
        CASE WHEN p_sort_by_name = 0 OR p_sort_by_name IS NULL THEN a.author_id END ASC;
END //