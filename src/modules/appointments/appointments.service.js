import prisma from "../../config/prisma.js";


// CREATE APPOINTMENT
export const createAppointmentService = async (
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

    const appointment =
        await prisma.appointments.create({

            data: {

                doctor_id: doctorId,

                patient_id: patientId,

                appointment_date:
                    new Date(payload.appointment_date),

                appointment_time:
                    new Date(payload.appointment_time),

                notes: payload.notes,

                status: "SCHEDULED"

            }

        });

    return appointment;

};


// DOCTOR APPOINTMENTS
export const getDoctorAppointmentsService = async (
    doctorId
) => {

    return await prisma.appointments.findMany({

        where: {
            doctor_id: doctorId
        },

        include: {

            users_appointments_patient_idTousers: {

                select: {

                    id: true,
                    full_name: true,
                    email: true

                }

            }

        },

        orderBy: {
            appointment_date: "asc"
        }

    });

};


// PATIENT APPOINTMENTS
export const getPatientAppointmentsService = async (
    patientId
) => {

    return await prisma.appointments.findMany({

        where: {
            patient_id: patientId
        },

        include: {

            users_appointments_doctor_idTousers: {

                select: {

                    id: true,
                    full_name: true,
                    email: true

                }

            }

        },

        orderBy: {
            appointment_date: "asc"
        }

    });

};