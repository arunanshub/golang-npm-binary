import { defineConfig } from "tsup";

export default defineConfig({
  entry: ["src/bin.ts"],
  format: ["esm"],
  platform: "node",
  target: "node18",
  splitting: false,
  sourcemap: false,
  minify: true,
  clean: true,
  dts: false,
});
