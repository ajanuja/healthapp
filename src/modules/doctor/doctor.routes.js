import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";

import roleMiddleware from "../../middleware/role.middleware.js";

import {

    getMyPatients,
    getPatientReport

} from "./doctor.controller.js";

const router = express.Router();


// GET ASSIGNED PATIENTS
router.get(
    "/patients",
    authMiddleware,
    roleMiddleware("DOCTOR"),
    getMyPatients
);


// GET PATIENT REPORT
router.get(
    "/patients/:id/report",
    authMiddleware,
    roleMiddleware("DOCTOR"),
    getPatientReport
);

export default router;