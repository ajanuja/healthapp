import prisma from "../../config/prisma.js";

export const addMedicineForPatientService = async (
    doctorId,
    patientId,
    payload
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

    const medicine =
    await prisma.medicines.create({

        data: {

            patient_id: patientId,

            medicine_name: payload.medicine_name,

            dosage: payload.dosage,

            frequency: payload.frequency,

            reminder_time: new Date(
                `1970-01-01T${payload.reminder_time}Z`
            ),

            instructions: payload.instructions,

            start_date: new Date(payload.start_date),

            end_date: new Date(payload.end_date)

        }

    });

    return medicine;
};