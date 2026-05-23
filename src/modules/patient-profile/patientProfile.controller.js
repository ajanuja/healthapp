import {
    createProfileService,
    getMyProfileService,
    updateProfileService
} from "./patientProfile.service.js";

export const createPatientProfile = async (req, res) => {

    try {

        const result = await createProfileService(
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

export const getMyProfile = async (req, res) => {

    try {

        const result = await getMyProfileService(req.user.id);

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

export const updatePatientProfile = async (req, res) => {

    try {

        const result = await updateProfileService(
            req.user.id,
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