import cron from "node-cron";

import prisma from "../config/prisma.js";


// RUN EVERY MINUTE
cron.schedule("* * * * *", async () => {

    console.log(
        "Running medicine reminder check..."
    );

    try {

        // CURRENT TIME
        const now = new Date();

        const currentHours =
            now.getHours()
                .toString()
                .padStart(2, "0");

        const currentMinutes =
            now.getMinutes()
                .toString()
                .padStart(2, "0");

        const currentTime =
            `${currentHours}:${currentMinutes}`;


        console.log(
            "Current Time:",
            currentTime
        );


        // GET ALL MEDICINES
        const medicines =
            await prisma.medicines.findMany();


        for (const medicine of medicines) {

            // DB TIME
            const reminderTime =
    medicine.reminder_time
        .toISOString()
        .slice(11, 16);


            // MATCH TIME
            if (reminderTime === currentTime) {

                console.log(
                    `Reminder for ${medicine.medicine_name}`
                );


                // CHECK IF ALREADY TAKEN
                const existingLog =
                    await prisma.medicine_logs.findFirst({

                        where: {

                            medicine_id: medicine.id,

                            patient_id:
                                medicine.patient_id,

                            taken_at: {
                                gte: new Date(
                                    new Date().setHours(
                                        0, 0, 0, 0
                                    )
                                )
                            }

                        }

                    });


                // IF NOT TAKEN
                if (!existingLog) {

                    await prisma.medicine_logs.create({

                        data: {

                            medicine_id:
                                medicine.id,

                            patient_id:
                                medicine.patient_id,

                            status: "MISSED",

                            taken_at: new Date(),

                            note:
                                "Automatically marked missed"

                        }

                    });

                    await prisma.notifications.create({

    data: {

        user_id: medicine.patient_id,

        title: "Medicine Missed",

        message:
            `You missed your ${medicine.medicine_name} dose.`

    }

});


                    console.log(
                        `Marked MISSED for ${medicine.medicine_name}`
                    );

                }

            }

        }

    } catch (error) {

        console.log(
            "CRON ERROR:",
            error.message
        );

    }

});