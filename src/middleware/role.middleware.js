const roleMiddleware = (...allowedRoles) => {

    return (req, res, next) => {

        try {

            const userRole = req.user.role;

            // Check role access
            if (!allowedRoles.includes(userRole)) {

                return res.status(403).json({
                    success: false,
                    message: "Access denied"
                });

            }

            next();

        } catch (error) {

            return res.status(500).json({
                success: false,
                message: "Role middleware error"
            });

        }

    };

};

export default roleMiddleware;