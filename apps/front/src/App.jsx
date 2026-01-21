import { useEffect, useState } from 'react';
import './App.css';
import { fetchFounders } from './services/api';

function App() {
  const [founders, setFounders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchFounders()
      .then((data) => {
        setFounders(data.data);
      })
      .catch((err) => {
        setError(err.message);
      })
      .finally(() => {
        setLoading(false);
      });
  }, []);

  if (loading) return <p>Chargement...</p>;
  if (error) return <p>Erreur : {error}</p>;

  return (
    <div className="App">
      <h1>Liste des fondateurs</h1>

      <ul>
        {founders.map((founder, index) => (
          <li key={index}>{founder.name}</li>
        ))}
      </ul>
    </div>
  );
}

export default App;
