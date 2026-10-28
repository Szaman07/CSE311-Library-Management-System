# API contract

Every URL the frontend calls, who may call it, what it sends and what it returns.
Backend and frontend are built against this list, so a change here is agreed first and then made on both sides.

## Conventions

- URLs name things, in the plural: `/api/books`, `/api/loans`.
- The ID of one thing goes in the path: `/api/loans/12`.
- Filters go in the query string: `/api/loans?status=overdue`.
- **Who is asking comes from the sign-in, never from the URL.** The same `GET /api/loans` returns every loan to a librarian and only their own loans to a student.
- History is changed, never deleted: returning a book or cancelling a hold is a `PATCH`, not a `DELETE`.
- Requests and responses are JSON. Yes/no values come back as `1` and `0`, because that is how MariaDB returns them.
- Every request sends the header `Accept: application/json`, so errors also come back as JSON.

### Who may call it

| Mark | Meaning |
|---|---|
| anyone | No sign-in needed |
| student | A signed-in student |
| librarian | A signed-in librarian |
| both | Any signed-in user |

### Errors

Every error has the same shape:

```json
{ "message": "Borrowing is blocked: loan 4 is 40 days overdue and unpaid." }
```

| Status | When |
|---|---|
| 401 | Not signed in |
| 403 | Signed in, but the wrong role |
| 404 | The thing does not exist |
| 409 | Refused by a library rule (limit reached, borrowing blocked, copy already out) |
| 422 | Missing or invalid input; the response also lists the bad fields |

A 422 looks like this:

```json
{ "message": "The loan id field is required.",
  "errors": { "loan_id": ["The loan id field is required."] } }
```

While developing (`APP_DEBUG=true` in `.env`), errors also carry `exception`, `file` and `trace` fields. Only `message` is part of the contract.

## 1. Sign-in

Sign-in uses a **token** (Laravel Sanctum). Login answers a token; every later request sends it in the header `Authorization: Bearer <token>`. Logout deletes it. The frontend keeps the token in `localStorage` (see `frontend/src/api.ts`); Postman keeps it in the `{{token}}` variable.

| Endpoint | Who | Does |
|---|---|---|
| `POST /api/auth/register` | anyone | Creates a student account with status `pending` |
| `POST /api/auth/login` | anyone | Signs in; refused unless the account is `active` |
| `POST /api/auth/logout` | both | Signs out |
| `GET /api/me` | both | Own account, active card, and whether borrowing is blocked |
| `PATCH /api/me` | both | Change phone or password |

`POST /api/auth/register`
```json
{ "name": "Rahim Ahmed", "email": "rahim@northsouth.edu", "password": "…",
  "student_no": "2211000042", "phone": "01710000002" }
```
Returns `201` with the new account (`"status": "pending"`).

`POST /api/auth/login`
```json
{ "email": "rahim@northsouth.edu", "password": "…" }
```
Returns `200` with `{ "token": "1|abc…", "account": { … } }`, or `401` for a wrong password, or `403` if the account is pending or suspended. Changing the password with `PATCH /api/me` signs out every other device (their tokens are deleted).

`GET /api/me`
```json
{ "account_id": 2, "name": "Rahim Ahmed", "role": "student", "status": "active",
  "card": { "card_no": "LIB-0002", "expires_on": "2027-04-11" },
  "open_loans": 2, "borrowing_blocked": 0 }
```

## 2. Members and cards

| Endpoint | Who | Does |
|---|---|---|
| `GET /api/accounts?status=pending` | librarian | List members; filter by `status` or `role` |
| `GET /api/accounts/7` | librarian | One member, with cards, open loans and unpaid fines |
| `PATCH /api/accounts/7` | librarian | `{ "status": "active" }`: approve, suspend or deactivate |
| `POST /api/accounts/7/cards` | librarian | Issues a new card; an existing active card becomes `replaced` |
| `PATCH /api/me/card` | student | `{ "status": "lost" }`: report the card lost |
| `GET /api/cards?status=lost` | librarian | Lost cards waiting for a new one |

Deactivating a member with books still out or unpaid fines returns `409`. Librarian accounts cannot be changed through the API (`409`); they are managed in the database. Card numbers look like `LIB-0010-1`: the member's number, then which card it is. Only `active` students get a card.

## 3. Catalogue

| Endpoint | Who | Does |
|---|---|---|
| `GET /api/books?q=&genre=` | both | Search and browse (keyword search for now) |
| `GET /api/books/5` | both | One book: details, authors, copies, expected return date if every copy is out, number of holds |
| `GET /api/isbn/9780547928227` | librarian | Looks the ISBN up on Open Library to fill the form; saves nothing. `404` if Open Library does not know it |
| `POST /api/books` | librarian | Adds a book |
| `PATCH /api/books/5` | librarian | Edits a book |
| `DELETE /api/books/5` | librarian | Answers `204` with no body. Only if no copy was ever lent; otherwise `409` |
| `POST /api/books/5/copies` | librarian | Adds a copy: `{ "barcode": "C0050", "shelf_mark": "FA-01" }` |
| `PATCH /api/copies/30` | librarian | Changes the shelf mark, or `{ "status": "withdrawn" }`; a copy on loan cannot be withdrawn (`409`) |
| `GET /api/authors`, `GET /api/genres` | both | Lists for filters and forms |
| `POST /api/authors`, `PATCH /api/authors/3` | librarian | Adds or renames an author |
| `POST /api/genres`, `PATCH /api/genres/2` | librarian | Adds or renames a genre |

`GET /api/books` (already built)
```json
[ { "book_id": 8, "title": "The Hobbit", "title_banglish": null, "published_year": 1937,
    "genre": "Fantasy", "authors": "J. R. R. Tolkien", "total_copies": 2, "available_copies": 0 } ]
```

`GET /api/isbn/9780547928227` (Open Library has no description; the librarian types one)
```json
{ "isbn": "9780547928227", "title": "The Hobbit", "authors": ["J.R.R. Tolkien"],
  "publisher": "Mariner Books", "published_year": 2012, "subjects": ["..."], "cover": "https://..." }
```

`POST /api/books`
```json
{ "isbn": "9780547928227", "title": "The Hobbit", "title_banglish": null,
  "publisher": "Houghton Mifflin", "published_year": 1937, "genre_id": 8,
  "description": "…", "author_ids": [7] }
```

## 4. Loans

| Endpoint | Who | Does |
|---|---|---|
| `POST /api/loans` | librarian | Issues a book |
| `PATCH /api/loans/12/return` | librarian | Returns a book |
| `PATCH /api/loans/12/renewal` | student | Asks to renew (own loan only) |
| `PATCH /api/loans/12/renewal/verdict` | librarian | `{ "decision": "approved" }` or `"declined"` |
| `GET /api/loans` | both | Students get their own loans; librarians get all |

Filters for `GET /api/loans`: `status=open|overdue|returned|due_soon`, `renewal=requested`, and for librarians `account_id=7`. Each loan includes `waiting`: how many students have a hold on that book, so the librarian can see it before answering a renewal.

`POST /api/loans`
```json
{ "copy_barcode": "C0014", "student_no": "2211000045" }
```
Runs as **one transaction**: locks the student's account row, then checks that the account is active, no loan is 31+ days overdue and unpaid, fewer than 3 books are out, and the copy is available. Returns `201` with the loan (`due_date` = today + 14 days), or `409` naming the rule that failed. If the student had a hold on this book, it becomes `fulfilled`. If that was the last copy on the shelf, other students' `ready` holds go back to `waiting`, so no one sees an out-of-date "a copy is back" notice.

`PATCH /api/loans/12/return`: sets `returned_at` and puts the copy back on the shelf (`available`). Every `waiting` hold on that book becomes `ready`, which notifies those students. The copy is **not** kept for them: whoever comes to the desk first borrows it. Returns the loan.

`PATCH /api/loans/12/renewal`: allowed once, while the loan is open and not overdue; sets `renewal_status` to `requested`.

`PATCH /api/loans/12/renewal/verdict`: `approved` adds 14 days to `due_date` and sets `renewal_count` to 1. Returns the loan, or `409` if no request is waiting.

## 5. Holds

| Endpoint | Who | Does |
|---|---|---|
| `POST /api/holds` | student | `{ "book_id": 9 }`: asks to be told when a copy comes back (only when no copy is available) |
| `PATCH /api/holds/4` | student | `{ "status": "cancelled" }`: no longer wants to be told (own hold only) |
| `GET /api/holds?book_id=9` | both | Students get their own holds; librarians get all. Filter `status=waiting|ready` |

A hold is a **notification only**. It does not reserve a copy.

| Hold status | Meaning |
|---|---|
| `waiting` | Every copy is out; the student wants to know when one comes back |
| `ready` | A copy was returned; the student's home page shows "A copy is back on the shelf" (`GET /api/holds?status=ready`) |
| `fulfilled` | The student borrowed the book |
| `cancelled` | The student cancelled the hold |

Placing a hold returns `409` if a copy is on the shelf (borrow it instead) or if the student already has a `waiting` or `ready` hold on that book.

## 6. Fines

| Endpoint | Who | Does |
|---|---|---|
| `GET /api/fines?status=unpaid` | both | Reads the `loan_fine_status` view. Students see their own; librarians see all. `status=unpaid|paid|blocking` |
| `POST /api/fines` | librarian | Records a payment: `{ "loan_id": 4 }` |

The page never sends an amount. The server reads the amount from `loan_fine_status` (100, 200 or 300 Tk) and saves it, with the librarian as `received_by`. Paying a loan that is already paid returns `409`.

`GET /api/fines` returns a list of rows like this:

```json
{ "loan_id": 4, "account_id": 5, "name": "Sadia Islam", "days_overdue": 40,
  "fine_amount": 300, "is_paid": 0, "blocks_borrowing": 1 }
```

`POST /api/fines` returns `201` with the loan's row from the view, now with `"is_paid": 1` and `"blocks_borrowing": 0`.

## 7. Smart Discovery (later)

| Endpoint | Who | Does |
|---|---|---|
| `GET /api/books?q=…&mode=meaning` | both | Search by what a book is about |
| `GET /api/books/5/similar` | both | Read-alikes |
| `GET /api/recommendations` | student | Suggestions from borrowing history, limited to copies on the shelf |

## Branches

Each area is built on its own branch and merged into `main` through a reviewed pull request.

| Branch | Sections |
|---|---|
| `feature/auth` | 1 |
| `feature/members-cards` | 2 |
| `feature/catalogue` | 3 |
| `feature/loans` | 4 |
| `feature/holds-fines` | 5, 6 |
| `feature/discovery` | 7 |

Sign-in (`feature/auth`) is needed by every other area to know who is asking. Until it is merged, other branches can test with a fixed account.

## Trying the endpoints

Test endpoints with **Postman**. `postman/Library-API.postman_collection.json` has every endpoint above, ready to send, with example IDs that match the sample data. Import it with the **Import** button in Postman. The API guide (section 5) explains the steps, including signing in.
