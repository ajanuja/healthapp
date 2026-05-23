import express from "express";
import cors from "cors";
import prisma from "./config/prisma.js";
import authRoutes from "./modules/auth/auth.routes.js";
import authMiddleware from "./middleware/auth.middleware.js";
import roleMiddleware from "./middleware/role.middleware.js";
import patientProfileRoutes from "./modules/patient-profile/patientProfile.routes.js";
import medicineRoutes from "./modules/medicine/medicine.routes.js";

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRoutes);

app.get("/", (req, res) => {
  res.send("API Running");
});

app.get("/users", async (req, res) => {
  const users = await prisma.users.findMany();

  res.json(users);
});

app.get("/protected", authMiddleware, (req, res) => {

    res.json({
        success: true,
        message: "Protected route accessed",
        user: req.user
    });

});

//PATIENT ONLY
app.get(
    "/patient-only",
    authMiddleware,
    roleMiddleware("PATIENT"),
    (req, res) => {

        res.json({
            success: true,
            message: "Patient route accessed"
        });

    }
);

//DOCTOR ONLY
app.get(
    "/doctor-only",
    authMiddleware,
    roleMiddleware("DOCTOR"),
    (req, res) => {

        res.json({
            success: true,
            message: "Doctor route accessed"
        });

    }
);

//MULTIPLE ROLES

app.get(
    "/shared-route",
    authMiddleware,
    roleMiddleware("PATIENT", "CAREGIVER"),
    (req, res) => {

        res.json({
            success: true,
            message: "Shared route accessed"
        });

    }
);
// patient profile routes
app.use("/api/patient-profile", patientProfileRoutes);

// medicine routes
app.use(
    "/api/medicines",
    medicineRoutes
);
export default app;