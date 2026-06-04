import {

    createAppointmentService,
    getDoctorAppointmentsService,
    getPatientAppointmentsService

} from "./appointments.service.js";


// CREATE
export const createAppointment = async (
    req,
    res
) => {

    try {

        const result =
            await createAppointmentService(

                req.user.id,

                req.params.patientId,

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


// DOCTOR APPOINTMENTS
export const getDoctorAppointments = async (
    req,
    res
) => {

    try {

        const result =
            await getDoctorAppointmentsService(
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


// PATIENT APPOINTMENTS
export const getPatientAppointments = async (
    req,
    res
) => {

    try {

        const result =
            await getPatientAppointmentsService(
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