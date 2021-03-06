const entrypoint = "./src/main.js";

run(Deno.args, {
  start(...args) {
    exec(["deno", "run", entrypoint, ...args]);
  },
  format() {
    exec(["deno", "fmt", entrypoint]);
  },
  list() {
    Object.keys(this).forEach((k) => console.log(k));
  },
});

function run([name, ...args], tasks) {
  name in tasks
    ? tasks[name](...args)
    : console.log(`Task "${name}" not found`);
}

async function exec(args) {
  const proc = await Deno.run({ cmd: args }).status();

  if (proc.success == false) {
    Deno.exit(proc.code);
  }

  return proc;
}
