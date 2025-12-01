require("dotenv").config();
const cors = require("cors");
const express = require("express");
const {resumedb, ResumeDetails} = require("./db/db");

const app = express();

app.use(cors());

app.use(express.json());

// Connect to MongoDB
resumedb();

app.use("/api/resume-generator", require("./routes/route"))


const port = process.env.PORT || 3000;
app.listen(port, () =>
  console.log(`Server is listening at http://localhost:${port}`)
);


