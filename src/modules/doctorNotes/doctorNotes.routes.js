import express from "express";

import authMiddleware from "../../middleware/auth.middleware.js";

import roleMiddleware from "../../middleware/role.middleware.js";


import {

    addDoctorNote,
    getPatientNotes,
    updateDoctorNote,
    deleteDoctorNote,
      getMyDoctorNotes

} from "./doctorNotes.controller.js";

const router = express.Router();


// ADD
router.post(

    "/patients/:patientId/notes",

    authMiddleware,

    roleMiddleware("DOCTOR"),

    addDoctorNote

);


// LIST
router.get(

    "/patients/:patientId/notes",

    authMiddleware,

    roleMiddleware("DOCTOR"),

    getPatientNotes

);


// UPDATE
router.put(

    "/notes/:noteId",

    authMiddleware,

    roleMiddleware("DOCTOR"),

    updateDoctorNote

);


// DELETE
router.delete(

    "/notes/:noteId",

    authMiddleware,

    roleMiddleware("DOCTOR"),

    deleteDoctorNote

);

//      GET MY NOTES

router.get(
    "/my-notes",
    authMiddleware,
    roleMiddleware("PATIENT"),
    getMyDoctorNotes
);
export default router;