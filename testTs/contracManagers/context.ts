import { prepareProviderOptions } from "./utils";

import mainStorage from "../storage/main";
import { Main } from "./main";

let CMain = artifacts.require("main");

export class Context {
  public main: Main;

  constructor(main: Main) {
    this.main = main
  }

  static async init(
    accountName: string = "alice",
    useDeployedFactory: boolean = true
  ): Promise<Context> {
    let config = await prepareProviderOptions(accountName);
    tezos.setProvider(config);

    let mainInstance = useDeployedFactory
      ? await CMain.deployed()
      : await CMain.new(mainStorage);
    let main = await Main.init(mainInstance.address.toString());

    let context = new Context(main);
    return context;
  }
}
