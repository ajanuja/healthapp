import express from "express";
import cors from "cors";
import prisma from "./config/prisma.js";
import authRoutes from "./modules/auth/auth.routes.js";
import authMiddleware from "./middleware/auth.middleware.js";
import roleMiddleware from "./middleware/role.middleware.js";
import patientProfileRoutes from "./modules/patient-profile/patientProfile.routes.js";
import medicineRoutes from "./modules/medicine/medicine.routes.js";
import medicineLogRoutes from "./modules/medicine-log/medicineLog.routes.js";
import vitalsRoutes from "./modules/vitals/vitals.routes.js";
import dashboardRoutes from "./modules/dashboard/dashboard.routes.js";
import "./cron/medicineReminder.cron.js";
import notificationsRoutes from "./modules/notifications/notifications.routes.js";
import doctorRoutes from "./modules/doctor/doctor.routes.js";
import caregiverRoutes from "./modules/caregiver/caregiver.routes.js";
import doctorMedicineRoutes from "./modules/doctor/doctorMedicine.routes.js";
import doctorVitalRoutes from "./modules/doctor/doctorVital.routes.js";
import appointmentsRoutes from "./modules/appointments/appointments.routes.js";
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

// medicine log routes
app.use(
    "/api/medicine-logs",
    medicineLogRoutes
);
// vitals routes
app.use("/api/vitals", vitalsRoutes);
// dashboard routes
app.use("/api/dashboard", dashboardRoutes);

// notifications routes

app.use(
    "/api/notifications",
    notificationsRoutes
);

// doctor routes
app.use(
    "/api/doctor",
    doctorRoutes
);

// CAREGIVER ALERTS
app.use(
    "/api/caregiver",
    caregiverRoutes
);

app.use(
    "/api/doctor",
    doctorMedicineRoutes
);
app.use("/doctor", doctorVitalRoutes);


app.use(
    "/api/appointments",
    appointmentsRoutes
);
export default app;