// src/services/playerService.js

const API_URL = 'http://141.148.210.44:5000';

export const login = async (username, password) => {
  const response = await fetch(`${API_URL}/login`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ username, password }),
  });
  const data = await response.json();
  if (response.ok) {
    return data;
  } else {
    throw new Error(data.message);
  }
};

export const getPlayers = async () => {
  const response = await fetch(`${API_URL}/players`);
  const data = await response.json();
  return data;
};

//-------------------------added
export const getOnePlayer = async (playerId) => {
  const response = await fetch(`${API_URL}/players/${playerId}`, {
    method: 'GET',
    headers: {'Content-Type': 'application/json'},
  });
  const data = await response.json();
  return data;
};

export const addPlayer = async (player) => {
  const response = await fetch(`${API_URL}/players`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(player),
  });
  const data = await response.json();
  return data;
};

export const updatePlayer = async (playerId, player) => {
  const response = await fetch(`${API_URL}/players/${playerId}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(player),
  });
  const data = await response.json();
  return data;
};

export const deletePlayer = async (playerId) => {
  const response = await fetch(`${API_URL}/players/${playerId}`, {
    method: 'DELETE',
  });
  const data = await response.json();
  return data;
};
