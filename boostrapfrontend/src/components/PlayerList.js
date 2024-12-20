// src/components/PlayerList.js

import React from 'react';
import PlayerItem from './PlayerItem';

const PlayerList = ({ players, onDelete }) => {
  return (
    <div>
      <h3>Player List</h3>
      <ul className="list-group">
        {players.map((player) => (
          <PlayerItem key={player.id} player={player} onDelete={onDelete} />
        ))}
      </ul>
    </div>
  );
};

export default PlayerList;
