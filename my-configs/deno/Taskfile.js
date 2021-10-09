const entrypoint = "./src/main.js";

run(Deno.args, {
  start(...args) {
    sh`deno run ${entrypoint} ${args}`;
  },
  format() {
    sh`deno fmt ${entrypoint}`;
  },
  list() {
    console.log('Available tasks: ');
    Object.keys(this).forEach((k) => console.log(k));
  },
});

function run([name, ...args], tasks) {
  if(tasks[name]) {
    tasks[name](...args);
  } else {
    console.log(`Task "${name}" not found\n`);
    tasks.list();
  }
}

function sh(pieces, ...args) {
  let cmd = pieces[0].split(' '); 
  let i = 0;
  while (i < args.length) {
    if(Array.isArray(args[i])) {
      cmd.push(...args[i]);
      cmd.push(pieces[++i]);
    } else {
      cmd.push(args[i], pieces[++i]);
    }
  }

  const non_empty = arg => arg.trim() != '';
  return exec(cmd.filter(non_empty));
}

async function exec(args) {
  const proc = await Deno.run({ cmd: args }).status();

  if (proc.success == false) {
    Deno.exit(proc.code);
  }

  return proc;
}

