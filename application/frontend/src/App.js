// src/App.js

import React from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import LoginPage from '../src/components/LoginPage';
import Dashboard from '../src/components/Dashboard';
import AdminDashboard from './components/AdminDashboard';
import './App.css';

const App = () => {
  return (
    <Router>
      <div className="App">
        <h1>Player Management System</h1>
        <Routes>
          <Route path="/app/login" element={<LoginPage />} />
          <Route path="/app/dashboard" element={<Dashboard />} />
          <Route path="/app/admin" element={<AdminDashboard />} />
          <Route path="/app" element={<LoginPage />} />
        </Routes>
      </div>
    </Router>
  );
};

export default App;
