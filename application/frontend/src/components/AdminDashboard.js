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
      navigate('/app/login');
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

  const handleLogout = () => {
    // Clear the user info from localStorage
    localStorage.removeItem('userInfo');
    // Redirect to the /app page after logout
    navigate('/app');
  };

  return (
    <div className="container">
      <h2 className="my-4">Admin Dashboard</h2>
      <button onClick={handleLogout} className="btn btn-primary mb-4">
        Logout
      </button>
      <PlayerForm />
      <PlayerList players={players} onDelete={handleDelete} />
    </div>
  );
};

export default AdminDashboard;
