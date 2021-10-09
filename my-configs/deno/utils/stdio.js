const decoder = new TextDecoder();
const encoder = new TextEncoder();

export async function stdin() {
  const buf = new Uint8Array(1024);
  const n = await Deno.stdin.read(buf);
  return decoder.decode(buf.subarray(0, n)).trim();
}

export function stdout(str) {
  return Deno.stdout.write(encoder.encode(str));
}

export function stderr(str) {
  return Deno.stderr.write(encoder.encode(str));
}

export function echo(...args) {
  let str = '';
  for(let arg of args) {
    str += Array.isArray(arg) ? arg.join(' ') : arg.toString();
    str += ' ';
  }

  return stdout(str + '\n');
}

echo.error = function(...args) {
  let str = '';
  for(let arg of args) {
    str += Array.isArray(arg) ? arg.join(' ') : arg.toString();
    str += ' ';
  }

  return stderr(str + '\n');
}

export function exit(code = 0, message = '') {
  if(code === 0) {
    message.length && console.log(message);
    Deno.exit(0);
  }

  message.length && console.error(message);
  Deno.exit(code)
}

