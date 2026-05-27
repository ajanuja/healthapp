import prisma from "../../config/prisma.js";


// GET ALL ASSIGNED PATIENTS
export const getMyPatientsService = async (
    doctorId
) => {

    const patients =
        await prisma.doctor_patients.findMany({

            where: {
                doctor_id: doctorId
            },

            include: {

                users_doctor_patients_patient_idTousers: {

                    select: {

                        id: true,
                        full_name: true,
                        email: true,
                        age: true,
                        gender: true

                    }

                }

            }

        });

    return patients;

};



// SINGLE PATIENT REPORT
export const getPatientReportService = async (
    patientId,
    startDate,
    endDate
) => {

    const medicines =
        await prisma.medicines.findMany({

            where: {
                patient_id: patientId
            }

        });


    const medicineLogs =
        await prisma.medicine_logs.findMany({

            where: {

                patient_id: patientId,

                taken_at: {

                    gte: new Date(startDate),

                    lte: new Date(endDate)

                }

            }

        });


    const vitals =
        await prisma.vitals.findMany({

            where: {

                patient_id: patientId,

                recorded_at: {

                    gte: new Date(startDate),

                    lte: new Date(endDate)

                }

            }

        });


    return {

        medicines,
        medicineLogs,
        vitals

    };

};