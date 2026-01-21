import { useEffect, useState } from 'react';
import { getFounders } from '../api/founders.api';

export function useFounders() {
  const [founders, setFounders] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    getFounders()
      .then((res) => setFounders(res.data))
      .catch((err) => setError(err.message))
      .finally(() => setLoading(false));
  }, []);

  return { founders, loading, error };
}
