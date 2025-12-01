require("dotenv").config();
const router = require("express").Router();
const Groq = require("groq-sdk");

const { resumedb, ResumeDetails } = require("../db/db")

const groq = new Groq({ apiKey: process.env.GROQ_API })

// GET ALL RESUMES
router.get("/all-resume", async (req, res) => {
  try {
    const allResumes = await ResumeDetails.find();
    res.json({ "All Saved Resumes": allResumes });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
})

// POST 

router.post("/build-ai-resume", async (req, res) => {
  try {
    const userData = req.body;

    // AI PROMPT
    const prompt = `
Generate a clean, professional resume in well-structured text format.
Use these sections: Summary, Skills, Experience, Projects, Education.
Here is the user data: ${JSON.stringify(userData, null, 2)}
    `;

    // GROQ LLM CALL
    const completion = await groq.chat.completions.create({
      model: "llama-3.3-70b-versatile",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.5,
    });

    const aiResumeText = completion.choices[0]?.message?.content;

    // SAVE IN DB
    const newResume = new ResumeDetails({
      ...userData, 
      rawDetails: userData,
      aiResume: aiResumeText,
    });

    await newResume.save();

    res.status(200).json({
      message: "AI Resume Created Successfully!",
      resume: newResume,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
})

//UPDATE

router.put("/update-resume/:id", async (req, res) => {
  try {
    let resumeId = req.params.id;
    const userData = req.body;

    // AI PROMPT - Regenerate AI resume with updated data
    const prompt = `
Generate a clean, professional resume in well-structured text format.
Use these sections: Summary, Skills, Experience, Projects, Education.
Here is the user data: ${JSON.stringify(userData, null, 2)}
    `;

    // GROQ LLM CALL
    const completion = await groq.chat.completions.create({
      model: "llama-3.3-70b-versatile",
      messages: [{ role: "user", content: prompt }],
      temperature: 0.5,
    });

    const aiResumeText = completion.choices[0]?.message?.content;

    // Update with new AI resume
    const updateResume = await ResumeDetails.findByIdAndUpdate(
      resumeId,
      {
        ...userData,
        rawDetails: userData,
        aiResume: aiResumeText,
      },
      { new: true }
    );

    if (!updateResume) {
      return res.status(404).json({ message: "Resume not found!" });
    }

    res.status(200).json({ message: "Resume Updated Successfully!", updatedResume: updateResume })
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
})

// DELETE

router.delete("/delete-resume/:id", async (req, res) => {
  try {
    let resumeId = req.params.id;
    const deleteResume = await ResumeDetails.findByIdAndDelete(resumeId);

    if (!deleteResume) {
      return res.status(404).json({
        message: "Resume not found!"
      });
    }
    res.status(200).json({ message: "Resume Deleted Successfully!", deletedResume: deleteResume })
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
})

module.exports = router;