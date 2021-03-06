const { program } = require("commander");
const { exec, execSync } = require("child_process");
const fs = require("fs");

const getLigo = (isDockerizedLigo) => {
  let path = "ligo";
  if (isDockerizedLigo) {
    path = "docker run -v $PWD:$PWD --rm -i ligolang/ligo:next";
    try {
      execSync(`${path}  --help`);
    } catch (err) {
      console.log("Trying to use global version...");
      path = "ligo";
      execSync(`${path}  --help`);
    }
  } else {
    try {
      execSync(`${path}  --help`);
    } catch (err) {
      console.log("Trying to use Dockerized version...");
      path = "docker run -v $PWD:$PWD --rm -i ligolang/ligo:next";
      execSync(`${path}  --help`);
    }
  }
  return path;
};

const buildContract = (
  contractName,
  inputDir,
  outputDir,
  jsonFormat,
  isDockerizedLigo
) => {
  let ligo = getLigo(isDockerizedLigo);
  exec(
    `${ligo} compile-contract -p edo ${
      jsonFormat ? "--michelson-format=json" : ""
    } $PWD/${inputDir}/${contractName}.ligo main --disable-michelson-typechecking`,
    { maxBuffer: 1024 * 10000 },
    (err, stdout, stderr) => {
      if (err) {
        console.log(`Error during ${contractName} built`);
        console.log(err);
        console.error(stdout)
        console.error(stderr)
      } else {
        console.log(`${contractName} built`);
        fs.writeFileSync(
          `./${outputDir}/${contractName}.${jsonFormat ? "json" : "tz"}`,
          stdout
        );
      }
    }
  );
};

program.version("0.1.0");

program
  .command("build [contract]")
  .description("build contracts")
  .option("-o, --output_dir <dir>", "Where store builds", "build")
  .option("-i, --input_dir <dir>", "Where files are located", "contracts")
  .option("-j, --no-json", "The format of output file")
  .option("-g, --no-dockerized_ligo", "Switch global ligo")
  .action(function (contract, options) {
    let contractName = contract || "*";
    exec("mkdir -p " + options.output_dir);
    if (contractName === "*") {
      fs.readdirSync(options.input_dir).forEach((file) => {
        let fileParts = file.split(".");
        if (fileParts.length === 2 && fileParts.pop() === "ligo") {
          buildContract(fileParts[0], options.input_dir, options.output_dir);
        }
      });
    } else {
      buildContract(
        contractName,
        options.input_dir,
        options.output_dir,
        options.json,
        options.dockerized_ligo
      );
    }
  });

program.parse(process.argv);
