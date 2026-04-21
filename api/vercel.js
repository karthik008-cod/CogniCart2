/**
 * api/vercel.js  —  Vercel Serverless Entry Point
 *
 * Vercel invokes this file directly as module.exports(req, res).
 * It wraps the existing router (api/index.js) in a proper Express app
 * so Vercel gets a callable request handler.
 *
 * Local dev uses script.js instead, which mounts the router directly.
 */

require("dotenv").config();

const express = require("express");
const cors    = require("cors");
const path    = require("path");
const router  = require("./index");   // the existing router

const app = express();

app.use(cors());
app.use(express.json());

// Serve static files (index.html, style.css, watchlist.html, etc.)
app.use(express.static(path.join(__dirname, "../public")));

// Mount all /api/* routes from the main router
app.use("/api", router);

// Fallback: any non-/api route serves the frontend SPA
app.use((req, res) => {
  res.sendFile(path.join(__dirname, "../public", "index.html"));
});

// Export the Express app as the Vercel serverless handler
module.exports = app;
