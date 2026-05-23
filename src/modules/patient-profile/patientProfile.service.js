import prisma from "../../config/prisma.js";

export const createProfileService = async (userId, payload) => {

    const profileExists = await prisma.patient_profiles.findUnique({
        where: {
            user_id: userId
        }
    });

    if (profileExists) {
        throw new Error("Profile already exists");
    }

    const profile = await prisma.patient_profiles.create({
        data: {
            user_id: userId,
            ...payload
        }
    });

    return profile;

};

export const getMyProfileService = async (userId) => {

    const profile = await prisma.patient_profiles.findUnique({
        where: {
            user_id: userId
        }
    });

    return profile;

};

export const updateProfileService = async (userId, payload) => {

    const updatedProfile = await prisma.patient_profiles.update({
        where: {
            user_id: userId
        },
        data: payload
    });

    return updatedProfile;

};