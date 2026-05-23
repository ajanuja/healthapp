import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";
import roleMiddleware from "../../middleware/role.middleware.js";

import {
    createPatientProfile,
    getMyProfile,
    updatePatientProfile
} from "./patientProfile.controller.js";

const router = express.Router();

router.post(
    "/",
    authMiddleware,
    roleMiddleware("PATIENT"),
    createPatientProfile
);

router.get(
    "/me",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getMyProfile
);

router.put(
    "/",
    authMiddleware,
    roleMiddleware("PATIENT"),
    updatePatientProfile
);

export default router;