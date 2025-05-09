const functions = require("firebase-functions");
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
