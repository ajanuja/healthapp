import prisma from "../../config/prisma.js";


// GET MY NOTIFICATIONS
export const getMyNotificationsService = async (
    userId
) => {

    const notifications =
        await prisma.notifications.findMany({

            where: {
                user_id: userId
            },

            orderBy: {
                created_at: "desc"
            }

        });

    return notifications;

};


// MARK AS READ
export const markNotificationAsReadService = async (
    userId,
    notificationId
) => {

    // CHECK OWNERSHIP
    const notification =
        await prisma.notifications.findFirst({

            where: {

                id: notificationId,

                user_id: userId

            }

        });


    if (!notification) {

        throw new Error(
            "Notification not found"
        );

    }


    const updatedNotification =
        await prisma.notifications.update({

            where: {
                id: notificationId
            },

            data: {
                is_read: true
            }

        });


    return updatedNotification;

};