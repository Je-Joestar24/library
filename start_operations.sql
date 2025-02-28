
-- Initial Librarian
INSERT INTO librarians (first_name, last_name, email, password) VALUES
('Admin', 'Librarian', 'admin@library.com', SHA2('admin123', 256));

-- Example usage:
CALL signup_member('John', 'Doe', 'john.doe@email.com', 'John00', '+1234567890', '123 Main St');

-- Test member login
CALL member_login('john.doe@email.com', 'John00');

-- Test librarian login 
CALL librarian_login('admin@library.com', 'admin123');

-- Test view member profile
CALL view_member_profile(1);

-- Test view librarian profile
CALL view_librarian_profile(1);

-- Test edit member profile
CALL edit_member_profile(1, 'John', 'Smith', '+1987654321', '456 Oak Avenue');

-- Test change member password
CALL change_member_password(1, 'John00', 'John00');

-- Test change librarian password
CALL change_librarian_password(1, 'admin123', 'admin123');

-- OPERATIONS

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


-- -- CATEGORY -- --
-- Add Authors

CALL add_authors('[
    {"first_name": "George", "last_name": "Orwell"},
    {"first_name": "Jane", "last_name": "Austen"},
    {"first_name": "Stephen", "last_name": "Hawking"},
    {"first_name": "J.K.", "last_name": "Rowling"},
    {"first_name": "Ernest", "last_name": "Hemingway"}
]');

-- Add Author
CALL add_author('Test', 'Test');

-- Edit Author
CALL edit_author(6, 'Testor', 'Testor');

-- Delete Author
CALL delete_author(6);

-- Add a book with multiple authors and categories
CALL add_book(
    '1984',
    1949,
    '978-0451524',
    5,
    '[1]',  -- Author IDs
    '[1, 5]'  -- Category IDs: Fiction and Literature
);
CALL add_book('1981', 1949, '978-0451521', 5, '[2]', '[2, 5]');

-- Edit a book
CALL edit_book(1, '1984 (Revised)', 1949, '978-0451524', 10, '[1,2]', '[1,3]');

-- Delete a book
CALL delete_book(2);