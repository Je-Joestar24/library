
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


-- Trigger for Authors to automatically set full_name
CREATE TRIGGER authors_before_insert
BEFORE INSERT ON authors
FOR EACH ROW
BEGIN
    SET NEW.full_name = CONCAT(NEW.first_name, ' ', NEW.last_name);
END //