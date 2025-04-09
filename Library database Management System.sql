-- Create Database
CREATE DATABASE LibraryDB;

-- Use the newly created database
USE LibraryDB;

-- Create Members Table
CREATE TABLE Members (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE
);

-- Create Books Table
CREATE TABLE Books (
    book_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100),
    genre VARCHAR(50),
    total_copies INT,
    available_copies INT
);

-- Create Transactions Table
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    book_id INT,
    issue_date DATE,
    due_date DATE,
    return_date DATE,
    FOREIGN KEY (member_id) REFERENCES Members(member_id),
    FOREIGN KEY (book_id) REFERENCES Books(book_id)
);

-- Insert Sample Data into Members
INSERT INTO Members (name, email, join_date) VALUES 
('Alice Smith', 'alice@example.com', '2024-01-15'),
('Bob Johnson', 'bob@example.com', '2024-02-10');

-- Insert Sample Data into Books
INSERT INTO Books (title, author, genre, total_copies, available_copies) VALUES 
('The Great Gatsby', 'F. Scott Fitzgerald', 'Fiction', 5, 5),
('1984', 'George Orwell', 'Dystopian', 3, 3);

-- Create Stored Procedure to Return a Book
DELIMITER //
CREATE PROCEDURE ReturnBook(IN trans_id INT)
BEGIN
    UPDATE Transactions 
    SET return_date = CURDATE() 
    WHERE transaction_id = trans_id;

    UPDATE Books 
    SET available_copies = available_copies + 1
    WHERE book_id = (SELECT book_id FROM Transactions WHERE transaction_id = trans_id);
END //
DELIMITER ;

-- Create Trigger to Auto-Set Due Date if NULL
DELIMITER //
CREATE TRIGGER set_due_date_before_insert
BEFORE INSERT ON Transactions
FOR EACH ROW
BEGIN
    IF NEW.due_date IS NULL THEN
        SET NEW.due_date = DATE_ADD(NEW.issue_date, INTERVAL 14 DAY);
    END IF;
END;
//
DELIMITER ;
 
SHOW TABLES;
SELECT * FROM Members;
SELECT * FROM Books;
SELECT * FROM Transactions;
