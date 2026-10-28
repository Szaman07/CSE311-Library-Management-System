# 311 Library Management System

CSE311 (Database Systems, NSU), Group 5: a university library management system.

## Folders

| Folder | What it is |
|---|---|
| `database/` | The SQL schema and sample data (two databases: `lib_members`, `lib_catalog`) |
| `backend/` | Laravel API, serves JSON on http://localhost:8000/api/... |
| `frontend/` | React + TypeScript + Tailwind, the pages on http://localhost:5173 |
| `postman/` | A Postman collection with every endpoint, ready to send |
| `API.md` | The API contract: every endpoint, who may call it, what it sends and returns |

## What you need

- XAMPP (PHP 8.2 and MariaDB)
- Composer
- Node.js 22 or newer
- Git for Windows (it includes **Git Bash**)

**Run every command below in Git Bash.** In VS Code: Terminal → New Terminal, then pick "Git Bash" from the dropdown next to the `+`. Or right-click the project folder in File Explorer and choose "Open Git Bash here" (on Windows 11, under "Show more options").

## First time setup

1. **Get the code:**

   ```bash
   git clone https://github.com/Szaman07/CSE311-Library-Management-System.git
   cd CSE311-Library-Management-System
   ```

2. **Start MariaDB:** open the XAMPP Control Panel and press Start next to MySQL.

3. **Create the databases with the sample data:**

   ```bash
   bash database/reset.sh
   ```

4. **Install the backend:**

   ```bash
   cd backend
   composer install
   cp .env.example .env
   php artisan key:generate
   cd ..
   ```

   If Git Bash says `composer: command not found`, type `composer.bat install` instead.

5. **Install the frontend:**

   ```bash
   cd frontend
   npm install
   cd ..
   ```

## Every time you work

Start MySQL in XAMPP, then open **two** Git Bash windows in the project folder.

Window 1, the backend:

```bash
cd backend
php artisan serve
```

Window 2, the frontend:

```bash
cd frontend
npm run dev
```

Open http://localhost:5173 to see the catalogue. Stop either server with Ctrl+C.

## Resetting the data

Testing changes the data (books get returned, fines get paid). To get the original sample data back:

```bash
bash database/reset.sh
```

Every sample account uses the password `password`, e.g. `librarian@northsouth.edu` (librarian) and `rahim@northsouth.edu` (student).

## Trying the API

Use **Postman** (free, https://www.postman.com/downloads/). Click **Import** and choose `postman/Library-API.postman_collection.json`: every endpoint in `API.md` is there, ready to send. The API guide explains how to use it, including signing in.
