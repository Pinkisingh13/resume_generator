# AI Resume Generator(Android, Ios & Web)

A simple app where you can create your resume and AI will write a professional summary for you. I built this to learn full-stack development with Flutter and Node.js.

⭐ **If you find this helpful, give it a star and follow me for more projects like this!**

## What does it do?

You fill in your details like name, skills, education, work experience, and projects. The app then uses AI to generate a nicely written resume for you. You can download it as a PDF or share it with others.

## Tech Stack

**Frontend:**
- Flutter (for mobile and web)
- Dart programming language

**Backend:**
- Node.js with Express.js
- MongoDB for database
- Mongoose for database operations

**AI:**
- Groq AI API
- Model: llama-3.3-70b-versatile

## Packages I Used

**Flutter packages:**
- `http` - to call backend APIs
- `provider` - for state management
- `google_fonts` - for nice fonts
- `pdf` - to create PDF files
- `printing` - to preview and print PDFs
- `path_provider` - to save files on device
- `share_plus` - to share PDFs with others

**Node.js packages:**
- `express` - web framework
- `mongoose` - MongoDB connection
- `dotenv` - environment variables
- `groq-sdk` - for AI integration
- `cors` - to allow cross-origin requests

## Features

- Create resume with your personal info, skills, education, work experience, and projects
- AI generates a professional summary based on your details
- Edit and update your resume anytime
- When you update, AI regenerates the content automatically
- Preview PDF before downloading
- Download PDF to your device (mobile only)
- Share PDF with others (mobile only)
- Delete resumes you don't need
- Works on both mobile and web

## How it works

1. You enter your details in the form
2. Click "Create Resume"
3. The backend sends your data to Groq AI
4. AI writes a professional resume for you
5. Everything gets saved in MongoDB
6. You can preview, download, or share your resume as PDF

## Deployment

**Frontend:** Netlify
Live at: groq-ai-resume.netlify.app

**Backend:** Render
Deployed backend on Render.

**Database:** MongoDB Atlas (cloud)

## Project Structure

```
resume generator/
├── backend/
│   ├── db/
│   │   └── db.js              # MongoDB schema and connection
│   ├── routes/
│   │   └── route.js           # All API endpoints
│   ├── .env                   # Environment variables
│   └── server.js              # Express server
│
└── frontend/
    └── lib/
        ├── models/            # Data models
        ├── providers/         # State management
        ├── screens/           # UI screens
        └── services/          # API and PDF services
```

## API Endpoints

- `GET /api/resume-generator/all-resume` - Get all resumes
- `POST /api/resume-generator/build-ai-resume` - Create new resume
- `PUT /api/resume-generator/update-resume/:id` - Update existing resume
- `DELETE /api/resume-generator/delete-resume/:id` - Delete resume

## Environment Variables

You need to create a `.env` file in the backend folder:

```
PORT=8000
MONGO_URI=your_mongodb_connection_string
GROQ_API=your_groq_api_key
```

## Running Locally

**Backend:**
```bash
cd backend
npm install
node server.js
```

**Frontend:**
```bash
cd frontend
flutter pub get
flutter run
```

## Things I Learned

- How to build a full-stack app from scratch
- Working with AI APIs (Groq)
- Creating and manipulating PDFs in Flutter
- MongoDB database operations
- State management with Provider
- Deploying apps to cloud platforms
- Making APIs that mobile and web can both use
- Platform-specific code (iOS, Android, Web)

## Challenges I Faced

1. PDF preview didn't work the same way on iOS and Android
2. Download and Share features don't work on web (only Preview works there)
3. Had to regenerate AI content whenever someone updates their resume
4. Getting the navigation right after editing a resume
5. Making sure UI refreshes properly after updates

## What's Next?

This is just a learning project, but some ideas for the future:
- Add authentication so users have their own accounts
- Multiple resume templates to choose from
- Export in different formats (Word, Plain Text)
- Better AI prompts for more personalized resumes

## Why I Built This

I wanted to learn how to:
- Connect a Flutter app to a real backend
- Work with AI APIs
- Handle file operations (PDFs)
- Deploy a full app to production
- Build something actually useful

It's not perfect, but it works and I learned a lot building it.

## License

This is a personal learning project. Feel free to use the code if it helps you learn too.
