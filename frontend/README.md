# Frontend - Task Manager React App

A modern React-based frontend for the Task Management application.

## Setup

```bash
npm install
```

## Development

```bash
npm start
```

The app will open at http://localhost:3000 and connect to the backend API at http://localhost:3001

## Build

```bash
npm build
```

## Docker

```bash
docker build -t task-frontend .
docker run -p 3000:3000 task-frontend
```

## Environment Variables

- `REACT_APP_API_URL`: Backend API URL (default: http://localhost:3001/api)
