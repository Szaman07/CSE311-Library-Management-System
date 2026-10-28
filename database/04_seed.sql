-- Placeholder seed data. Run after 01, 02 and 03, on empty databases.
--
-- Books are real, but ISBNs are placeholders (978000000xxxx) until the Open Library
-- lookup fills in real ones. Bangla titles are in Banglish for now.
-- Every account's password is: password
-- Loan dates are relative to today, so the fine cases stay correct whenever this is loaded.

-- ---------------------------------------------------------------- lib_members

USE lib_members;

INSERT INTO account (account_id, name, email, password_hash, role, status, student_no, phone) VALUES
  (1,  'Nusrat Jahan',     'librarian@northsouth.edu', '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'librarian', 'active',  NULL,         '01710000001'),
  (2,  'Rahim Ahmed',      'rahim@northsouth.edu',     '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'active',  '2211000042', '01710000002'),
  (3,  'Fatima Khan',      'fatima@northsouth.edu',    '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'active',  '2211000043', '01710000003'),
  (4,  'Tanvir Hasan',     'tanvir@northsouth.edu',    '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'active',  '2211000044', '01710000004'),
  (5,  'Sadia Islam',      'sadia@northsouth.edu',     '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'active',  '2211000045', '01710000005'),
  (6,  'Arif Chowdhury',   'arif@northsouth.edu',      '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'active',  '2211000046', '01710000006'),
  (7,  'Nadia Rahman',     'nadia@northsouth.edu',     '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'active',  '2211000047', '01710000007'),
  (8,  'Imran Hossain',    'imran@northsouth.edu',     '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'active',  '2211000048', '01710000008'),
  (9,  'Maliha Akter',     'maliha@northsouth.edu',    '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'active',  '2211000049', '01710000009'),
  -- Registered but not yet approved: shows the librarian's approval queue.
  (10, 'Shafin Karim',     'shafin@northsouth.edu',    '$2y$10$r4aLBiMxLNaWDi12T1nZiePZz7Zkyv0HN7EcwqAoDHUkQEYCAeN5i', 'student',   'pending', '2211000050', '01710000010');

INSERT INTO library_card (card_no, account_id, issued_on, expires_on) VALUES
  ('LIB-0002', 2, CURDATE() - INTERVAL 200 DAY, CURDATE() + INTERVAL 165 DAY),
  ('LIB-0003', 3, CURDATE() - INTERVAL 200 DAY, CURDATE() + INTERVAL 165 DAY),
  ('LIB-0004', 4, CURDATE() - INTERVAL 180 DAY, CURDATE() + INTERVAL 185 DAY),
  ('LIB-0005', 5, CURDATE() - INTERVAL 180 DAY, CURDATE() + INTERVAL 185 DAY),
  ('LIB-0006', 6, CURDATE() - INTERVAL 150 DAY, CURDATE() + INTERVAL 215 DAY),
  ('LIB-0007', 7, CURDATE() - INTERVAL 150 DAY, CURDATE() + INTERVAL 215 DAY),
  ('LIB-0008', 8, CURDATE() - INTERVAL 120 DAY, CURDATE() + INTERVAL 245 DAY),
  ('LIB-0009', 9, CURDATE() - INTERVAL 120 DAY, CURDATE() + INTERVAL 245 DAY);

-- ---------------------------------------------------------------- lib_catalog

USE lib_catalog;

INSERT INTO genre (genre_id, name) VALUES
  (1, 'Fiction'), (2, 'Classics'), (3, 'Science'), (4, 'Computer Science'),
  (5, 'History'), (6, 'Philosophy'), (7, 'Bangla Literature'), (8, 'Fantasy');

INSERT INTO author (author_id, name) VALUES
  (1, 'Jane Austen'), (2, 'George Orwell'), (3, 'Harper Lee'), (4, 'F. Scott Fitzgerald'),
  (5, 'Fyodor Dostoevsky'), (6, 'Yann Martel'), (7, 'J. R. R. Tolkien'), (8, 'J. K. Rowling'),
  (9, 'George R. R. Martin'), (10, 'Stephen Hawking'), (11, 'Richard Dawkins'), (12, 'Carl Sagan'),
  (13, 'Yuval Noah Harari'), (14, 'Jared Diamond'), (15, 'Plato'), (16, 'Marcus Aurelius'),
  (17, 'Jostein Gaarder'), (18, 'Abraham Silberschatz'), (19, 'Henry F. Korth'), (20, 'S. Sudarshan'),
  (21, 'Thomas H. Cormen'), (22, 'Charles E. Leiserson'), (23, 'Ronald L. Rivest'), (24, 'Clifford Stein'),
  (25, 'Robert C. Martin'), (26, 'Andrew Hunt'), (27, 'David Thomas'), (28, 'Ramez Elmasri'),
  (29, 'Shamkant B. Navathe'), (30, 'Rabindranath Tagore'), (31, 'Kazi Nazrul Islam'),
  (32, 'Bibhutibhushan Bandyopadhyay'), (33, 'Sarat Chandra Chattopadhyay'), (34, 'Syed Waliullah');

INSERT INTO book (book_id, isbn, title, title_banglish, publisher, published_year, genre_id, description) VALUES
  (1,  '9780000000001', 'Pride and Prejudice', NULL, NULL, 1813, 2,
       'Elizabeth Bennet and the proud Mr Darcy misjudge each other in a story of manners, money and marriage in Regency England.'),
  (2,  '9780000000002', 'Nineteen Eighty-Four', NULL, NULL, 1949, 1,
       'In a state that watches everyone, a minor official secretly rebels against the Party and its control of truth.'),
  (3,  '9780000000003', 'Animal Farm', NULL, NULL, 1945, 2,
       'Farm animals overthrow their owner, only to see their revolution betrayed by the pigs who lead it.'),
  (4,  '9780000000004', 'To Kill a Mockingbird', NULL, NULL, 1960, 2,
       'A girl in a small Alabama town watches her father defend a Black man falsely accused of a crime.'),
  (5,  '9780000000005', 'The Great Gatsby', NULL, NULL, 1925, 2,
       'A mysterious millionaire throws lavish parties on Long Island in pursuit of a lost love.'),
  (6,  '9780000000006', 'Crime and Punishment', NULL, NULL, 1866, 2,
       'A poor former student in St Petersburg commits a murder and is consumed by guilt and fear.'),
  (7,  '9780000000007', 'Life of Pi', NULL, NULL, 2001, 1,
       'After a shipwreck, a boy is adrift in a lifeboat in the Pacific with a Bengal tiger.'),
  (8,  '9780000000008', 'The Hobbit', NULL, NULL, 1937, 8,
       'A home-loving hobbit is swept into a quest with dwarves to reclaim their treasure from a dragon.'),
  (9,  '9780000000009', 'Harry Potter and the Philosopher''s Stone', NULL, NULL, 1997, 8,
       'An orphaned boy learns he is a wizard and begins his first year at a school of magic.'),
  (10, '9780000000010', 'A Game of Thrones', NULL, NULL, 1996, 8,
       'Noble families scheme and fight for the throne of a kingdom while an ancient threat gathers in the north.'),
  (11, '9780000000011', 'A Brief History of Time', NULL, NULL, 1988, 3,
       'A physicist explains the origin of the universe, black holes and the nature of time for general readers.'),
  (12, '9780000000012', 'The Selfish Gene', NULL, NULL, 1976, 3,
       'Evolution seen from the point of view of the gene, and why that explains altruism in animals.'),
  (13, '9780000000013', 'Cosmos', NULL, NULL, 1980, 3,
       'A tour of the universe and the history of science, from ancient astronomers to space probes.'),
  (14, '9780000000014', 'Sapiens: A Brief History of Humankind', NULL, NULL, 2011, 5,
       'How Homo sapiens came to dominate the planet, from the cognitive revolution to modern capitalism.'),
  (15, '9780000000015', 'Guns, Germs, and Steel', NULL, NULL, 1997, 5,
       'Why some societies conquered others: geography, crops, animals and disease in human history.'),
  (16, '9780000000016', 'The Republic', NULL, NULL, NULL, 6,
       'A dialogue led by Socrates on justice and the ideal city, ruled by philosopher-kings.'),
  (17, '9780000000017', 'Meditations', NULL, NULL, NULL, 6,
       'Private notes of a Roman emperor on duty, self-control and accepting what cannot be changed.'),
  (18, '9780000000018', 'Sophie''s World', NULL, NULL, 1991, 6,
       'A teenage girl receives mysterious letters that teach her the history of philosophy.'),
  (19, '9780000000019', 'Database System Concepts', NULL, 'McGraw-Hill', 2019, 4,
       'A standard textbook on relational databases: the relational model, SQL, design, indexing and transactions.'),
  (20, '9780000000020', 'Introduction to Algorithms', NULL, 'MIT Press', 2009, 4,
       'A comprehensive textbook on algorithms and data structures, with sorting, graphs and dynamic programming.'),
  (21, '9780000000021', 'Clean Code', NULL, 'Prentice Hall', 2008, 4,
       'Practical advice on writing readable, maintainable code: naming, functions, tests and refactoring.'),
  (22, '9780000000022', 'The Pragmatic Programmer', NULL, 'Addison-Wesley', 1999, 4,
       'Tips and habits for working programmers, from avoiding duplication to automating everyday tasks.'),
  (23, '9780000000023', 'Fundamentals of Database Systems', NULL, 'Pearson', NULL, 4,
       'A database textbook covering ER modelling, normalisation, SQL and query processing.'),
  (24, '9780000000024', 'Gitanjali', 'Gitanjali', NULL, 1910, 7,
       'Song offerings: devotional poems of longing and praise that won the Nobel Prize in Literature.'),
  (25, '9780000000025', 'Golpoguccho', 'Golpoguccho', NULL, NULL, 7,
       'A collection of short stories of village and family life in rural Bengal.'),
  (26, '9780000000026', 'Shesher Kobita', 'Shesher Kobita', NULL, 1929, 7,
       'A romance between a witty, modern young man and a thoughtful woman he meets in the hills of Shillong.'),
  (27, '9780000000027', 'Agnibina', 'Agnibina', NULL, 1922, 7,
       'Fiery poems of rebellion and freedom, including the famous poem of the rebel.'),
  (28, '9780000000028', 'Pather Panchali', 'Pather Panchali', NULL, 1929, 7,
       'A poor family''s life in a Bengal village, seen through the childhood of a boy named Apu and his sister Durga.'),
  (29, '9780000000029', 'Devdas', 'Devdas', NULL, 1917, 7,
       'A wealthy young man, kept from marrying his childhood love, falls into despair and drink.'),
  (30, '9780000000030', 'Lalsalu', 'Lalsalu', NULL, 1948, 7,
       'A man arrives in a village and builds his power around a false shrine draped in red cloth.');

INSERT INTO book_author (book_id, author_id) VALUES
  (1, 1), (2, 2), (3, 2), (4, 3), (5, 4), (6, 5), (7, 6), (8, 7), (9, 8), (10, 9),
  (11, 10), (12, 11), (13, 12), (14, 13), (15, 14), (16, 15), (17, 16), (18, 17),
  (19, 18), (19, 19), (19, 20),                -- three authors
  (20, 21), (20, 22), (20, 23), (20, 24),      -- four authors
  (21, 25), (22, 26), (22, 27), (23, 28), (23, 29),
  (24, 30), (25, 30), (26, 30), (27, 31), (28, 32), (29, 33), (30, 34);

-- All copies start available; open loans are marked on_loan at the end.
INSERT INTO book_copy (copy_id, book_id, barcode, shelf_mark) VALUES
  (1, 1, 'C0001', 'CL-01'), (2, 1, 'C0002', 'CL-01'),
  (3, 2, 'C0003', 'FI-01'), (4, 2, 'C0004', 'FI-01'), (5, 2, 'C0005', 'FI-01'),
  (6, 3, 'C0006', 'CL-02'),
  (7, 4, 'C0007', 'CL-03'), (8, 4, 'C0008', 'CL-03'),
  (9, 5, 'C0009', 'CL-04'),
  (10, 6, 'C0010', 'CL-05'), (11, 6, 'C0011', 'CL-05'),
  (12, 7, 'C0012', 'FI-02'), (13, 7, 'C0013', 'FI-02'),
  (14, 8, 'C0014', 'FA-01'), (15, 8, 'C0015', 'FA-01'),
  (16, 9, 'C0016', 'FA-02'), (17, 9, 'C0017', 'FA-02'), (18, 9, 'C0018', 'FA-02'),
  (19, 10, 'C0019', 'FA-03'),
  (20, 11, 'C0020', 'SC-01'), (21, 11, 'C0021', 'SC-01'),
  (22, 12, 'C0022', 'SC-02'),
  (23, 13, 'C0023', 'SC-03'),
  (24, 14, 'C0024', 'HI-01'), (25, 14, 'C0025', 'HI-01'),
  (26, 15, 'C0026', 'HI-02'),
  (27, 16, 'C0027', 'PH-01'),
  (28, 17, 'C0028', 'PH-02'),
  (29, 18, 'C0029', 'PH-03'),
  (30, 19, 'C0030', 'CS-01'), (31, 19, 'C0031', 'CS-01'), (32, 19, 'C0032', 'CS-01'),
  (33, 20, 'C0033', 'CS-02'), (34, 20, 'C0034', 'CS-02'),
  (35, 21, 'C0035', 'CS-03'),
  (36, 22, 'C0036', 'CS-04'),
  (37, 23, 'C0037', 'CS-05'), (38, 23, 'C0038', 'CS-05'),
  (39, 24, 'C0039', 'BL-01'), (40, 24, 'C0040', 'BL-01'),
  (41, 25, 'C0041', 'BL-02'), (42, 25, 'C0042', 'BL-02'),
  (43, 26, 'C0043', 'BL-03'),
  (44, 27, 'C0044', 'BL-04'),
  (45, 28, 'C0045', 'BL-05'), (46, 28, 'C0046', 'BL-05'),
  (47, 29, 'C0047', 'BL-06'),
  (48, 30, 'C0048', 'BL-07'), (49, 30, 'C0049', 'BL-07');

-- One damaged copy, kept on record but out of circulation.
UPDATE book_copy SET status = 'withdrawn' WHERE copy_id = 49;

-- Loans. Each group shows one situation the system has to handle.
INSERT INTO loan (loan_id, copy_id, account_id, issued_at, due_date, returned_at, renewal_status, renewal_count) VALUES
  -- Normal loan, due in a week.
  (1,  3,  2, CURDATE() - INTERVAL 7 DAY,  CURDATE() + INTERVAL 7 DAY,  NULL, 'none', 0),
  -- Overdue 5 days: 100 Tk.
  (2,  12, 3, CURDATE() - INTERVAL 19 DAY, CURDATE() - INTERVAL 5 DAY,  NULL, 'none', 0),
  -- Overdue 20 days: 200 Tk.
  (3,  20, 4, CURDATE() - INTERVAL 34 DAY, CURDATE() - INTERVAL 20 DAY, NULL, 'none', 0),
  -- Overdue 40 days and unpaid: 300 Tk, and Sadia can't borrow.
  (4,  14, 5, CURDATE() - INTERVAL 54 DAY, CURDATE() - INTERVAL 40 DAY, NULL, 'none', 0),
  -- Returned 38 days late and paid (fine row below): no block.
  (5,  24, 6, CURDATE() - INTERVAL 54 DAY, CURDATE() - INTERVAL 40 DAY, CURDATE() - INTERVAL 2 DAY, 'none', 0),
  -- Returned 8 days late, not paid yet: fine frozen at 100 Tk.
  (6,  27, 7, CURDATE() - INTERVAL 30 DAY, CURDATE() - INTERVAL 16 DAY, CURDATE() - INTERVAL 8 DAY, 'none', 0),
  -- Renewal waiting for the librarian.
  (7,  30, 8, CURDATE() - INTERVAL 12 DAY, CURDATE() + INTERVAL 2 DAY,  NULL, 'requested', 0),
  -- Renewal already approved: due date moved 14 days later.
  (8,  48, 9, CURDATE() - INTERVAL 20 DAY, CURDATE() + INTERVAL 8 DAY,  NULL, 'approved', 1),
  -- All three copies of Harry Potter are out (holds below).
  (9,  16, 2, CURDATE() - INTERVAL 4 DAY,  CURDATE() + INTERVAL 10 DAY, NULL, 'none', 0),
  (10, 17, 3, CURDATE() - INTERVAL 9 DAY,  CURDATE() + INTERVAL 5 DAY,  NULL, 'none', 0),
  (11, 18, 9, CURDATE() - INTERVAL 11 DAY, CURDATE() + INTERVAL 3 DAY,  NULL, 'none', 0),
  -- Borrowing history: returned on time.
  (12, 39, 2, CURDATE() - INTERVAL 90 DAY, CURDATE() - INTERVAL 76 DAY, CURDATE() - INTERVAL 80 DAY, 'none', 0),
  (13, 45, 2, CURDATE() - INTERVAL 70 DAY, CURDATE() - INTERVAL 56 DAY, CURDATE() - INTERVAL 60 DAY, 'none', 0),
  (14, 4,  3, CURDATE() - INTERVAL 85 DAY, CURDATE() - INTERVAL 71 DAY, CURDATE() - INTERVAL 75 DAY, 'none', 0),
  (15, 6,  3, CURDATE() - INTERVAL 65 DAY, CURDATE() - INTERVAL 51 DAY, CURDATE() - INTERVAL 52 DAY, 'none', 0),
  (16, 33, 9, CURDATE() - INTERVAL 100 DAY, CURDATE() - INTERVAL 86 DAY, CURDATE() - INTERVAL 88 DAY, 'none', 0),
  (17, 35, 9, CURDATE() - INTERVAL 60 DAY, CURDATE() - INTERVAL 46 DAY, CURDATE() - INTERVAL 50 DAY, 'none', 0),
  (18, 41, 8, CURDATE() - INTERVAL 50 DAY, CURDATE() - INTERVAL 36 DAY, CURDATE() - INTERVAL 40 DAY, 'none', 0);

-- Copies on an open loan are not on the shelf.
UPDATE book_copy SET status = 'on_loan'
WHERE copy_id IN (SELECT copy_id FROM loan WHERE returned_at IS NULL);

-- Two students waiting for Harry Potter.
INSERT INTO hold (book_id, account_id, placed_at, status) VALUES
  (9, 4, CURDATE() - INTERVAL 3 DAY, 'waiting'),
  (9, 7, CURDATE() - INTERVAL 1 DAY, 'waiting');

-- ---------------------------------------------------------------- paid fines

-- Arif paid 300 Tk for loan 5; the librarian took the payment.
INSERT INTO lib_members.fine (loan_id, amount, paid_at, received_by) VALUES
  (5, 300, CURDATE() - INTERVAL 2 DAY, 1);
