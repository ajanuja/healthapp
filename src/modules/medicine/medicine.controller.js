import {

    createMedicineService,
    getMyMedicinesService,
    getSingleMedicineService,
    updateMedicineService,
    deleteMedicineService

} from "./medicine.service.js";


// CREATE
export const createMedicine = async (req, res) => {

    try {

        const result = await createMedicineService(
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
export const getMyMedicines = async (req, res) => {

    try {

        const result = await getMyMedicinesService(
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
export const getSingleMedicine = async (req, res) => {

    try {

        const result = await getSingleMedicineService(
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
export const updateMedicine = async (req, res) => {

    try {

        const result = await updateMedicineService(
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
export const deleteMedicine = async (req, res) => {

    try {

        await deleteMedicineService(
            req.user.id,
            req.params.id
        );

        res.json({
            success: true,
            message: "Medicine deleted successfully"
        });

    } catch (error) {

        res.status(400).json({
            success: false,
            message: error.message
        });

    }

};