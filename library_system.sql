CREATE DATABASE LIBRARY_SYSTEM;
USE LIBRARY_SYSTEM;

-- Table: tbl_publisher
CREATE TABLE publisher (
    publisher_PublisherName VARCHAR(255) PRIMARY KEY,
    publisher_PublisherAddress TEXT,
    publisher_PublisherPhone VARCHAR(15)
);

-- Table: tbl_book
CREATE TABLE book (
    book_BookID INT PRIMARY KEY,
    book_Title VARCHAR(255),
    book_PublisherName VARCHAR(255),
    FOREIGN KEY (book_PublisherName) REFERENCES publisher(publisher_PublisherName)
);

-- Table: tbl_book_authors
CREATE TABLE book_authors (
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT,
    book_authors_BookID INT,
    book_authors_AuthorName VARCHAR(255),
    FOREIGN KEY (book_authors_BookID) REFERENCES book(book_BookID)
);

-- Table: tbl_library_branch
CREATE TABLE library_branch (
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT,
    library_branch_BranchName VARCHAR(255),
    library_branch_BranchAddress TEXT
);

-- Table: tbl_book_copies
CREATE TABLE book_copies (
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT,
    book_copies_BookID INT,
    book_copies_BranchID INT,
    book_copies_No_Of_Copies INT,
    FOREIGN KEY (book_copies_BookID) REFERENCES book(book_BookID),
    FOREIGN KEY (book_copies_BranchID) REFERENCES library_branch(library_branch_BranchID)
);

-- Table: tbl_borrower
CREATE TABLE borrower (
    borrower_CardNo INT PRIMARY KEY,
    borrower_BorrowerName VARCHAR(255),
    borrower_BorrowerAddress TEXT,
    borrower_BorrowerPhone VARCHAR(15)
);

-- Table: tbl_book_loans
CREATE TABLE book_loans (
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT,
    book_loans_BookID INT,
    book_loans_BranchID INT,
    book_loans_CardNo INT,
    book_loans_DateOut DATE,
    book_loans_DueDate DATE,
    FOREIGN KEY (book_loans_BookID) REFERENCES book(book_BookID),
    FOREIGN KEY (book_loans_BranchID) REFERENCES library_branch(library_branch_BranchID),
    FOREIGN KEY (book_loans_CardNo) REFERENCES borrower(borrower_CardNo)
);
select * from book;
select * from book_authors;             
select * from borrower;
select * from library_branch;
select * from book_copies;
select * from book_loans;
select * from publisher;
show tables;

-- 1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select lb.library_branch_BranchName,b.book_title,count(bc.book_copies_CopiesID) total_count from book b 
join
 library_branch lb
 join book_copies bc
where 
lb.library_branch_BranchName = "Sharpstown"
and b.book_title = "The Lost Tribe"
group by lb.library_branch_BranchName;


-- 2. How many copies of the book titled "The Lost Tribe" are owned by each library branch?

select LB.LIBRARY_BRANCH_BRANCHNAME,B.BOOK_TITLE,COUNT(BOOK_COPIES_NO_OF_COPIES) from Book_copies bc
JOIN book B
JOIN LIBRARY_BRANCH LB
WHERE BOOK_TITLE ="THE LOST TRIBE"
GROUP BY LB.LIBRARY_BRANCH_BRANCHNAME ;
select B.BOOK_TITLE,COUNT(BOOK_COPIES_NO_OF_COPIES) from Book_copies bc
JOIN book B
WHERE BOOK_TITLE ="THE LOST TRIBE"
GROUP BY B.BOOK_TITLE ;
select * from book_copies bc;

-- 3. Retrieve the names of all borrowers who do not have any books checked out.
SELECT br.borrower_BorrowerName
FROM borrower br
LEFT JOIN book_loans bl ON br.borrower_CardNo = bl.book_loans_CardNo
WHERE bl.book_loans_CardNo IS NULL;

-- 4. For each book loaned from "Sharpstown" with DueDate = '2018-02-03', retrieve title, borrower name,
-- and borrower address
SELECT b.book_Title,
       br.borrower_BorrowerName,
       br.borrower_BorrowerAddress
FROM book_loans bl
JOIN book b ON bl.book_loans_BookID = b.book_BookID
JOIN borrower br ON bl.book_loans_CardNo = br.borrower_CardNo
JOIN library_branch lb ON bl.book_loans_BranchID = lb.library_branch_BranchID
WHERE lb.library_branch_BranchName = 'Sharpstown'
  AND bl.book_loans_DueDate = '2000-05-18';
SELECT * FROM BOOK_LOANS
WHERE book_loans_DueDate = '2000-05-18';
SELECT * FROM BOOK_LOANS;

-- 5. For each library branch, retrieve branch name and total number of 
-- books loaned out from that branch
SELECT lb.library_branch_BranchName,
       COUNT(bl.book_loans_LoansID) AS total_books_loaned
FROM library_branch lb
LEFT JOIN book_loans bl ON lb.library_branch_BranchID = bl.book_loans_BranchID
GROUP BY lb.library_branch_BranchName;

-- 6. Retrieve names, addresses, and number of books checked out for all borrowers who have more 
-- than 5 books checked out.
SELECT br.borrower_BorrowerName,
       br.borrower_BorrowerAddress,
       COUNT(bl.book_loans_LoansID) AS books_checked_out
FROM borrower br
JOIN book_loans bl ON br.borrower_CardNo = bl.book_loans_CardNo
GROUP BY br.borrower_BorrowerName, br.borrower_BorrowerAddress
HAVING COUNT(bl.book_loans_LoansID) > 5;

-- 7. For each book authored by "Stephen King", retrieve title and number of copies
--  owned by the "Central" branch.
SELECT b.book_Title,bc.book_copies_No_Of_Copies,ba.book_authors_AuthorName,
lb.library_branch_BranchName
FROM BOOK_AUTHORS ba
join book b
join book_copies bc
join library_branch lb
WHERE book_authors_AuthorName = 'Stephen King'
and library_branch_BranchName = 'Central'
group by b.book_title, bc.book_copies_No_Of_Copies;


