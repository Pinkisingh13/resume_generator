require('dotenv').config();
const mongoose = require("mongoose");

const resumedb = async () => {
  await mongoose.connect( process.env.MONGO_URI)
    .then(() => console.log("Connected to MongoDB..."))
    .catch((err) => console.error("Could not connect to MongoDB...", err))
};


const ResumeSchema = new mongoose.Schema({
  fullname: {
    type: String, required: [true, "Name is required"], minlength: [3, '  Name must be at least 3 characters'],
    trim: true
  },
  mobileNumber: { type: String, required: true },


  email: {
    type: String, required: [true, "Mobile number is required"], validate: {
      validator: (v) => /\S+@\S+\.\S+/.test(v),
      message: "Please enter a valid email"
    }

  },
  about: { type: String, maxlength: [2000, 'About must be less than 2000 characters'] },

  location: { type: String, required: true },

  workexperience: [
    {
      title: String,
      company: String,
      start: String,
      end: String,
      details: [String]
    }
  ],


  education: [
    {
      degree: String,
      institute: String,
      startYear: String,
      endYear: String,
      percentage: String
    }
  ],

  projects: [
    {
      name: String,
      tech: [String],
      description: String,
      link: String
    }
  ],
  aiResume: { type: String, default: "" },


  skills: { type: [String], required: [true, "skills is required"] },

rawDetails: { type: Object, default: {} },


}, { timestamps: true })

const ResumeDetails = mongoose.model("Resume", ResumeSchema);

module.exports = {
  resumedb,
  ResumeDetails
}