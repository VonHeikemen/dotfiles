const intl = new Intl.NumberFormat('de-DE', { maximumFractionDigits: 2 });

export default function format_number(number) {
  return intl.format(number);
}
