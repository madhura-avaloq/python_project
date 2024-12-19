// src/components/AdminDashboard.js

import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getPlayers, deletePlayer } from '../services/playerService';
import PlayerForm from './PlayerForm';
import PlayerList from './PlayerList';

const AdminDashboard = () => {
  const [players, setPlayers] = useState([]);
  const navigate = useNavigate();

  useEffect(() => {
    const userInfo = JSON.parse(localStorage.getItem('userInfo'));
    if (!userInfo || userInfo.role !== 'admin') {
      navigate('/login');
    }

    // Fetch all players if the user is an admin
    const fetchPlayers = async () => {
      const playersData = await getPlayers();
      setPlayers(playersData);
    };
    fetchPlayers();
  }, [navigate]);

  const handleDelete = async (playerId) => {
    await deletePlayer(playerId);
    setPlayers(players.filter(player => player.id !== playerId));
  };

  return (
    <div className="container">
      <h2 className="my-4">Admin Dashboard</h2>
      <PlayerForm />
      <PlayerList players={players} onDelete={handleDelete} />
    </div>
  );
};

export default AdminDashboard;
