import prisma from "../../config/prisma.js";


// CREATE
export const createVitalService = async (
    userId,
    payload
) => {

    const vital = await prisma.vitals.create({

        data: {

            patient_id: userId,

            vital_type: payload.vital_type,

            value: payload.value,

            note: payload.note || null,

            recorded_at: new Date()

        }

    });

    return vital;

};


// GET ALL
export const getMyVitalsService = async (
    userId
) => {

    const vitals = await prisma.vitals.findMany({

        where: {
            patient_id: userId
        },

        orderBy: {
            recorded_at: "desc"
        }

    });

    return vitals;

};


// GET SINGLE
export const getSingleVitalService = async (
    userId,
    vitalId
) => {

    const vital = await prisma.vitals.findFirst({

        where: {
            id: vitalId,
            patient_id: userId
        }

    });

    if (!vital) {
        throw new Error("Vital not found");
    }

    return vital;

};


// UPDATE
export const updateVitalService = async (
    userId,
    vitalId,
    payload
) => {

    const existingVital =
        await prisma.vitals.findFirst({

            where: {
                id: vitalId,
                patient_id: userId
            }

        });

    if (!existingVital) {
        throw new Error("Vital not found");
    }

    const updatedVital =
        await prisma.vitals.update({

            where: {
                id: vitalId
            },

            data: payload

        });

    return updatedVital;

};


// DELETE
export const deleteVitalService = async (
    userId,
    vitalId
) => {

    const existingVital =
        await prisma.vitals.findFirst({

            where: {
                id: vitalId,
                patient_id: userId
            }

        });

    if (!existingVital) {
        throw new Error("Vital not found");
    }

    await prisma.vitals.delete({

        where: {
            id: vitalId
        }

    });

    return true;

};