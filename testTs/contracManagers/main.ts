import { ContractAbstraction, ContractProvider } from "@taquito/taquito";
import { TransactionOperation } from "@taquito/taquito/dist/types/operations/transaction-operation";
import { MainStorage } from "./types";
import { prepareProviderOptions } from "./utils";
export const defaultTokenId = 0;

export class Main {
  public contract: ContractAbstraction<ContractProvider>;
  public storage: MainStorage;

  constructor(contract: ContractAbstraction<ContractProvider>) {
    this.contract = contract;
  }

  static async init(mainAddress: string): Promise<Main> {
    return new Main(await tezos.contract.at(mainAddress));
  }

  async updateProvider(accountName: string): Promise<void> {
    let config = await prepareProviderOptions(accountName);
    tezos.setProvider(config);
  }

  async verify(): Promise<TransactionOperation> {
    let operation = await this.contract.methods
      .verifyGroth16(/* TODO: add proof */)
      .send();

    await operation.confirmation();
    return operation;
  }

  async getStorage() : Promise<MainStorage> {
    return this.contract.storage()
  }
}
