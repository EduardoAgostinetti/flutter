const { Pool } = require('pg');


const pool = new Pool({
  user: 'postgres', 
  host: 'localhost',
  database: 'appdesport', 
  password: 'root', 
  port: 5432,
});

pool.connect((err, client, release) => {
  if (err) {
    return console.error('Erro ao conectar ao banco de dados:', err.stack);
  }
  console.log('Conectado ao banco de dados PostgreSQL');
  release();
});

module.exports = pool;
