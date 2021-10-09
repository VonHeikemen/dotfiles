const escape = str => str.replace(/ /g, '\\ ');
const decoder = new TextDecoder();

function shell(exec, options) {
  return (pieces, ...args) => {
    let cmd = pieces[0];
    let i = 0;
    while (i < args.length) {
      if(Array.isArray(args[i])) {
        cmd += args[i].join(' ');
        cmd += pieces[++i];
      } else {
        cmd += args[i] + pieces[++i];
      }
    }

    return exec(parse_cmd(cmd), options);
  }
}

// If you have any idea how to improve this share your ideas with me here:
// https://dev.to/vonheikemen/parse-shell-commands-in-javascript-with-tagged-templates-1g5a
function parse_cmd(str) {
  let result = [];
  let log_matches = false;

  let regex = /(([\w-/_~\.]+)|("(.*?)")|('(.*?)'))/g;
  let groups = [2, 4, 6];
  let match;

  while ((match = regex.exec(str)) !== null) {
    // This is necessary to avoid infinite loops with zero-width matches
    if (match.index === regex.lastIndex) {
      regex.lastIndex++;
    }

    // For this to work the regex groups need to be mutually exclusive
    for (let group of groups) {
      if(match[group]) {
        result.push(match[group]);
      }
    }
  }

  return result;
}

async function run_cmd(cmd, options) {
  const process = Deno.run({ cmd, ...options });
  const result = await process.status();
  return {
    success: result.success,
    code: result.code,
    stdout: () => process.output(),
    stderr: () => process.stderrOutput(),
    instance: process
  };
}

const sh = shell(run_cmd);
sh.quiet = shell(run_cmd, {stdout: 'null', stderr: 'null'});
sh.piped = shell(run_cmd, {stdout: 'piped', stderr: 'piped'});
sh.build = shell.bind(null, run_cmd);
sh.parser = parse_cmd;

sh.capture = async (pieces, ...args) => {
  const p = await sh.piped(pieces, ...args);
  const output = p.success ? p.stdout() : p.stderr();

  return decoder.decode(await output);
};

sh.safe = (pieces, ...args) => {
  try {
    return sh(pieces, ...args);
  } catch (e) {
    return e
  }
};

export default sh

