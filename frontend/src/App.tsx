import { useEffect, useState } from 'react'

// One row of GET /api/books (see backend/app/Http/Controllers/BookController.php).
type Book = {
  book_id: number
  title: string
  title_banglish: string | null
  published_year: number | null
  genre: string | null
  authors: string | null
  total_copies: number
  available_copies: number
}

function App() {
  const [books, setBooks] = useState<Book[]>([])
  const [error, setError] = useState<string | null>(null)

  // Load the books once, when the page first appears.
  useEffect(() => {
    fetch('/api/books')
      .then((res) => {
        if (!res.ok) throw new Error(`Server answered ${res.status}`)
        return res.json()
      })
      .then(setBooks)
      .catch((err: Error) => setError(err.message))
  }, [])

  return (
    <main className="mx-auto max-w-6xl p-6">
      <h1 className="mb-1 text-3xl font-bold">Library catalogue</h1>
      <p className="mb-6 text-gray-500">{books.length} books</p>

      {error && (
        <p className="rounded bg-red-100 p-3 text-red-700">
          Could not load books: {error}. Is the backend running?
        </p>
      )}

      <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {books.map((book) => (
          <li key={book.book_id} className="rounded-lg border border-gray-200 p-4 shadow-sm">
            <h2 className="font-semibold">{book.title}</h2>
            <p className="text-sm text-gray-600">{book.authors}</p>
            <p className="mt-2 text-xs text-gray-500">
              {book.genre}
              {book.published_year && ` · ${book.published_year}`}
            </p>
            <p
              className={`mt-3 text-sm font-medium ${
                book.available_copies > 0 ? 'text-green-700' : 'text-red-700'
              }`}
            >
              {book.available_copies} of {book.total_copies} available
            </p>
          </li>
        ))}
      </ul>
    </main>
  )
}

export default App
