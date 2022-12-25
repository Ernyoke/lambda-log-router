export const handler = async function (event, context) {
    console.log("This is a log message:", JSON.stringify(event));
    try {
        return formatResponse({ result: 'success' });
    } catch (error) {
        console.error("ERROR:", error);
        return formatResponse({ result: 'error' });
    }
};

const formatResponse = body => {
    return {
        statusCode: 200,
        headers: {
            'Content-Type': "application/json"
        },
        isBase64Encoded: false,
        body: JSON.stringify(body)
    };
};

// SIGTERM Handler 
process.on('SIGTERM', async () => {
    console.info('[runtime] SIGTERM received');
    console.info('[runtime] exiting');
    process.exit(0);
});