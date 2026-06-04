import prisma from "../../config/prisma.js";

export const getPatientVitalsService = async (
    doctorId,
    patientId
) => {

    const relation =
        await prisma.doctor_patients.findFirst({

            where: {
                doctor_id: doctorId,
                patient_id: patientId
            }

        });

    if (!relation) {

        throw new Error(
            "Patient is not assigned to you"
        );

    }

    const vitals =
        await prisma.vitals.findMany({

            where: {
                patient_id: patientId
            },

            orderBy: {
                recorded_at: "asc"
            }

        });

    return vitals;

};