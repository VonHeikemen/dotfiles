export function range(start, end) {
  return Array.from({length: ((end + 1) - start)}, (_, i) => i + start);
}

export function random(min, max) {
  min = Math.ceil(min);
  max = Math.floor(max);
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

