import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";
import roleMiddleware from "../../middleware/role.middleware.js";

import {

    createMedicineLog,
    getMyMedicineLogs,
    getMedicineLogsByMedicine

} from "./medicineLog.controller.js";

const router = express.Router();


// MARK MEDICINE TAKEN/SKIPPED
router.post(
    "/",
    authMiddleware,
    roleMiddleware("PATIENT"),
    createMedicineLog
);


// GET ALL LOGS
router.get(
    "/",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getMyMedicineLogs
);


// GET LOGS FOR SPECIFIC MEDICINE
router.get(
    "/:medicineId",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getMedicineLogsByMedicine
);

export default router;