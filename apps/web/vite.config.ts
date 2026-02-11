import { defineConfig } from "vite";
import solid from "vite-plugin-solid";

export default defineConfig({
  plugins: [solid()],
  server: { port: 3000 },
  resolve: {
    alias: { "@logistics/shared": "../../packages/shared/src" },
  },
});
