const migrate = require("quikdraw").migrate;

async function main() {
  const betAddress = await migrate("Bet");
  await migrate("Deal", [betAddress]);
}
main();
