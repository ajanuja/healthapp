import prisma from "../../config/prisma.js";


// GET MY PATIENTS
export const getMyPatientsService = async (
    caregiverId
) => {

    const patients =
        await prisma.caregiver_patients.findMany({

            where: {
                caregiver_id: caregiverId
            },

            include: {

                users_caregiver_patients_patient_idTousers: {

                    select: {

                        id: true,
                        full_name: true,
                        age: true,
                        gender: true

                    }

                }

            }

        });

    return patients;

};


// GET PATIENT ALERTS
export const getPatientAlertsService = async (
    patientId
) => {

    const alerts =
        await prisma.notifications.findMany({

            where: {
                user_id: patientId
            },

            orderBy: {
                created_at: "desc"
            }

        });

    return alerts;

};



// GET PATIENT VITALS
export const getPatientVitalsService = async (
    patientId
) => {

    const vitals =
        await prisma.vitals.findMany({

            where: {
                patient_id: patientId
            },

            orderBy: {
                recorded_at: "desc"
            }

        });

    return vitals;

};