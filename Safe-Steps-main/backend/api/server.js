require('dotenv').config();

const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const {
  query,
  testConnection
} = require('./database');

const app = express();

const PORT =
  process.env.PORT || 3000;


// ========================================
// MIDDLEWARE
// ========================================

app.use(cors());

app.use(
  express.json({
    limit: '1mb'
  })
);


// ========================================
// DATABASE SETUP
// ========================================

async function initialiseDatabase() {
  await testConnection();

  const schemaPath = path.join(
    __dirname,
    'schema.sql'
  );

  const schema = fs.readFileSync(
    schemaPath,
    'utf8'
  );

  await query(schema);

  console.log(
    'Safe Steps database is ready.'
  );
}


// ========================================
// HOME
// ========================================

app.get('/', (req, res) => {
  res.json({
    success: true,
    message: 'Safe Steps API is running'
  });
});


// ========================================
// HEALTH CHECK
// ========================================

app.get(
  '/api/health',
  async (req, res) => {
    try {
      const result = await query(
        'SELECT NOW() AS time'
      );

      res.json({
        success: true,
        database: 'connected',
        time: result.rows[0].time
      });
    } catch (error) {
      console.error(
        'Health check error:',
        error
      );

      res.status(500).json({
        success: false,
        database: 'disconnected'
      });
    }
  }
);


// ========================================
// GET ALL VISITORS
// ========================================

app.get(
  '/api/visitors',
  async (req, res) => {
    try {
      const result = await query(`
        SELECT
          id,
          name,
          email,
          type,
          purpose,
          location,
          host_name AS "hostName",
          contact_number AS "contactNumber",
          check_in AS "checkIn",
          check_out AS "checkOut",
          status

        FROM visitors

        ORDER BY check_in DESC
      `);

      res.json({
        success: true,
        visitors: result.rows
      });
    } catch (error) {
      console.error(
        'Load visitors error:',
        error
      );

      res.status(500).json({
        success: false,
        error: 'Unable to load visitors.'
      });
    }
  }
);


// ========================================
// CREATE VISITOR / CHECK IN
// ========================================

app.post(
  '/api/visitors',
  async (req, res) => {
    try {
      const {
        id,
        name,
        email,
        type,
        purpose,
        location,
        hostName,
        contactNumber,
        checkIn
      } = req.body;

      if (
        !id ||
        !name ||
        !email ||
        !type ||
        !location ||
        !checkIn
      ) {
        return res.status(400).json({
          success: false,
          error:
            'Required visitor information is missing.'
        });
      }

      const result = await query(
        `
        INSERT INTO visitors (
          id,
          name,
          email,
          type,
          purpose,
          location,
          host_name,
          contact_number,
          check_in,
          check_out,
          status
        )

        VALUES (
          $1,
          $2,
          $3,
          $4,
          $5,
          $6,
          $7,
          $8,
          $9,
          NULL,
          'Active'
        )

        RETURNING
          id,
          name,
          email,
          type,
          purpose,
          location,
          host_name AS "hostName",
          contact_number AS "contactNumber",
          check_in AS "checkIn",
          check_out AS "checkOut",
          status
        `,
        [
          String(id),

          String(name).trim(),

          String(email)
            .trim()
            .toLowerCase(),

          String(type),

          String(purpose || ''),

          String(location),

          String(hostName || ''),

          String(contactNumber || ''),

          checkIn
        ]
      );

      res.status(201).json({
        success: true,
        visitor: result.rows[0]
      });
    } catch (error) {
      console.error(
        'Create visitor error:',
        error
      );

      if (error.code === '23505') {
        return res.status(409).json({
          success: false,
          error:
            'A visitor record with that ID already exists.'
        });
      }

      res.status(500).json({
        success: false,
        error:
          'Unable to create visitor.'
      });
    }
  }
);


// ========================================
// COMPLETE VISITOR
// ========================================

app.put(
  '/api/visitors/:id/complete',
  async (req, res) => {
    try {
      const visitorId =
        req.params.id;

      const current =
        await query(
          `
          SELECT
            id,
            status

          FROM visitors

          WHERE id = $1
          `,
          [visitorId]
        );

      if (
        current.rows.length === 0
      ) {
        return res.status(404).json({
          success: false,
          error: 'Visitor not found.'
        });
      }

      if (
        current.rows[0].status ===
        'Complete'
      ) {
        return res.status(409).json({
          success: false,
          error:
            'This visit is already complete.'
        });
      }

      const result =
        await query(
          `
          UPDATE visitors

          SET
            status = 'Complete',
            check_out = NOW()

          WHERE id = $1
            AND status = 'Active'

          RETURNING
            id,
            name,
            email,
            type,
            purpose,
            location,
            host_name AS "hostName",
            contact_number AS "contactNumber",
            check_in AS "checkIn",
            check_out AS "checkOut",
            status
          `,
          [visitorId]
        );

      res.json({
        success: true,
        visitor: result.rows[0]
      });
    } catch (error) {
      console.error(
        'Complete visitor error:',
        error
      );

      res.status(500).json({
        success: false,
        error:
          'Unable to complete visitor.'
      });
    }
  }
);


// ========================================
// CHECK OUT BY EMAIL
// ========================================

app.post(
  '/api/visitors/checkout',
  async (req, res) => {
    try {
      const email = String(
        req.body.email || ''
      )
        .trim()
        .toLowerCase();

      if (!email) {
        return res.status(400).json({
          success: false,
          error: 'Email is required.'
        });
      }

      const activeVisitor =
        await query(
          `
          SELECT id

          FROM visitors

          WHERE
            LOWER(email) = LOWER($1)
            AND status = 'Active'
            AND check_out IS NULL

          ORDER BY check_in DESC

          LIMIT 1
          `,
          [email]
        );

      if (
        activeVisitor.rows.length === 0
      ) {
        return res.status(404).json({
          success: false,
          error:
            'No active visit was found for that email.'
        });
      }

      const visitorId =
        activeVisitor.rows[0].id;

      const result =
        await query(
          `
          UPDATE visitors

          SET
            status = 'Complete',
            check_out = NOW()

          WHERE id = $1
            AND status = 'Active'

          RETURNING
            id,
            name,
            email,
            type,
            purpose,
            location,
            host_name AS "hostName",
            contact_number AS "contactNumber",
            check_in AS "checkIn",
            check_out AS "checkOut",
            status
          `,
          [visitorId]
        );

      res.json({
        success: true,
        visitor: result.rows[0]
      });
    } catch (error) {
      console.error(
        'Checkout error:',
        error
      );

      res.status(500).json({
        success: false,
        error:
          'Unable to check out visitor.'
      });
    }
  }
);


// ========================================
// 404
// ========================================

app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Route not found.'
  });
});


// ========================================
// START SERVER
// ========================================

async function startServer() {
  try {
    await initialiseDatabase();

    app.listen(
      PORT,
      '0.0.0.0',
      () => {
        console.log(
          `Safe Steps API running on port ${PORT}`
        );
      }
    );
  } catch (error) {
    console.error(
      'Safe Steps failed to start:',
      error
    );

    process.exit(1);
  }
}

startServer();