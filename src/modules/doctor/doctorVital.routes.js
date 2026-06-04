import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";
import roleMiddleware from "../../middleware/role.middleware.js";

import {
    getPatientVitals
} from "./doctorVital.controller.js";

const router = express.Router();

router.get(
    "/patients/:patientId/vitals",
    authMiddleware,
    roleMiddleware("DOCTOR"),
    getPatientVitals
);

export default router;