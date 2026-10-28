# 311 Library Management System

CSE311 (Database Systems, NSU), Group 5: a university library management system.

## Folders

| Folder | What it is |
|---|---|
| `database/` | The SQL schema and seed data (two databases: `lib_members`, `lib_catalog`) |
| `backend/` | Laravel API, serves JSON on http://localhost:8000/api/... |
| `frontend/` | React + TypeScript + Tailwind, the pages on http://localhost:5173 |

## What you need

- XAMPP (PHP 8.2 and MariaDB)
- Composer
- Node.js 20 or newer

## How to run

1. **Start MariaDB** from the XAMPP Control Panel (MySQL → Start).

2. **Load the database** (from the repo folder, in order):

   ```
   C:\xampp\mysql\bin\mysql -u root < database/01_lib_members.sql
   C:\xampp\mysql\bin\mysql -u root < database/02_lib_catalog.sql
   C:\xampp\mysql\bin\mysql -u root < database/03_fine_and_view.sql
   C:\xampp\mysql\bin\mysql -u root --default-character-set=utf8mb4 < database/04_seed.sql
   ```

   To start over, drop both databases first:

   ```
   C:\xampp\mysql\bin\mysql -u root -e "SET FOREIGN_KEY_CHECKS=0; DROP DATABASE lib_catalog; DROP DATABASE lib_members;"
   ```

3. **Backend** (first time only: install and create `.env`):

   ```
   cd backend
   composer install
   copy .env.example .env
   php artisan key:generate
   php artisan serve
   ```

4. **Frontend**, in a second terminal:

   ```
   cd frontend
   npm install
   npm run dev
   ```

5. Open http://localhost:5173. You should see the book catalogue.

Seed accounts all use the password `password`, e.g. `librarian@northsouth.edu` and `rahim@northsouth.edu`.
