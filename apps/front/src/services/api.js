export async function fetchFounders() {
  const response = await fetch('/api/founders');

  if (!response.ok) {
    throw new Error('Erreur lors du chargement des fondateurs');
  }

  return response.json();
}
