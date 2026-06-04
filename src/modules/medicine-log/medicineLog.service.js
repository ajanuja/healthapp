import prisma from "../../config/prisma.js";


// CREATE LOG

export const createMedicineLogService = async (
    userId,
    payload
) => {

    // Check ownership
    const medicine = await prisma.medicines.findFirst({
        where: {
            id: payload.medicine_id,
            patient_id: userId
        }
    });

    if (!medicine) {
        throw new Error("Medicine not found");
    }

    const todayStart = new Date();

    todayStart.setHours(
        0,
        0,
        0,
        0
    );

    const todayEnd = new Date();

    todayEnd.setHours(
        23,
        59,
        59,
        999
    );

    // Check if already marked today
    const existingLog =
        await prisma.medicine_logs.findFirst({

            where: {
                medicine_id: payload.medicine_id,

                patient_id: userId,

                taken_at: {
                    gte: todayStart,
                    lte: todayEnd
                }
            }

        });

    if (existingLog) {
        throw new Error(
            "Medicine already marked today"
        );
    }

    const log =
        await prisma.medicine_logs.create({

            data: {

                medicine_id:
                    payload.medicine_id,

                patient_id: userId,

                status: payload.status,

                taken_at: new Date(),

                note:
                    payload.note || null

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