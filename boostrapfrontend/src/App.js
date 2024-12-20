// src/App.js

	import React from 'react';
	import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
	import LoginPage from '../src/components/LoginPage';
	import Dashboard from '../src/components/Dashboard';
	import AdminDashboard from './components/AdminDashboard';
	import './App.css';
	import 'bootstrap/dist/css/bootstrap.min.css';



	const App = () => {
		  return (
			      <Router>
			        <div className="App">
			          <h1>Player Management System</h1>
			          <Routes>
			            <Route path="/login" element={<LoginPage />} />
			            <Route path="/dashboard" element={<Dashboard />} />
			            <Route path="/admin" element={<AdminDashboard />} />
			            <Route path="/" element={<LoginPage />} />
			          </Routes>
			        </div>
			      </Router>
			    );
	};

export default App;
