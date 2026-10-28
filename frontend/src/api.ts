// Calls the backend and returns the JSON answer.
// Throws an Error with the backend's message if the request is refused.
export async function api(path: string, method = 'GET', body?: unknown) {
  // The token from logging in, if there is one (see logIn below).
  const token = localStorage.getItem('token')

  const res = await fetch(path, {
    method,
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
    },
    body: body === undefined ? undefined : JSON.stringify(body),
  })

  if (res.status === 204) {
    return null
  }
  const data = await res.json().catch(() => null)
  if (!res.ok) {
    throw new Error(data?.message ?? `Request failed (${res.status})`)
  }
  return data
}

// Logs in, keeps the token for the next requests, and returns the account.
export async function logIn(email: string, password: string) {
  const { token, account } = await api('/api/auth/login', 'POST', { email, password })
  localStorage.setItem('token', token)
  return account
}

// Logs out and forgets the token.
export async function logOut() {
  await api('/api/auth/logout', 'POST')
  localStorage.removeItem('token')
}
