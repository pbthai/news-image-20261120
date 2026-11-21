import { readFileSync, statSync, writeFileSync } from 'node:fs';
import { join } from 'node:path';

const maximumBytes = 1_048_576;
const pngSignature = Buffer.from([137, 80, 78, 71, 13, 10, 26, 10]);
const imagePath = new URL('./entry.png', import.meta.url);

try {
  // Reject oversized files before allocating their contents.
  const sourceSize = statSync(imagePath).size;
  if (sourceSize > maximumBytes) {
    throw new Error(`entry.png is ${sourceSize} bytes; maximum is ${maximumBytes}`);
  }
  const image = readFileSync(imagePath);
  // Recheck the bytes that will be written if the source changed during the read.
  if (image.length > maximumBytes) {
    throw new Error(`entry.png exceeds the ${maximumBytes}-byte limit`);
  }
  if (!image.subarray(0, pngSignature.length).equals(pngSignature)) {
    throw new Error('entry.png does not begin with the PNG signature');
  }

  const directory = process.env.MAKEFUN_OUTPUT_DIR ?? '/output';
  writeFileSync(join(directory, 'entry.png'), image);
} catch (error) {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
}
