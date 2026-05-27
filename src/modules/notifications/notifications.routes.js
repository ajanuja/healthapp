import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";

import {

    getMyNotifications,
    markNotificationAsRead

} from "./notifications.controller.js";

const router = express.Router();


// GET MY NOTIFICATIONS
router.get(
    "/",
    authMiddleware,
    getMyNotifications
);


// MARK AS READ
router.put(
    "/:id/read",
    authMiddleware,
    markNotificationAsRead
);

export default router;