import prisma from "../../config/prisma.js";


// ADD NOTE
export const addDoctorNoteService = async (
    doctorId,
    patientId,
    payload
) => {

    const note =
        await prisma.doctor_notes.create({

            data: {

                doctor_id: doctorId,

                patient_id: patientId,

                note: payload.note,

                follow_up_date:
                    payload.follow_up_date
                        ? new Date(payload.follow_up_date)
                        : null

            }

        });

    return note;

};


// GET ALL NOTES
export const getPatientNotesService = async (
    patientId
) => {

    return await prisma.doctor_notes.findMany({

        where: {
            patient_id: patientId
        },

        orderBy: {
            created_at: "desc"
        }

    });

};


// UPDATE NOTE
export const updateDoctorNoteService = async (
    noteId,
    payload
) => {

    const existing =
        await prisma.doctor_notes.findUnique({

            where: {
                id: noteId
            }

        });

    if (!existing) {
        throw new Error("Note not found");
    }

    return await prisma.doctor_notes.update({

        where: {
            id: noteId
        },

        data: {

            note: payload.note,

            follow_up_date:
                payload.follow_up_date
                    ? new Date(payload.follow_up_date)
                    : null

        }

    });

};


// DELETE NOTE
export const deleteDoctorNoteService = async (
    noteId
) => {

    await prisma.doctor_notes.delete({

        where: {
            id: noteId
        }

    });

    return true;

};

export const getMyDoctorNotesService = async (
    patientId
) => {

    return await prisma.doctor_notes.findMany({

        where: {
            patient_id: patientId
        },

        include: {

            users_doctor_notes_doctor_idTousers: {

                select: {
                    full_name: true
                }

            }

        },

        orderBy: {
            created_at: "desc"
        }

    });

};