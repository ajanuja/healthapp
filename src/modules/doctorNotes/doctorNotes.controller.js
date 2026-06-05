import {

    addDoctorNoteService,
    getPatientNotesService,
    updateDoctorNoteService,
    deleteDoctorNoteService,
     getMyDoctorNotesService

} from "./doctorNotes.service.js";


// ADD
export const addDoctorNote = async (
    req,
    res
) => {

    try {

        const result =
            await addDoctorNoteService(

                req.user.id,

                req.params.patientId,

                req.body

            );

        res.status(201).json({

            success: true,
            data: result

        });

    } catch (error) {

        res.status(400).json({

            success: false,
            message: error.message

        });

    }

};


// LIST
export const getPatientNotes = async (
    req,
    res
) => {

    try {

        const result =
            await getPatientNotesService(
                req.params.patientId
            );

        res.json({

            success: true,
            data: result

        });

    } catch (error) {

        res.status(400).json({

            success: false,
            message: error.message

        });

    }

};


// UPDATE
export const updateDoctorNote = async (
    req,
    res
) => {

    try {

        const result =
            await updateDoctorNoteService(

                req.params.noteId,

                req.body

            );

        res.json({

            success: true,
            data: result

        });

    } catch (error) {

        res.status(400).json({

            success: false,
            message: error.message

        });

    }

};


// DELETE
export const deleteDoctorNote = async (
    req,
    res
) => {

    try {

        await deleteDoctorNoteService(
            req.params.noteId
        );

        res.json({

            success: true,
            message: "Note deleted"

        });

    } catch (error) {

        res.status(400).json({

            success: false,
            message: error.message

        });

    }

};


export const getMyDoctorNotes = async (
    req,
    res
) => {

    try {

        const result =
            await getMyDoctorNotesService(
                req.user.id
            );

        res.json({

            success: true,
            data: result

        });

    } catch (error) {

        res.status(400).json({

            success: false,
            message: error.message

        });

    }

};