// Calls the backend and returns the JSON answer.
// Throws an Error with the backend's message if the request is refused.
export async function api(path: string, method = 'GET', body?: unknown) {
  // Laravel needs this header for POST, PATCH and DELETE once sign-in is on.
  const xsrf = document.cookie
    .split('; ')
    .find((c) => c.startsWith('XSRF-TOKEN='))
    ?.split('=')[1]

  const res = await fetch(path, {
    method,
    headers: {
      Accept: 'application/json',
      'Content-Type': 'application/json',
      ...(xsrf ? { 'X-XSRF-TOKEN': decodeURIComponent(xsrf) } : {}),
    },
    body: body === undefined ? undefined : JSON.stringify(body),
  })

  const data = await res.json().catch(() => null)
  if (!res.ok) {
    throw new Error(data?.message ?? `Request failed (${res.status})`)
  }
  return data
}
