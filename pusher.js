const { WebClient } = require('@slack/web-api');
const fs = require('fs');

async function uploadFileToSlack(filePath, channel, initialComment, slackToken) {
    // Initialize the Slack WebClient
    const slackClient = new WebClient(slackToken);

    try {
        // Read the file into a buffer
        const fileBuffer = fs.readFileSync(filePath);

        // Upload the file using the Slack SDK
        const response = await slackClient.files.uploadV2({
            channel_id: channel,
            file: fileBuffer,
            filename: filePath.split('/').pop(),
            title: filePath.split('/').pop(),
            initial_comment: initialComment,
        });

        // Check the response
        if (response.ok) {
            console.log(`File uploaded successfully: ${response.file.permalink}`);
        } else {
            console.log(`Failed to upload file. Response: ${JSON.stringify(response, null, 2)}`);
        }
    } catch (error) {
        console.log(`HTTP request failed. Error: ${JSON.stringify(error.response?.data || error.message, null, 2)}`);
    }
}

// Export the function for use in the terminal
module.exports = uploadFileToSlack;

const args = process.argv.slice(2);
if (args.length < 4) {
    console.log('Usage: node uploadToSlack.js <filePath> <channel> <initialComment> <slackToken>');
    process.exit(1);
}

const [filePath, channel, initialComment, slackToken] = args;

// Call the function
uploadFileToSlack(filePath, channel, initialComment, slackToken);