-- Fines: the paid record in lib_members, and the view that works out what is owed.
-- Needs 01 and 02 first: fine points at lib_catalog.loan.
--
-- Fine rules: 1-10 days overdue = 100 Tk, 11-30 days = 200 Tk, 31+ days = 300 Tk (cap).
-- A loan 31+ days overdue and unpaid blocks the member from borrowing.
-- Nothing is stored while a fine is unpaid; loan_fine_status calculates it from today's date.

USE lib_members;

-- One row per paid fine. Paying = inserting this row.
CREATE TABLE fine (
  fine_id      INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  loan_id      INT UNSIGNED NOT NULL UNIQUE,   -- a loan is fined at most once
  amount       SMALLINT UNSIGNED NOT NULL,
  paid_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  received_by  INT UNSIGNED NOT NULL,          -- the librarian who took the payment

  CHECK (amount IN (100, 200, 300)),
  FOREIGN KEY (loan_id)     REFERENCES lib_catalog.loan (loan_id) ON DELETE RESTRICT,
  FOREIGN KEY (received_by) REFERENCES account (account_id)       ON DELETE RESTRICT
);

USE lib_catalog;

-- Every overdue loan (still out, or returned late) with its fine.
-- Days are counted to the return date if returned, otherwise to today.
CREATE VIEW loan_fine_status AS
SELECT
  o.loan_id,
  o.account_id,
  o.due_date,
  o.returned_at,
  o.days_overdue,
  CASE
    WHEN o.days_overdue <= 10 THEN 100
    WHEN o.days_overdue <= 30 THEN 200
    ELSE 300
  END                                              AS fine_amount,
  f.fine_id IS NOT NULL                            AS is_paid,
  (o.days_overdue >= 31 AND f.fine_id IS NULL)     AS blocks_borrowing
FROM (
  SELECT l.*,
         DATEDIFF(COALESCE(DATE(l.returned_at), CURDATE()), l.due_date) AS days_overdue
  FROM loan AS l
) AS o
LEFT JOIN lib_members.fine AS f ON f.loan_id = o.loan_id
WHERE o.days_overdue > 0;
