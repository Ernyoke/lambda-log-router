'use strict';

// Handler
exports.handler = async function (event, context) {
    console.log(JSON.stringify(event));
    console.log(JSON.stringify(context));
    try {
        return formatResponse({ result: 'success' });
    } catch (error) {
        console.log(error);
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
        multiValueHeaders: {
            'X-Custom-Header': ['My value', 'My other value'],
        },
        body: JSON.stringify(body)
    };
};

// SIGTERM Handler 
process.on('SIGTERM', async () => {
    console.info('[runtime] SIGTERM received');

    console.info('[runtime] cleaning up');
    // perform actual clean up work here. 
    await new Promise(resolve => setTimeout(resolve, 200));

    console.info('[runtime] exiting');
    process.exit(0);
});