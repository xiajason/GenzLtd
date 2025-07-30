// Example API service file
import axios from 'axios';

export const getHelloMessage = async () => {
  // {{ edit_3: Use correct API endpoint }}
  const response = await axios.get('/vuecmf/hello');
  return response.data;
};