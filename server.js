const express = require('express');
const bodyParser = require('body-parser');
const { Client } = require('pg');
const cors = require('cors'); // Import cors


const app = express();
const PORT = 3000;

app.use(bodyParser.json());

var corsOptions = {
    origin: '*'
}

app.use(cors(corsOptions))

const client = new Client({
  user: 'postgres',
  host: 'localhost',
  database: 'cs458',
  password: 'password',
  port: 6530,
});

client.connect()
  .then(() => console.log('Connected to PostgreSQL'))
  .catch(err => console.error('Error connecting to PostgreSQL', err));


app.post('/loginEmail', async (req, res) => {
  console.log("loginEmail called");
  const { email, password } = req.body;
  try {
    const query = 'SELECT email, phone_number FROM client WHERE email = $1 AND password = $2';
    const { rows } = await client.query(query, [email, password]);

    if (rows.length > 0) {
      res.status(200).json({ message: rows });
    } else {
      res.status(401).json({ message: 'Invalid email or password' });
    }
  } catch (err) {
    console.error('Error executing SQL query', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

app.post('/loginPhoneNumber', async (req, res) => {

    console.log("loginPhoneNumber Called")

    const phoneNumber = String(req.body.phone_number);
    const password = String(req.body.password)


  try {
    const query = 'SELECT email, phone_number FROM client WHERE phone_number = $1 AND password = $2';
    const { rows } = await client.query(query, [phoneNumber, password]);
    console.log(rows);
    

    if (rows.length > 0) {
        console.log("Entered")
      res.status(200).json({ message: rows });
    } else {
      res.status(401).json({ message: 'Invalid phone number or password' });
    }
  } catch (err) {
    console.error('Error executing SQL query', err);
    res.status(500).json({ message: 'Internal server error' });
  }
});

app.post('/login', async (req, res) => {
  console.log(req.body)
});
app.post('/sun', async (req, res) => {
  console.log(req.body)
});
app.post('/sea', async (req, res) => {
  console.log(req.body)
});
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
