import arg from 'arg';

export default function cli(spec, options) {
  return arg(spec, { argv: Deno.args, ...options });
}

