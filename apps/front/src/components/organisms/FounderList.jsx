import { useFounders } from '../../hooks/useFounders';
import Loader from '../atoms/Loader';

export default function FounderList() {
  const { founders, loading, error } = useFounders();

  if (loading) return <Loader />;
  if (error) return <p>Error: {error}</p>;

  return (
    <ul>
      {founders.map((founder, index) => (
        <li key={index}>{founder.name}</li>
      ))}
    </ul>
  );
}
