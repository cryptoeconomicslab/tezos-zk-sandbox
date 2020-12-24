import { Context } from "./contracManagers/context";
import { strictEqual } from "assert";

contract("main", function () {
  let context: Context;

  before(async () => {
    context = await Context.init();
  });

  it("initiate new token", async function () {
    this.timeout(5000000);

    const op = await context.main.verify()
    const s: any = await context.main.getStorage()
    strictEqual(
      s.result,
      false,
      "token address should be stored"
    );
  });


});
