
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
