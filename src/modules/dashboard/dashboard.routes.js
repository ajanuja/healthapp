import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";

import {
    getDashboard,
    getWeeklySummary
} from "./dashboard.controller.js";

const router = express.Router();


// MAIN DASHBOARD
router.get(
    "/",
    authMiddleware,
    getDashboard
);


// WEEKLY SUMMARY
router.get(
    "/weekly-summary",
    authMiddleware,
    getWeeklySummary
);

export default router;