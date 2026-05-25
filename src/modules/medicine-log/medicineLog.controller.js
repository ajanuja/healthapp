import {

    createMedicineLogService,
    getMyMedicineLogsService,
    getMedicineLogsByMedicineService

} from "./medicineLog.service.js";


// CREATE LOG
export const createMedicineLog = async (
    req,
    res
) => {

    try {

        const result = await createMedicineLogService(
            req.user.id,
            req.body
        );

        res.status(201).json({
            success: true,
            data: result
        });

    } catch (error) {

        res.status(400).json({
            success: false,
            message: error.message
        });

    }

};


// GET ALL LOGS
export const getMyMedicineLogs = async (
    req,
    res
) => {

    try {

        const result =
            await getMyMedicineLogsService(
                req.user.id
            );

        res.json({
            success: true,
            data: result
        });

    } catch (error) {

        res.status(400).json({
            success: false,
            message: error.message
        });

    }

};


// GET LOGS FOR SPECIFIC MEDICINE
export const getMedicineLogsByMedicine = async (
    req,
    res
) => {

    try {

        const result =
            await getMedicineLogsByMedicineService(

                req.user.id,
                req.params.medicineId

            );

        res.json({
            success: true,
            data: result
        });

    } catch (error) {

        res.status(400).json({
            success: false,
            message: error.message
        });

    }

};