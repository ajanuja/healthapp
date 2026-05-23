import prisma from "../../config/prisma.js";


// CREATE MEDICINE
export const createMedicineService = async (userId, payload) => {

    const medicine = await prisma.medicines.create({

       data: {
    patient_id: userId,

    medicine_name: payload.medicine_name,

    dosage: payload.dosage,

    frequency: payload.frequency,

    reminder_time: new Date(
        `1970-01-01T${payload.reminder_time}`
    ),

    instructions: payload.instructions,

    start_date: new Date(payload.start_date),

    end_date: payload.end_date
        ? new Date(payload.end_date)
        : null
}
    });

    return medicine;

};


// GET ALL MEDICINES
export const getMyMedicinesService = async (userId) => {

    const medicines = await prisma.medicines.findMany({

        where: {
            patient_id: userId
        },

        orderBy: {
            created_at: "desc"
        }

    });

    return medicines;

};


// GET SINGLE MEDICINE
export const getSingleMedicineService = async (
    userId,
    medicineId
) => {

    const medicine = await prisma.medicines.findFirst({

        where: {
            id: medicineId,
            patient_id: userId
        }

    });

    if (!medicine) {
        throw new Error("Medicine not found");
    }

    return medicine;

};


// UPDATE MEDICINE
export const updateMedicineService = async (
    userId,
    medicineId,
    payload
) => {

    // Check ownership
    const existingMedicine = await prisma.medicines.findFirst({

        where: {
            id: medicineId,
            patient_id: userId
        }

    });

    if (!existingMedicine) {
        throw new Error("Medicine not found");
    }

    const updatedMedicine = await prisma.medicines.update({

        where: {
            id: medicineId
        },

        data: payload

    });

    return updatedMedicine;

};


// DELETE MEDICINE
export const deleteMedicineService = async (
    userId,
    medicineId
) => {

    const existingMedicine = await prisma.medicines.findFirst({

        where: {
            id: medicineId,
            patient_id: userId
        }

    });

    if (!existingMedicine) {
        throw new Error("Medicine not found");
    }

    await prisma.medicines.delete({

        where: {
            id: medicineId
        }

    });

    return true;

};