import {

    getMyPatientsService,
    getPatientReportService,
    searchPatientService,
    assignPatientService

} from "./doctor.service.js";


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



// GET PATIENT REPORT
export const getPatientReport = async (
    req,
    res
) => {

    try {

        const {

            startDate,
            endDate

        } = req.query;


        const result =
            await getPatientReportService(

                req.params.id,

                startDate,

                endDate

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


// SEARCH PATIENT
export const searchPatient = async (
    req,
    res
) => {

    try {

        const result =
            await searchPatientService(
                req.query.email
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


// ASSIGN PATIENT
export const assignPatient = async (
    req,
    res
) => {

    try {

        const result =
            await assignPatientService(
                req.user.id,
                req.body.patientId
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