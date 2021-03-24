export default function format_number(number) {
  return new Intl.NumberFormat('de-DE').format(number);
}
