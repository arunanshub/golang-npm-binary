import { defineConfig } from "tsdown";

export default defineConfig({
  entry: ["src/bin.ts"],
  format: ["esm"],
  platform: "node",
  target: "node18",
  sourcemap: false,
  minify: true,
  clean: true,
  dts: false,
});
