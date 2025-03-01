
-- -- CATEGORY -- --

-- Add categories
CALL add_categories('["Fiction", "Non-Fiction", "Science", "Technology", "Literature"]');
-- -- END CATEGORY -- --

-- Add category
CALL add_category('Science Fiction');

-- Edit category
CALL edit_category(6, 'Science Fiction');

-- Delete category
CALL delete_category(6);