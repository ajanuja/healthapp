import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";
import roleMiddleware from "../../middleware/role.middleware.js";

import {
    addMedicineForPatient
} from "./doctorMedicine.controller.js";

const router = express.Router();

router.post(
    "/patients/:patientId/medicines",
    authMiddleware,
    roleMiddleware("DOCTOR"),
    addMedicineForPatient
);

export default router;