const AWS = require('aws-sdk');
const axios = require('axios');
const tokenGen = require('./src/app/tokenGenerator.js');

exports.handler = async (event, context) => {
  try {
    const awsProfile = context.invokedFunctionArn.split(':')[4]; //profilo AWS
    
    const results = [];
    const { entries } = event;
  
    let env_type = 'dev';
    
    for (const entry of entries) {
      const { taxId, tokenType, paName } = entry;
      if ((!taxId || !tokenType) ||
        (tokenType !== 'PA' && tokenType !== 'PF' && tokenType !== 'PG') || 
        (tokenType === 'PA' && !paName)) {
        return 'ERORR required parameters'
      }
     
      const token = await tokenGen.tokenGenerator(env_type, taxId, tokenType, awsProfile, paName );
      results.push({ "taxiId": taxId,  "token": token });
    }

    return {
      statusCode: 200,
      body: JSON.parse(JSON.stringify(results)),
    };
  } catch (error) {
    return {
      statusCode: 500,
      body: JSON.parse(JSON.stringify({ problem: error })),
    };
  }
};

/** 
 * EXAMPLE:
 * 
{
  "entries": [
    {
      "taxId": "CLMCST42R12D969Z",
      "tokenType": "PF"
    },
    {
      "taxId": "70472431207",
      "tokenType": "PG"
    },
    {
      "taxId": "01199250158",
      "tokenType": "PA",
      "paName": "milano"
    }
  ]
}
 *
 *
*/