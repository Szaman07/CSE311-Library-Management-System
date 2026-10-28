-- lib_catalog: the books, their physical copies, and lending.
-- Needs 01_lib_members.sql first: loans and holds point at lib_members.account.

CREATE DATABASE IF NOT EXISTS lib_catalog
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE lib_catalog;

CREATE TABLE genre (
  genre_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name      VARCHAR(60) NOT NULL UNIQUE
);

CREATE TABLE author (
  author_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(150) NOT NULL
);

-- One row per title (ISBN). Physical copies are in book_copy.
CREATE TABLE book (
  book_id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  isbn            VARCHAR(13) NOT NULL UNIQUE,
  title           VARCHAR(255) NOT NULL,
  title_banglish  VARCHAR(255) NULL,   -- Banglish spelling of a Bangla title, for search
  publisher       VARCHAR(150) NULL,
  published_year  SMALLINT NULL,
  description     TEXT NULL,
  genre_id        INT UNSIGNED NULL,

  FOREIGN KEY (genre_id) REFERENCES genre (genre_id) ON DELETE SET NULL
);

-- Many-to-many: a book can have several authors, an author several books.
CREATE TABLE book_author (
  book_id    INT UNSIGNED NOT NULL,
  author_id  INT UNSIGNED NOT NULL,
  PRIMARY KEY (book_id, author_id),
  FOREIGN KEY (book_id)   REFERENCES book (book_id)     ON DELETE CASCADE,
  FOREIGN KEY (author_id) REFERENCES author (author_id) ON DELETE RESTRICT
);

-- One row per physical copy on the shelf.
CREATE TABLE book_copy (
  copy_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  book_id     INT UNSIGNED NOT NULL,
  barcode     VARCHAR(30) NOT NULL UNIQUE,
  shelf_mark  VARCHAR(30) NULL,
  -- Issuing sets on_loan, returning sets available. Withdrawn copies are kept for loan history.
  status      ENUM('available', 'on_loan', 'withdrawn') NOT NULL DEFAULT 'available',

  FOREIGN KEY (book_id) REFERENCES book (book_id) ON DELETE RESTRICT
);

-- One row per borrowing. returned_at stays NULL while the book is out.
CREATE TABLE loan (
  loan_id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  copy_id         INT UNSIGNED NOT NULL,
  account_id      INT UNSIGNED NOT NULL,
  issued_at       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  due_date        DATE NOT NULL,
  returned_at     DATETIME NULL,
  renewal_status  ENUM('none', 'requested', 'approved', 'declined') NOT NULL DEFAULT 'none',
  renewal_count   TINYINT UNSIGNED NOT NULL DEFAULT 0,

  -- Holds the copy_id only while the loan is open, NULL once returned.
  -- UNIQUE ignores NULLs, so a copy can never be lent twice at the same time.
  open_copy_id INT UNSIGNED AS (IF(returned_at IS NULL, copy_id, NULL)) STORED,
  UNIQUE (open_copy_id),

  CHECK (renewal_count <= 1),
  -- RESTRICT keeps loan history: a copy or member with past loans can't be deleted.
  FOREIGN KEY (copy_id)    REFERENCES book_copy (copy_id)          ON DELETE RESTRICT,
  FOREIGN KEY (account_id) REFERENCES lib_members.account (account_id) ON DELETE RESTRICT
);

-- Waiting list for a book whose copies are all out.
CREATE TABLE hold (
  hold_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  book_id     INT UNSIGNED NOT NULL,
  account_id  INT UNSIGNED NOT NULL,
  placed_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  -- ready = a returned copy is set aside for this member.
  status      ENUM('waiting', 'ready', 'fulfilled', 'cancelled') NOT NULL DEFAULT 'waiting',

  FOREIGN KEY (book_id)    REFERENCES book (book_id)               ON DELETE CASCADE,
  FOREIGN KEY (account_id) REFERENCES lib_members.account (account_id) ON DELETE RESTRICT
);
