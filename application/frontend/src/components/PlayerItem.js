// src/components/PlayerItem.js

import React from 'react';

const PlayerItem = ({ player, onDelete }) => {
  return (
    <li className="list-group-item d-flex justify-content-between align-items-center">
      {player.name} - {player.position} ({player.team}) 
      <button className="btn btn-danger btn-sm" onClick={() => onDelete(player.id)}>Delete</button>
    </li>
  );
};

export default PlayerItem;
 