const functions = require("firebase-functions");
const admin = require("firebase-admin");
const cors = require("cors")({origin: true});

// Initializing Firebase Admin SDK
admin.initializeApp();

// Function to validate email format
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// HTTP function to update user profile (email, username, and optional profile image)
exports.updateUserProfile = functions.https.onRequest((req, res) => {
    // Enabling CORS for cross-origin requests
    cors(req, res, async () => {
        // Ensuring the request method is POST
        if (req.method !== 'POST') {
            return res.status(405).send({ error: 'Method Not Allowed. Use POST.' });
        }

        // Extracting data from request body
        const { idToken, newEmail, username, profileImageUrl } = req.body;

        // Validating input data
        if (!idToken || !newEmail || !username) {
            return res.status(400).send({ error: 'Missing required fields: idToken, newEmail, username' });
        }

        if (!isValidEmail(newEmail)) {
            return res.status(400).send({ error: 'Invalid email format' });
        }

        try {
            // Verifying the Firebase ID token
            const decodedToken = await admin.auth().verifyIdToken(idToken);
            const uid = decodedToken.uid;

            // Checking if the new email is already in use
            try {
                await admin.auth().getUserByEmail(newEmail);
                return res.status(400).send({ error: 'Email already in use' });
            } catch (error) {
                if (error.code !== 'auth/user-not-found') {
                    throw error; // Rethrow unexpected errors
                }
                // Email is not in use, proceed
            }

            // Updating Firebase Authentication email
            await admin.auth().updateUser(uid, {
                email: newEmail,
                displayName: username
            });

            // Updating Firestore user document
            const userDocRef = admin.firestore().collection('users').doc(uid);
            const updateData = {
                userEmail: newEmail,
                username: username
            };
            if (profileImageUrl) {
                updateData.userImage = profileImageUrl;
            }
            await userDocRef.update(updateData);

            // Sending success response
            return res.status(200).send({ message: 'Profile updated successfully' });
        } catch (error) {
            console.error('Error updating profile:', error);
            return res.status(500).send({ error: 'Failed to update profile', details: error.message });
        }
    });
});