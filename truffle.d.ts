declare type _contractTest = (accounts: string[]) => void;
declare let contract: ContractFunction;

interface ContractFunction {
  (title: string, fn: (this: any) => void): any;
  (title: string): any;
  only: any;
  skip: any;
}

declare interface TransactionMeta {
  from: string;
}

declare interface Contract<T> {
  "new"(storage: any): Promise<T>;
  deployed(): Promise<T>;
  at(address: string): T;
  address: string;
}

declare interface Artifacts {
  require(name: "migrations"): Contract<MainContractInstance>;
  require(name: "main"): Contract<MainContractInstance>;
}


declare interface MainContractInstance {
  address: string;
  verify(): any;
}

declare var artifacts: Artifacts;
declare var tezos: any;