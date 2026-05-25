import {
    getDashboardService
} from "./dashboard.service.js";

import {
    getWeeklySummaryService
} from "./dashboard.service.js";

export const getWeeklySummary = async (
    req,
    res
) => {

    try {

        const result =
            await getWeeklySummaryService(
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
export const getDashboard = async (
    req,
    res
) => {

    try {

        const result =
            await getDashboardService(
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