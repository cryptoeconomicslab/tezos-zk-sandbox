const conseiljs = require('conseiljs');
const conseiljssoftsigner = require('conseiljs-softsigner');
conseiljs.registerFetch(require('node-fetch'))
conseiljs.registerLogger(console)
const config = require('../truffle-config');
const {dev} = require('../keys/accounts');
const tezosNode = config.networks.development.host + ':' + config.networks.development.port
const fs = require('fs');
const path = require('path');

async function deployContract() {
    const keyStore = {
        publicKey: dev.pk,
        secretKey: dev.sk,
        publicKeyHash: dev.pkh,
        seed: '',
        storeType: conseiljs.KeyStoreType.Fundraiser
    };
    const abi = JSON.parse(fs.readFileSync(path.join(__dirname, '../build/contracts/main.json')).toString())
    const contract = abi.michelson;
    const storage = '(Some False)';

    const signer = await conseiljssoftsigner.SoftSigner.createSigner(conseiljs.TezosMessageUtils.writeKeyWithHint(keyStore.secretKey, 'edsk'));
    const result = await conseiljs.TezosNodeWriter.sendContractOriginationOperation(
      tezosNode,
      signer,
      keyStore,
      0,
      undefined,
      100000,
      1000,
      100000,
      contract,
      storage,
      conseiljs.TezosParameterFormat.Michelson
    );
    console.log(`Injected operation group id ${result.operationGroupID}`);
}

deployContract();