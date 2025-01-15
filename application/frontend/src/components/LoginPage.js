// src/components/LoginPage.js

import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { login } from '../services/playerService';

const LoginPage = () => {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [errorMessage, setErrorMessage] = useState('');
  const navigate = useNavigate();

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const user = await login(username, password);
      localStorage.setItem('userInfo', JSON.stringify(user));
      if (user.role === 'admin') {
        navigate('/app/admin');  // Admin dashboard
      } else {
        navigate('/app/dashboard');  // User dashboard
      }
    } catch (error) {
      setErrorMessage('Invalid username or password');
    }
  };

  return (
    <div className="container">
      <h2 className="my-4">Login</h2>
      {errorMessage && <p className="text-danger">{errorMessage}</p>}
      <form onSubmit={handleLogin} className="w-50 mx-auto">
        <div className="mb-3">
          <input
            type="text"
            className="form-control"
            placeholder="Username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            required
          />
        </div>
        <div className="mb-3">
          <input
            type="password"
            className="form-control"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        <button type="submit" className="btn btn-primary w-100">Login</button>
      </form>
    </div>
  );
};

export default LoginPage;
