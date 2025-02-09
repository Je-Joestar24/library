/*
 * Mock Library Database Schema Documentation
 * ========================================
 *
 * This schema represents a comprehensive library management system with the following core entities
 * and functionality:
 *
 * Core Entities:
 * -------------
 * 1. Librarians - Staff members who manage the library system
 * 2. Members - Library patrons/users who can borrow books
 * 3. Books - The main resources available for borrowing
 * 4. Authors - Book writers with many-to-many relationship with books
 * 5. Categories - Book classifications/genres
 *
 * Key Features:
 * ------------
 * - Member Management: Track member details, membership dates, and contact information
 * - Book Inventory: Manage books with title, ISBN, publication year, and available copies
 * - Author Management: Handle multiple authors per book with a junction table
 * - Category System: Organize books by multiple categories
 * - Shopping Cart: Allow members to save books for later in a cart system
 * - Borrowing System: Track book loans with due dates and return status
 * - Audit Trail: Monitor record changes with created_at and updated_at timestamps
 *
 * Database Optimizations:
 * ---------------------
 * - Computed Columns: Full names for librarians, members, and authors
 * - Strategic Indexing: Optimized queries for common operations
 * - Referential Integrity: Proper foreign key constraints with CASCADE deletions
 * - Status Tracking: Enumerated status for borrowings (borrowed, returned, overdue)
 * - Unique Constraints: Prevent duplicate active borrowings
 */
-- Librarians table - Manages library staff information
CREATE TABLE librarians (
    librarian_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(256) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Members table - Stores library patron details
CREATE TABLE members (
    member_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    address TEXT,
    password VARCHAR(256) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_members_email ON members(email);

-- Books table - Contains book inventory information
CREATE TABLE books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    publication_year YEAR,
    isbn VARCHAR(20) UNIQUE,
    copies_available INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_books_title ON books(title);

-- Authors table - Stores book author information
CREATE TABLE authors (
    author_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX idx_authors_name ON authors(first_name, last_name);

-- Book Authors junction table - Links books with their authors
CREATE TABLE book_authors (
    book_id INT NOT NULL,
    author_id INT NOT NULL,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (author_id) REFERENCES authors(author_id) ON DELETE CASCADE
);
CREATE INDEX idx_book_authors_book_id ON book_authors(book_id);
CREATE INDEX idx_book_authors_author_id ON book_authors(author_id);

-- Categories table - Defines book genres/classifications
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL
);
CREATE INDEX idx_categories_name ON categories(category_name);

-- Book Categories junction table - Links books with categories
CREATE TABLE book_category (
    book_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (book_id, category_id),
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);
CREATE INDEX idx_book_category_book_id ON book_category(book_id);
CREATE INDEX idx_book_category_category_id ON book_category(category_id);

-- Book Cart table - Manages member's saved books
CREATE TABLE book_cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);
CREATE INDEX idx_book_cart_member_id ON book_cart(member_id);
CREATE INDEX idx_book_cart_book_id ON book_cart(book_id);

-- Borrowings table - Tracks book loans and returns
CREATE TABLE borrowings (
    borrowing_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    book_id INT NOT NULL,
    borrowed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    due_date DATE NOT NULL,
    returned_at TIMESTAMP NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(book_id) ON DELETE CASCADE
);
CREATE INDEX idx_borrowings_member_id ON borrowings(member_id);
CREATE INDEX idx_borrowings_book_id ON borrowings(book_id);
CREATE INDEX idx_borrowings_due_date ON borrowings(due_date);

-- Add full_name computed column to librarians
ALTER TABLE librarians 
ADD COLUMN full_name VARCHAR(201) GENERATED ALWAYS AS 
    (CONCAT(first_name, ' ', last_name)) STORED;

-- Add full_name computed column to members
ALTER TABLE members 
ADD COLUMN full_name VARCHAR(201) GENERATED ALWAYS AS 
    (CONCAT(first_name, ' ', last_name)) STORED;

-- Add full_name computed column to authors
ALTER TABLE authors 
ADD COLUMN full_name VARCHAR(201) GENERATED ALWAYS AS 
    (CONCAT(first_name, ' ', last_name)) STORED;

-- Add status enum to borrowings
ALTER TABLE borrowings 
ADD COLUMN status ENUM('borrowed', 'returned', 'overdue') 
    DEFAULT 'borrowed' NOT NULL;

-- Add librarian tracking to borrowings
ALTER TABLE borrowings 
ADD COLUMN librarian_id INT,
ADD FOREIGN KEY (librarian_id) REFERENCES librarians(librarian_id);

-- Add unique constraint to prevent duplicate borrowings
ALTER TABLE borrowings 
ADD CONSTRAINT unique_active_borrowing 
    UNIQUE(member_id, book_id, returned_at);

-- Add indexes for common queries
CREATE INDEX idx_librarians_full_name ON librarians(full_name);
CREATE INDEX idx_members_full_name ON members(full_name);
CREATE INDEX idx_authors_full_name ON authors(full_name);
CREATE INDEX idx_borrowings_status ON borrowings(status);
CREATE INDEX idx_books_isbn ON books(isbn);

-- Add audit timestamps
ALTER TABLE books ADD COLUMN updated_at TIMESTAMP 
    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE members ADD COLUMN updated_at TIMESTAMP 
    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;
ALTER TABLE borrowings ADD COLUMN updated_at TIMESTAMP 
    DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;



-- Initial Queries and Stored Procedures

-- Create audit log table
CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    action_type ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    record_id INT NOT NULL,
    changed_by INT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details JSON,
    FOREIGN KEY (changed_by) REFERENCES librarians(librarian_id)
);


-- PROCEDURES and Triggers

-- Trigger for Books Audit
DELIMITER //
CREATE TRIGGER books_after_insert
AFTER INSERT ON books
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, details)
    VALUES ('books', 'INSERT', NEW.book_id, 
        JSON_OBJECT(
            'title', NEW.title,
            'isbn', NEW.isbn,
            'copies', NEW.copies_available
        )
    );
END //

DELIMITER ;

-- ------------------------------------------------------------------------- SIGNUP MEMBER

/*
 * Stored Procedure: signup_member
 * Description: Creates a new library member record with basic information
 * Parameters:
 *   - p_first_name: Member's first name (VARCHAR(100))
 *   - p_last_name: Member's last name (VARCHAR(100)) 
 *   - p_email: Member's email address (VARCHAR(255))
 *   - p_phone_number: Member's contact number (VARCHAR(20))
 *   - p_address: Member's physical address (TEXT)
 * Returns: None
 * Notes: 
 *   - Does not perform email validation or duplicate checking
 */
DELIMITER //
CREATE PROCEDURE signup_member(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email VARCHAR(255),
    IN p_pass VARCHAR(200),
    IN p_phone_number VARCHAR(20),
    IN p_address TEXT
)
BEGIN
    INSERT INTO members (first_name, last_name, email, password, phone_number, address)
    VALUES (p_first_name, p_last_name, p_email, SHA2(p_pass, 256), p_phone_number, p_address);
END //
DELIMITER ;

-- -------------------------------------------------------------------------- ADD CATEGORIES

/*
 * Stored Procedure: add_categories
 * Description: Bulk inserts multiple categories into the categories table
 * Parameters:
 *   - category_list: JSON array of category names (e.g. ["Fiction", "Science"])
 * Returns: None
 * Example Usage: CALL add_categories('["Fiction", "Non-Fiction", "Science"]')
 * Notes:
 *   - Expects a valid JSON array format
 *   - Does not check for duplicate categories
 *   - Processes categories sequentially using a loop
 */
DELIMITER //

CREATE PROCEDURE add_categories(
    IN category_list JSON
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE n INT DEFAULT JSON_LENGTH(category_list);
    
    WHILE i < n DO
        INSERT INTO categories (category_name)
        VALUES (JSON_UNQUOTE(JSON_EXTRACT(category_list, CONCAT('$[', i, ']'))));
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- ---------------------------------------------------------------------- ADD AUTHORS

/*
 * Stored Procedure: add_authors
 * Description: Bulk inserts multiple authors into the authors table
 * Parameters:
 *   - author_list: JSON array of author objects containing first_name and last_name
 * Returns: None
 * Example Usage: 
 *   CALL add_authors('[{"first_name": "George", "last_name": "Orwell"}]')
 * Notes:
 *   - Expects a valid JSON array of objects
 *   - Each object must have first_name and last_name properties
 *   - Does not check for duplicate authors
 */
DELIMITER //
CREATE PROCEDURE add_authors(
    IN author_list JSON
)
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE n INT DEFAULT JSON_LENGTH(author_list);
    
    WHILE i < n DO
        INSERT INTO authors (first_name, last_name)
        VALUES (
            JSON_UNQUOTE(JSON_EXTRACT(author_list, CONCAT('$[', i, '].first_name'))),
            JSON_UNQUOTE(JSON_EXTRACT(author_list, CONCAT('$[', i, '].last_name')))
        );
        SET i = i + 1;
    END WHILE;
END //
DELIMITER ;

-- ------------------------------------------------------------------------- ADD BOOK

/*
 * Stored Procedure: add_book
 * Description: Adds a new book with its associated authors and categories
 * Parameters:
 *   - p_title: Book title (VARCHAR(255))
 *   - p_publication_year: Year of publication (INT)
 *   - p_isbn: International Standard Book Number (VARCHAR(13))
 *   - p_copies_available: Number of copies available (INT)
 *   - author_ids: JSON array of author IDs
 *   - category_ids: JSON array of category IDs
 * Returns: None
 * Example Usage:
 *   CALL add_book('1984', 1949, '978-0451524', 5, '[1]', '[1, 5]')
 * Notes:
 *   - Uses transaction to ensure data consistency
 *   - All author_ids and category_ids must exist in their respective tables
 *   - Handles multiple authors and categories for a single book
 */
DELIMITER //
CREATE PROCEDURE add_book(
    IN p_title VARCHAR(255),
    IN p_publication_year INT,
    IN p_isbn VARCHAR(13),
    IN p_copies_available INT,
    IN author_ids JSON,
    IN category_ids JSON
)
BEGIN
    DECLARE new_book_id INT;
    DECLARE i INT DEFAULT 0;
    DECLARE n_authors INT DEFAULT JSON_LENGTH(author_ids);
    DECLARE n_categories INT DEFAULT JSON_LENGTH(category_ids);
    
    -- Start transaction for atomicity
    START TRANSACTION;
    
    -- Insert book
    INSERT INTO books (title, publication_year, isbn, copies_available)
    VALUES (p_title, p_publication_year, p_isbn, p_copies_available);
    
    SET new_book_id = LAST_INSERT_ID();
    
    -- Add authors
    WHILE i < n_authors DO
        INSERT INTO book_authors (book_id, author_id)
        VALUES (
            new_book_id,
            JSON_EXTRACT(author_ids, CONCAT('$[', i, ']'))
        );
        SET i = i + 1;
    END WHILE;
    
    -- Reset counter for categories
    SET i = 0;
    
    -- Add categories
    WHILE i < n_categories DO
        INSERT INTO book_category (book_id, category_id)
        VALUES (
            new_book_id,
            JSON_EXTRACT(category_ids, CONCAT('$[', i, ']'))
        );
        SET i = i + 1;
    END WHILE;
    
    COMMIT;
END //
DELIMITER ;


-- ---------------------------------------------------------- LOGIN PROCEDURES

-- Login procedure for members
DELIMITER //
CREATE PROCEDURE member_login(
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE member_exists INT;
    
    -- Check if credentials match
    SELECT 
        member_id,
        first_name,
        last_name,
        email
    FROM members 
    WHERE email = p_email 
    AND password = SHA2(p_password, 256);
    
END //
DELIMITER ;

-- Login procedure for librarians 
DELIMITER //
CREATE PROCEDURE librarian_login(
    IN p_email VARCHAR(255),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE librarian_exists INT;
    
    -- Check if credentials match
    SELECT 
        librarian_id,
        first_name, 
        last_name,
        email
    FROM librarians
    WHERE email = p_email
    AND password = SHA2(p_password, 256);
    
END //
DELIMITER ;

-- ------------------------------------------------------------------------- VIEW PROFILE(MEMBER)

-- View Profile procedure for members
DELIMITER //
CREATE PROCEDURE view_member_profile(
    IN p_member_id INT
)
BEGIN
    SELECT 
        member_id,
        first_name,
        last_name,
        email,
        phone_number,
        address
    FROM members
    WHERE member_id = p_member_id;
END //
DELIMITER ;

-- ------------------------------------------------------------------------- VIEW PROFILE(LIB)

-- View Profile procedure for librarians
DELIMITER //
CREATE PROCEDURE view_librarian_profile(
    IN p_librarian_id INT
)
BEGIN
    SELECT 
        librarian_id,
        first_name,
        last_name,
        email
    FROM librarians
    WHERE librarian_id = p_librarian_id;
END //
DELIMITER ;

-- ------------------------------------------------------------------------- EDIT PROFILE(MEMBER)

-- Edit Profile procedure for members
DELIMITER //
CREATE PROCEDURE edit_member_profile(
    IN p_member_id INT,
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_phone_number VARCHAR(20),
    IN p_address TEXT
)
BEGIN
    UPDATE members
    SET 
        first_name = COALESCE(p_first_name, first_name),
        last_name = COALESCE(p_last_name, last_name),
        phone_number = COALESCE(p_phone_number, phone_number),
        address = COALESCE(p_address, address),
        updated_at = CURRENT_TIMESTAMP
    WHERE member_id = p_member_id;
    
    -- Return updated profile
    SELECT * FROM members WHERE member_id = p_member_id;
END //
DELIMITER ;

-- ------------------------------------------------------------------------- EDIT PROFILE(LIB)

-- Edit Profile procedure for librarians
DELIMITER //
CREATE PROCEDURE edit_librarian_profile(
    IN p_librarian_id INT,
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100)
)
BEGIN
    UPDATE librarians
    SET 
        first_name = COALESCE(p_first_name, first_name),
        last_name = COALESCE(p_last_name, last_name)
    WHERE librarian_id = p_librarian_id;
    
    -- Return updated profile
    SELECT * FROM librarians WHERE librarian_id = p_librarian_id;
END //
DELIMITER ;

-- ------------------------------------------------------------------------- CHANGE PASS(MEMBER)

-- Change Password procedure for members
DELIMITER //
CREATE PROCEDURE change_member_password(
    IN p_member_id INT,
    IN p_old_password VARCHAR(256),
    IN p_new_password VARCHAR(256)
)
BEGIN
    DECLARE password_matches INT;
    
    -- Check if old password matches
    SELECT COUNT(*) INTO password_matches
    FROM members
    WHERE member_id = p_member_id 
    AND password = SHA2(p_old_password, 256);
    
    IF password_matches = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Current password is incorrect';
    ELSE
        UPDATE members
        SET 
            password = SHA2(p_new_password, 256),
            updated_at = CURRENT_TIMESTAMP
        WHERE member_id = p_member_id;
        
        SELECT 'Password updated successfully' as message;
    END IF;
END //
DELIMITER ;

-- ------------------------------------------------------------------------- CHANGE PASS

-- Change Password procedure for librarians
DELIMITER //
CREATE PROCEDURE change_librarian_password(
    IN p_librarian_id INT,
    IN p_old_password VARCHAR(256),
    IN p_new_password VARCHAR(256)
)
BEGIN
    DECLARE password_matches INT;
    
    -- Check if old password matches
    SELECT COUNT(*) INTO password_matches
    FROM librarians
    WHERE librarian_id = p_librarian_id 
    AND password = SHA2(p_old_password, 256);
    
    IF password_matches = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Current password is incorrect';
    ELSE
        UPDATE librarians
        SET password = SHA2(p_new_password, 256)
        WHERE librarian_id = p_librarian_id;
        
        SELECT 'Password updated successfully' as message;
    END IF;
END //
DELIMITER ;


-- -------------------------------------------------------------------------------- PROCEDURES CALLS 


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
CALL change_member_password(1, 'John00', 'NewPass123');

-- Test change librarian password
CALL change_librarian_password(1, 'admin123', 'NewAdminPass123');

-- OPERATIONS
-- INITIAL OPERATIONS NEEDED

-- Initial Librarian
INSERT INTO librarians (first_name, last_name, email, password) VALUES
('Admin', 'Librarian', 'admin@library.com', SHA2('admin123', 256));

-- Example usage:
CALL signup_member('John', 'Doe', 'john.doe@email.com', 'John00', '+1234567890', '123 Main St');

CALL add_categories('["Fiction", "Non-Fiction", "Science", "Technology", "Literature"]');

CALL add_authors('[
    {"first_name": "George", "last_name": "Orwell"},
    {"first_name": "Jane", "last_name": "Austen"},
    {"first_name": "Stephen", "last_name": "Hawking"},
    {"first_name": "J.K.", "last_name": "Rowling"},
    {"first_name": "Ernest", "last_name": "Hemingway"}
]');

-- Add a book with multiple authors and categories
CALL add_book(
    '1984',
    1949,
    '978-0451524',
    5,
    '[1]',  -- Author IDs
    '[1, 5]'  -- Category IDs: Fiction and Literature
);
