import {
    getPatientVitalsService
} from "./doctorVital.service.js";

export const getPatientVitals = async (
    req,
    res
) => {

    try {

        const result =
            await getPatientVitalsService(

                req.user.id,
                req.params.patientId

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