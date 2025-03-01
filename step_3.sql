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


-- -------MEMBER PROCEURE CALLS

-- add_to_cart examples
CALL add_to_cart(1, 1); -- Add book ID 5 to member ID 1's cart

-- remove_from_cart examples 
CALL remove_from_cart(1, 1); -- Remove book ID 5 from member ID 1's cart

-- borrow_book examples
CALL borrow_book(1, 1); -- Member ID 1 borrows book ID 20

-- return_book examples
CALL return_book(1); -- Return borrowing ID 1

-- popular_available_books examples
CALL popular_available_books(); -- Get top 5 most borrowed available books

-- book_cards examples
CALL book_cards('Harry Potter', NULL, TRUE); -- Search by title, no category filter, sort by title
CALL book_cards(NULL, 1, FALSE); -- No title search, filter by category ID 1, sort by ID
CALL book_cards('Lord', 2, TRUE); -- Search title containing 'Lord', filter by category ID 2, sort by title

-- book_view examples
CALL book_view(1); -- View details for book ID 1

-- member_borrowed_books examples
CALL member_borrowed_books(1); -- List books borrowed by member ID 1

-- member_cart examples
CALL member_cart(1); -- List books in member ID 1's cart