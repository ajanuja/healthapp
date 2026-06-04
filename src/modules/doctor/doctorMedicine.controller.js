import {
    addMedicineForPatientService
} from "./doctorMedicine.service.js";

export const addMedicineForPatient = async (
    req,
    res
) => {

    try {

        const result =
            await addMedicineForPatientService(

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