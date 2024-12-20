// src/components/Dashboard.js

import React, { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { getOnePlayer } from '../services/playerService';

const Dashboard = () => {
  const [userInfo, setUserInfo] = useState(null);
  const navigate = useNavigate();

  useEffect(() => {
    
    const fetchUserInfo = async () => {
      const user = await getOnePlayer(1);  
      if (user) {
        console.log(user);
        setUserInfo(user);  
      } else {
        navigate('/login');  
      }
    };

    fetchUserInfo();  
  }, [navigate]);  

  return (
    <div className="container mt-5">
      <h2 className="text-center mb-4 text-primary">User Dashboard</h2>
      {userInfo ? (
        <div className="card shadow-lg border-primary" style={{ borderRadius: '15px' }}>
          <div className="card-body">
            <h5 className="card-title text-success">Welcome, <strong>{userInfo.name}</strong>!</h5>
            <h6 className="card-subtitle mb-4 text-muted">General Information</h6>
            {/* <ul className="list-unstyled">
              <li><strong>Id:</strong> {userInfo.id}</li>
              <li><strong>Role:</strong> {userInfo.position}</li>
              <li><strong>Team:</strong> {userInfo.team}</li>
              <li><strong>Age:</strong> {userInfo.age}</li>
            </ul> */}
            {/* <div className="d-flex justify-content-end">
              <button className="btn btn-warning btn-sm">Edit Profile</button>
            </div> */}
<table className="table" style={{ borderCollapse: 'collapse', width: '100%' }}>
  <tbody>
    <tr style={{ borderBottom: '1px solid #ddd' }}>
      <td style={{ padding: '8px', border: '1px solid #ddd' }}><strong>Id:</strong></td>
      <td style={{ padding: '8px', border: '1px solid #ddd' }}>{userInfo.id}</td>
    </tr>
    <tr style={{ borderBottom: '1px solid #ddd' }}>
      <td style={{ padding: '8px', border: '1px solid #ddd' }}><strong>Role:</strong></td>
      <td style={{ padding: '8px', border: '1px solid #ddd' }}>{userInfo.position}</td>
    </tr>
    <tr style={{ borderBottom: '1px solid #ddd' }}>
      <td style={{ padding: '8px', border: '1px solid #ddd' }}><strong>Team:</strong></td>
      <td style={{ padding: '8px', border: '1px solid #ddd' }}>{userInfo.team}</td>
    </tr>
    <tr>
      <td style={{ padding: '8px', border: '1px solid #ddd' }}><strong>Age:</strong></td>
      <td style={{ padding: '8px', border: '1px solid #ddd' }}>{userInfo.age}</td>
    </tr>
  </tbody>
</table>

          </div>
        </div>
      ) : (
        <p className="text-center">Loading...</p>
      )}
    </div>
  );
};

export default Dashboard;
