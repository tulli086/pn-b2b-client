const AWS = require('aws-sdk');
const axios = require('axios');

module.exports.tokenGenerator = async (env_type, taxId, tokenType, awsProfile, paName) => {

    //let ApplicationLoadBalancerDomain = "";
    //let externalReg = `http://internal-pn-in-Appli-1HXGA7HK0CJQ3-1346751104.eu-south-1.elb.amazonaws.com:8080/ext-registry/pa/v1/activated-on-pn`;
    //let dataVaultBasePath = `http://alb.confidential.pn.internal:8080/datavault-private/v1/recipients/external/${tokenType}`;
    
    let externalReg = `${process.env.EXTERNAL_REG_BASE_PATH}/ext-registry/pa/v1/activated-on-pn`;
    let dataVaultBasePath = `${process.env.DATA_VAULT_BASE_PATH}/datavault-private/v1/recipients/external/${tokenType}`;

     /* DA COMPLETARE IN SEGUITO
    let apiKeyManagerBasePath = 'internal-pn-in-Appli-1HXGA7HK0CJQ3-1346751104.eu-south-1.elb.amazonaws.com:8080';
    let getApiKey = apiKeyManagerBasePath+'/api-key-self/api-keys';
    console.log('inizioChiamata');
    await axios.get(getApiKey+'?limit=10', {
        headers: {
            'Accept': 'application/problem+json',
        }})
      .then((response) => {
        console.log("RESPONSE API-KEY: "+ response);
      })
      .catch((error) =>{
        console.log(error);
      });
      */

    let uid;
    if(tokenType === 'PF' || tokenType === 'PG')  {
      console.log(dataVaultBasePath);
      await axios.post(dataVaultBasePath, taxId, {
        headers: {
            'Content-Type': 'text/plain',
        }})
      .then((response) => {
        uid = response.data.substring(3);
        console.log("RESPONSE DATA-VAULT: "+ uid);
      })
      .catch((error) =>{
        console.log(error);
      });
    }
    
    if(tokenType === 'PA'){
      console.log(externalReg+`?paNameFilter=${paName}`);
    
      await axios.get(externalReg+`?paNameFilter=${paName}`)
      .then((response) => {
        console.log("RESPONSE EXTERNAL-REGISTRIES : "+response.data[0].id);
      })
      .catch((err) => {
        console.log(err);
      });
    }
    

    const awsRegion = process.env.AWS_REGION || process.env.AWS_DEFAULT_REGION; // Recupera la regione AWS
    
    let organization_id;
    if(tokenType === 'PA' || tokenType === 'PG'){
      const dynamodb = new AWS.DynamoDB({ region: awsRegion });
      const params = {
        TableName: "pn-OnboardInstitutions",
        FilterExpression: "taxCode = :value",
        ExpressionAttributeValues: {
          ":value": {
            "S": taxId
          }
        }
      };

      dynamodb.scan(params, (err, data) => {
        if (err) {
          console.log('Errore durante la lettura dell\'elemento:', err);
        } else {
          organization_id = data.Items[0].externalId.S;
          console.log('Elemento letto dalla tabella:', organization_id );
        }
      });
    }
    

    const keyIdAlias = 'alias/pn-jwt-sign-key';
    const iss = `https://webapi.${env_type}.notifichedigitali.it`;
    const aud = `webapi.${env_type}.notifichedigitali.it`;


    const awsCommandBaseArgs = [];
    if (awsProfile) {
      awsCommandBaseArgs.push(`--profile ${awsProfile}`);
    }
    if (awsRegion) {
      awsCommandBaseArgs.push(`--region ${awsRegion}`);
    }

    
    let rolePg="pg-admin";
    let rolePa="admin";
    let aud_pa=`imprese.${env_type}.notifichedigitali.it`;
    let iss_pa="https://uat.selfcare.pagopa.it";
    
    const kms = new AWS.KMS();
    const header = { alg: 'RS256', typ: 'JWT', kid: '' };
	
	  const dateNow = Math.floor(Date.now() / 1000);
    const nextYearDate = Math.floor((Date.now() + 31536000000) / 1000); // esempio con validità un anno
    let payload;
    
    if(tokenType === 'PF'){
     payload = { iat: dateNow, exp: nextYearDate, uid: uid, iss: iss, aud: aud };
    }else if(tokenType === 'PG'){
      payload = { iat: dateNow, exp: nextYearDate, uid: uid, iss: iss, aud: aud, organization:{id: organization_id, role: rolePg, fiscal_code: taxId } };
    }else if(tokenType == 'PA'){
      payload = { iat: dateNow, exp: nextYearDate, uid: uid, iss: iss_pa, aud: aud_pa, organization:{id: organization_id, role: rolePa, fiscal_code: taxId } };
    }
    console.log(JSON.stringify(payload));
    

    const keyIdResponse = await kms.describeKey({ KeyId: keyIdAlias }).promise();
    const keyId = keyIdResponse.KeyMetadata.KeyId;
    header.kid = keyId;

    const headerBase64 = Buffer.from(JSON.stringify(header)).toString('base64').replace(/[+/]/g, (char) => (char === '+' ? '-' : '_')).replace(/=+$/, '');
    const payloadBase64 = Buffer.from(JSON.stringify(payload)).toString('base64').replace(/[+/]/g, (char) => (char === '+' ? '-' : '_')).replace(/=+$/, '');

    const messageToSign = `${headerBase64}.${payloadBase64}`;

    const signResponse = await kms.sign({
      KeyId: keyId,
      Message: messageToSign,
      MessageType: 'RAW',
      SigningAlgorithm: 'RSASSA_PKCS1_V1_5_SHA_256',
    }).promise();

  
    console.log(signResponse.Signature.toString('base64'));
    const signature = signResponse.Signature.toString('base64').replace(/[+/]/g, (char) => (char === '+' ? '-' : '_')).replace(/=+$/, '');
    const token = `${messageToSign}.${signature}`;

    return token;

}