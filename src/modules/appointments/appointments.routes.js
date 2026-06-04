import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";

import roleMiddleware from "../../middleware/role.middleware.js";

import {

    createAppointment,
    getDoctorAppointments,
    getPatientAppointments

} from "./appointments.controller.js";

const router = express.Router();


// DOCTOR CREATE APPOINTMENT
router.post(
    "/doctor/:patientId",
    authMiddleware,
    roleMiddleware("DOCTOR"),
    createAppointment
);


// DOCTOR VIEW APPOINTMENTS
router.get(
    "/doctor",
    authMiddleware,
    roleMiddleware("DOCTOR"),
    getDoctorAppointments
);


// PATIENT VIEW APPOINTMENTS
router.get(
    "/patient",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getPatientAppointments
);

export default router;