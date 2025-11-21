# Backend - Task Management API

Express.js backend API for the Task Management application.

## Setup

```bash
npm install
```

## Development

```bash
npm run dev
```

The server will run on http://localhost:3001

## Production

```bash
npm start
```

## API Endpoints

- `GET /api/health` - Health check
- `GET /api/tasks` - Get all tasks
- `POST /api/tasks` - Create a new task
- `PUT /api/tasks/:id` - Update a task
- `DELETE /api/tasks/:id` - Delete a task

## Docker

```bash
docker build -t task-backend .
docker run -p 3001:3001 task-backend
```

## Environment Variables

- `PORT`: Server port (default: 3001)
