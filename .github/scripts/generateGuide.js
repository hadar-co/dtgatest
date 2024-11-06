const axios = require('axios');
const fs = require('fs');

async function generateGuide(title, description) {
  try {
    // Send a request to Google Gemini API
    const response = await axios.post(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent',
      {
        prompt: `${title} - ${description}`,
        temperature: 0.7
      },
      {
        headers: {
          'Authorization': `Bearer ${process.env.GOOGLE_GEMINI_API_KEY}`,
          'Content-Type': 'application/json'
        }
      }
    );

    const guideMarkdown = response.data.candidates[0].output;
    fs.writeFileSync('guide.md', guideMarkdown);
    console.log(`Generated Markdown:\n${guideMarkdown}`);
  } catch (error) {
    console.error('Error generating guide:', error);
    process.exit(1);
  }
}

// Accept title and description from the command-line arguments
const [title, description] = process.argv.slice(2);
generateGuide(title, description);
