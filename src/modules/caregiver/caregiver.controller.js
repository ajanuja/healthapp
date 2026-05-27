import {

    getMyPatientsService,
    getPatientAlertsService,
    getPatientVitalsService

} from "./caregiver.service.js";


// GET MY PATIENTS
export const getMyPatients = async (
    req,
    res
) => {

    try {

        const result =
            await getMyPatientsService(
                req.user.id
            );

        res.json({

            success: true,

            data: result

        });

    } catch (error) {

        res.status(500).json({

            success: false,

            message: error.message

        });

    }

};



// GET ALERTS
export const getPatientAlerts = async (
    req,
    res
) => {

    try {

        const result =
            await getPatientAlertsService(
                req.params.id
            );

        res.json({

            success: true,

            data: result

        });

    } catch (error) {

        res.status(500).json({

            success: false,

            message: error.message

        });

    }

};



// GET VITALS
export const getPatientVitals = async (
    req,
    res
) => {

    try {

        const result =
            await getPatientVitalsService(
                req.params.id
            );

        res.json({

            success: true,

            data: result

        });

    } catch (error) {

        res.status(500).json({

            success: false,

            message: error.message

        });

    }

};