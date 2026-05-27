import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";

import roleMiddleware from "../../middleware/role.middleware.js";

import {

    getMyPatients,
    getPatientAlerts,
    getPatientVitals

} from "./caregiver.controller.js";

const router = express.Router();


// GET ASSIGNED PATIENTS
router.get(
    "/patients",
    authMiddleware,
    roleMiddleware("CAREGIVER"),
    getMyPatients
);


// GET PATIENT ALERTS
router.get(
    "/patients/:id/alerts",
    authMiddleware,
    roleMiddleware("CAREGIVER"),
    getPatientAlerts
);


// GET PATIENT VITALS
router.get(
    "/patients/:id/vitals",
    authMiddleware,
    roleMiddleware("CAREGIVER"),
    getPatientVitals
);

export default router;