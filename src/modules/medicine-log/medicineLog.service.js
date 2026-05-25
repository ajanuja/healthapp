import prisma from "../../config/prisma.js";


// CREATE LOG
export const createMedicineLogService = async (
    userId,
    payload
) => {

    // Check medicine ownership
    const medicine = await prisma.medicines.findFirst({

        where: {
            id: payload.medicine_id,
            patient_id: userId
        }

    });

    if (!medicine) {
        throw new Error("Medicine not found");
    }

    const log = await prisma.medicine_logs.create({

        data: {

            medicine_id: payload.medicine_id,

            patient_id: userId,

            status: payload.status,

            taken_at: new Date(),

            note: payload.note || null

        }

    });

    return log;

};


// GET ALL LOGS
export const getMyMedicineLogsService = async (
    userId
) => {

    const logs = await prisma.medicine_logs.findMany({

        where: {
            patient_id: userId
        },

        orderBy: {
            taken_at: "desc"
        }

    });

    return logs;

};


// GET LOGS BY MEDICINE
export const getMedicineLogsByMedicineService = async (
    userId,
    medicineId
) => {

    const logs = await prisma.medicine_logs.findMany({

        where: {
            medicine_id: medicineId,
            patient_id: userId
        },

        orderBy: {
            taken_at: "desc"
        }

    });

    return logs;

};