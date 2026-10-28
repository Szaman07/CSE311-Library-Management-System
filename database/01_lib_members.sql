-- lib_members: the people who use the library and their cards.
-- Run the files in this folder in order: 01, 02, 03.

CREATE DATABASE IF NOT EXISTS lib_members
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE lib_members;

-- One row per person who can sign in: students and librarians.
-- Named "account" because USER is a MariaDB keyword.
CREATE TABLE account (
  account_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name           VARCHAR(100) NOT NULL,
  email          VARCHAR(150) NOT NULL UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,
  role           ENUM('student', 'librarian') NOT NULL DEFAULT 'student',
  -- New students stay pending until a librarian approves them.
  status         ENUM('pending', 'active', 'suspended', 'deactivated') NOT NULL DEFAULT 'pending',
  student_no     VARCHAR(20) NULL UNIQUE,   -- NSU ID; empty for librarians
  phone          VARCHAR(20) NULL,
  created_at     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  last_login_at  DATETIME NULL
);

-- Every card a member has ever held stays here; only one can be active.
CREATE TABLE library_card (
  card_id     INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  card_no     VARCHAR(20) NOT NULL UNIQUE,
  account_id  INT UNSIGNED NOT NULL,
  issued_on   DATE NOT NULL,
  expires_on  DATE NOT NULL,
  -- Blocking for unpaid fines is not stored here; it comes from the loan_fine_status view.
  status      ENUM('active', 'lost', 'replaced') NOT NULL DEFAULT 'active',

  -- Holds the account_id only while the card is active, NULL otherwise.
  -- UNIQUE ignores NULLs, so this allows one active card per member.
  active_account_id INT UNSIGNED AS (IF(status = 'active', account_id, NULL)) STORED,
  UNIQUE (active_account_id),

  CHECK (expires_on > issued_on),
  FOREIGN KEY (account_id) REFERENCES account (account_id) ON DELETE RESTRICT
);

-- Sign-in tokens. Laravel Sanctum creates a row here at every login and deletes it at
-- logout; the frontend sends the token with each request. Laravel fills every column.
CREATE TABLE personal_access_tokens (
  id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  tokenable_type  VARCHAR(255) NOT NULL,      -- always App\Models\Account here
  tokenable_id    BIGINT UNSIGNED NOT NULL,   -- the account_id
  name            TEXT NOT NULL,
  token           VARCHAR(64) NOT NULL UNIQUE,  -- a hash of the token, never the token itself
  abilities       TEXT NULL,
  last_used_at    TIMESTAMP NULL,
  expires_at      TIMESTAMP NULL,
  created_at      TIMESTAMP NULL,
  updated_at      TIMESTAMP NULL,
  INDEX (tokenable_type, tokenable_id),
  INDEX (expires_at)
);
