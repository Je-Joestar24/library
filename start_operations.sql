
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


-- -------LIBRARIAN DISPLAY CALLS

-- Test display_books with different combinations
CALL display_books(NULL, NULL, NULL); -- Show all books without filters
CALL display_books('Harry', NULL, NULL); -- Search for books with 'Harry' in title
CALL display_books(NULL, TRUE, NULL); -- Show only available books
CALL display_books(NULL, FALSE, NULL); -- Show only unavailable books
CALL display_books(NULL, NULL, TRUE); -- Show all books sorted by title
CALL display_books('Potter', TRUE, TRUE); -- Search 'Potter', only available, sorted by title

-- Test view_book_details
CALL view_book_details(1); -- View details of book ID 1

-- Test display_authors with different combinations
CALL display_authors(NULL, NULL); -- Show all authors without filters
CALL display_authors('John', NULL); -- Search for authors with 'John' in name
CALL display_authors(NULL, TRUE); -- Show all authors sorted by name
CALL display_authors('Smith', TRUE); -- Search 'Smith' and sort by name

-- Test display_categories with different combinations
CALL display_categories(NULL, NULL); -- Show all categories without filters
CALL display_categories('Fiction', NULL); -- Search for categories with 'Fiction'
CALL display_categories(NULL, TRUE); -- Show all categories sorted by name
CALL display_categories('Science', TRUE); -- Search 'Science' and sort by name

-- Test display_users with different combinations
CALL display_users(NULL, NULL); -- Show all users without filters
CALL display_users('Jane', NULL); -- Search for users with 'Jane' in name/email/phone
CALL display_users(NULL, TRUE); -- Show all users sorted by name
CALL display_users('doe@email.com', TRUE); -- Search by email and sort by name

-- Test display_borrowed_books with different combinations
CALL display_borrowed_books(NULL, NULL, NULL); -- Show all borrowings
CALL display_borrowed_books('John', NULL, NULL); -- Search borrowings by member name
CALL display_borrowed_books(NULL, 'borrowed', NULL); -- Show only currently borrowed books
CALL display_borrowed_books(NULL, 'returned', NULL); -- Show only returned books
CALL display_borrowed_books(NULL, 'overdue', NULL); -- Show only overdue books
CALL display_borrowed_books(NULL, NULL, TRUE); -- Show all borrowings sorted by book name
CALL display_borrowed_books('Smith', 'borrowed', TRUE); -- Search by name, show borrowed, sort by book


-- -------LIBRARIAN DISPLAY CALLS