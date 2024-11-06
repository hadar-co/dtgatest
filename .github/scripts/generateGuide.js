const { google } = require('googleapis');
const path = require('path');

// Path to your service account key file
const keyFilePath = path.join(__dirname, process.env.GOOGLE_APPLICATION_CREDENTIALS);

// Create a JWT (JSON Web Token) client using the service account
const auth = new google.auth.GoogleAuth({
  keyFile: keyFilePath,
  scopes: 'https://www.googleapis.com/auth/cloud-platform',
});

// The Google Gemini API client
const gemini = google.generativelanguage('v1beta2');

async function generateContent() {
  try {
    // Authenticate using the service account
    const authClient = await auth.getClient();

    // Use the input values passed through the environment variables
    const title = process.env.TITLE || 'Default Guide Title';
    const description = process.env.DESCRIPTION || 'Default description of the guide.';
    const model = process.env.MODEL || 'projects/your-project-id/locations/global/models/gemini-1.5-flash-latest';

    // Construct the prompt dynamically
    const prompt = `Create a guide titled '${title}' with the following description: ${description}. Format the guide in markdown.`; 

    // Request to generate content from Gemini API
    const res = await gemini.projects.locations.models.texts.generateText({
      auth: authClient,
      requestBody: {
        model: model,
        instances: [{ prompt }],
      },
    });

    // Assuming the response contains the generated markdown content
    const guideMarkdown = res.data.generatedContent;
    console.log(`Generated Markdown:\n${guideMarkdown}`);

    // Write the generated content to a markdown file
    const fs = require('fs');
    fs.writeFileSync('guide.md', guideMarkdown);

  } catch (error) {
    console.error('Error generating guide:', error.message);
  }
}

generateContent();
