const functions = require("firebase-functions");
const admin = require("firebase-admin");
const axios = require("axios");
const cors = require("cors")({origin: true});


exports.googlePlacesProxy = functions.https.onRequest((req, res) => {
  cors(req, res, async () => {
    const {input} = req.query;
    const apiKey = "AIzaSyDJjiynZugIjtXiZI4AIMU9srY1AkSmtto";

    try {
      const response = await axios.get(
          `https://maps.googleapis.com/maps/api/place/autocomplete/json`,
          {
            params: {
              input,
              key: apiKey,
            },
          },
      );
      res.status(200).send(response.data);
    } catch (error) {
      res.status(500).send(error.toString());
    }
  });
});
try {
  admin.initializeApp();
  console.log("Admin SDK initialized successfully");
} catch (e) {
  console.error("Admin SDK initialization failed:", e.message);
  throw e;
}

exports.updateUserEmail = functions.https.onCall(async (data, context) => {
  try {
    // Avoid JSON.stringify() to prevent circular structure error
    console.log("Received data keys:", Object.keys(data));

    const uid = data.uid || (data.data && data.data.uid);
    const newEmail = data.newEmail || (data.data && data.data.newEmail);

    if (!uid || !newEmail) {
      console.error(`Validation failed: uid=${uid}, newEmail=${newEmail}`);
      throw new functions.https.HttpsError(
          "invalid-argument",
          "Missing uid or newEmail",
      );
    }

    const normalizedEmail = newEmail.trim().toLowerCase();
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(normalizedEmail)) {
      console.error("Invalid email format:", normalizedEmail);
      throw new functions.https.HttpsError(
          "invalid-argument",
          "Invalid email format",
      );
    }

    // Check if user exists
    try {
      await admin.auth().getUser(uid);
      console.log("User found:", uid);
    } catch (error) {
      console.error("User lookup failed:", error.message);
      throw new functions.https.HttpsError("not-found",
          "User not found");
    }

    // Check if email is already in use
    try {
      const userByEmail = await admin.auth().getUserByEmail(normalizedEmail);
      if (userByEmail.uid !== uid) {
        console.error("Email already in use by another user:",
            normalizedEmail);
        throw new functions.https.HttpsError("already-exists",
            "Email already in use");
      }
    } catch (error) {
      if (error.code !== "auth/user-not-found") {
        console.error("Email lookup failed:", error.message);
        throw new functions.https.HttpsError("internal",
            `Email check failed: ${error.message}`);
      }
    }

    // Update email
    await admin.auth().updateUser(uid, {email: normalizedEmail});
    console.log(`Successfully updated email for UID:
       ${uid} to ${normalizedEmail}`);
    return {success: true};
  } catch (error) {
    console.error(`Function error: code=${error.code},
       message=${error.message}`);

    if (error.code === "auth/email-already-exists") {
      throw new functions.https.HttpsError("already-exists",
          "Email already in use");
    } else if (error.code === "auth/invalid-email") {
      throw new functions.https.HttpsError("invalid-argument",
          "Invalid email format");
    } else if (error.code === "auth/user-not-found") {
      throw new functions.https.HttpsError("not-found",
          "User not found");
    } else {
      throw new functions.https.HttpsError("internal",
          `Failed to update email: ${error.message}`);
    }
  }
});
