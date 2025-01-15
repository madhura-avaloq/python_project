// src/components/PlayerForm.js

import React, { useState } from 'react';
import { addPlayer, updatePlayer } from '../services/playerService';

const PlayerForm = ({ playerToEdit }) => {
  const [name, setName] = useState(playerToEdit?.name || '');
  const [age, setAge] = useState(playerToEdit?.age || '');
  const [team, setTeam] = useState(playerToEdit?.team || '');
  const [position, setPosition] = useState(playerToEdit?.position || '');

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (playerToEdit) {
      await updatePlayer(playerToEdit.id, { name, age, team, position });
    } else {
      await addPlayer({ name, age, team, position });
    } 
    setName('');
    setAge('');
    setTeam('');
    setPosition('');
  };

  return (
    <form onSubmit={handleSubmit} className="mb-4">
      <div className="mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Name"
          value={name}
          onChange={(e) => setName(e.target.value)}
          required
        />
      </div>
      <div className="mb-3">
        <input
          type="number"
          className="form-control"
          placeholder="Age"
          value={age}
          onChange={(e) => setAge(e.target.value)}
          required
        />
      </div>
      <div className="mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Team"
          value={team}
          onChange={(e) => setTeam(e.target.value)}
          required
        />
      </div>
      <div className="mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Position"
          value={position}
          onChange={(e) => setPosition(e.target.value)}
          required
        />
      </div>
      <button type="submit" className="btn btn-primary">
        {playerToEdit ? 'Update Player' : 'Add Player'}
      </button>
    </form>
  );
};

export default PlayerForm;
