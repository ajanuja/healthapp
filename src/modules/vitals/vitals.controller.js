import {

    createVitalService,
    getMyVitalsService,
    getSingleVitalService,
    updateVitalService,
    deleteVitalService

} from "./vitals.service.js";


// CREATE
export const createVital = async (
    req,
    res
) => {

    try {

        const result =
            await createVitalService(
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


// GET ALL
export const getMyVitals = async (
    req,
    res
) => {

    try {

        const result =
            await getMyVitalsService(
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


// GET SINGLE
export const getSingleVital = async (
    req,
    res
) => {

    try {

        const result =
            await getSingleVitalService(
                req.user.id,
                req.params.id
            );

        res.json({
            success: true,
            data: result
        });

    } catch (error) {

        res.status(404).json({
            success: false,
            message: error.message
        });

    }

};


// UPDATE
export const updateVital = async (
    req,
    res
) => {

    try {

        const result =
            await updateVitalService(
                req.user.id,
                req.params.id,
                req.body
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


// DELETE
export const deleteVital = async (
    req,
    res
) => {

    try {

        await deleteVitalService(
            req.user.id,
            req.params.id
        );

        res.json({
            success: true,
            message: "Vital deleted successfully"
        });

    } catch (error) {

        res.status(400).json({
            success: false,
            message: error.message
        });

    }

};