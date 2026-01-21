import { httpGet } from './http';

export function getFounders() {
  return httpGet('/founders');
}
