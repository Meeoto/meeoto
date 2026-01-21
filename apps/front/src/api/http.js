const API_BASE_URL = '/api';

export async function httpGet(url) {
  const response = await fetch(`${API_BASE_URL}${url}`);
  if (!response.ok) throw new Error('HTTP error');
  return response.json();
}
