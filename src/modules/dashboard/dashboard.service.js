import prisma from "../../config/prisma.js";


export const getDashboardService = async (
    userId
) => {

    // PROFILE
    const profile =
        await prisma.patient_profiles.findFirst({

            where: {
                user_id: userId
            }

        });


    // MEDICINES
    const medicines =
        await prisma.medicines.findMany({

            where: {
                patient_id: userId
            },

            orderBy: {
                created_at: "desc"
            }

        });


    // LATEST VITALS
    const latestVitals =
        await prisma.vitals.findMany({

            where: {
                patient_id: userId
            },

            orderBy: {
                recorded_at: "desc"
            },

            take: 5

        });


    // RECENT MEDICINE LOGS
    const recentMedicineLogs =
        await prisma.medicine_logs.findMany({

            where: {
                patient_id: userId
            },

            orderBy: {
                taken_at: "desc"
            },

            take: 10

        });


    // STATS
    const totalMedicines =
        await prisma.medicines.count({

            where: {
                patient_id: userId
            }

        });


    const totalVitals =
        await prisma.vitals.count({

            where: {
                patient_id: userId
            }

        });


    const takenMedicines =
        await prisma.medicine_logs.count({

            where: {
                patient_id: userId,
                status: "TAKEN"
            }

        });


    return {

        profile,

        medicines,

        latestVitals,

        recentMedicineLogs,

        stats: {

            totalMedicines,

            totalVitals,

            takenMedicines

        }

    };

    

};

export const getWeeklySummaryService = async (
    userId
) => {

    // CURRENT DATE
    const now = new Date();


    // 7 DAYS AGO
    const sevenDaysAgo = new Date();

    sevenDaysAgo.setDate(
        now.getDate() - 7
    );


    // MEDICINE LOGS
    const medicineLogs =
        await prisma.medicine_logs.findMany({

            where: {

                patient_id: userId,

                taken_at: {
                    gte: sevenDaysAgo
                }

            }

        });


    // COUNTS
    const totalLogs =
        medicineLogs.length;


    const taken =
        medicineLogs.filter(
            log => log.status === "TAKEN"
        ).length;


    const skipped =
        medicineLogs.filter(
            log => log.status === "SKIPPED"
        ).length;


    // ADHERENCE %
    const adherencePercentage =
        totalLogs > 0

            ? Math.round(
                (taken / totalLogs) * 100
            )

            : 0;


    // LATEST VITALS
    const latestVitals =
        await prisma.vitals.findMany({

            where: {

                patient_id: userId,

                recorded_at: {
                    gte: sevenDaysAgo
                }

            },

            orderBy: {
                recorded_at: "desc"
            },

            take: 10

        });


    // RECENT MEDICINES
    const recentMedicines =
        await prisma.medicines.findMany({

            where: {
                patient_id: userId
            },

            orderBy: {
                created_at: "desc"
            },

            take: 5

        });


    return {

        weekStart:
            sevenDaysAgo,

        weekEnd:
            now,

        medicineStats: {

            totalLogs,

            taken,

            skipped,

            adherencePercentage

        },

        latestVitals,

        recentMedicines

    };

};