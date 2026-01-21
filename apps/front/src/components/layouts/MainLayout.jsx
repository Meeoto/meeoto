import { Outlet } from 'react-router-dom';
import Navbar from '../molecules/Navbar';

export default function MainLayout() {
  return (
    <>
      <Navbar />
      <main>
        <Outlet />
      </main>
      <footer>© 2026 Meeoto</footer>
    </>
  );
}
