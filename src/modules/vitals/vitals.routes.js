import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";
import roleMiddleware from "../../middleware/role.middleware.js";

import {

    createVital,
    getMyVitals,
    getSingleVital,
    updateVital,
    deleteVital

} from "./vitals.controller.js";

const router = express.Router();


// CREATE
router.post(
    "/",
    authMiddleware,
    roleMiddleware("PATIENT"),
    createVital
);


// GET ALL
router.get(
    "/",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getMyVitals
);


// GET SINGLE
router.get(
    "/:id",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getSingleVital
);


// UPDATE
router.put(
    "/:id",
    authMiddleware,
    roleMiddleware("PATIENT"),
    updateVital
);


// DELETE
router.delete(
    "/:id",
    authMiddleware,
    roleMiddleware("PATIENT"),
    deleteVital
);

export default router;