import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";
import roleMiddleware from "../../middleware/role.middleware.js";

import {
    createMedicine,
    getMyMedicines,
    getSingleMedicine,
    updateMedicine,
    deleteMedicine
} from "./medicine.controller.js";

const router = express.Router();

router.post(
    "/",
    authMiddleware,
    roleMiddleware("PATIENT"),
    createMedicine
);

router.get(
    "/",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getMyMedicines
);

router.get(
    "/:id",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getSingleMedicine
);

router.put(
    "/:id",
    authMiddleware,
    roleMiddleware("PATIENT"),
    updateMedicine
);

router.delete(
    "/:id",
    authMiddleware,
    roleMiddleware("PATIENT"),
    deleteMedicine
);

export default router;