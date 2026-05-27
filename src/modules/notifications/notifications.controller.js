import {

    getMyNotificationsService,
    markNotificationAsReadService

} from "./notifications.service.js";


// GET NOTIFICATIONS
export const getMyNotifications = async (
    req,
    res
) => {

    try {

        const result =
            await getMyNotificationsService(
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


// MARK AS READ
export const markNotificationAsRead = async (
    req,
    res
) => {

    try {

        const result =
            await markNotificationAsReadService(

                req.user.id,

                req.params.id

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