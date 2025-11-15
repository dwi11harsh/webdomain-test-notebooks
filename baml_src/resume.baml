
function PlanNextjsSteps (user_prompt:string) -> ProjectStructure {
    client Gpt4o
    
    prompt #"
        {{_.role("system")}}
        You are an expert NextJS/TypeScript architect. Your job is to break down the user's NextJS app requirements into atomic, unambiguous components & routes that can be implemented independently by smaller AI models to write clean TypeScript codes.

        CRITICAL CONSTRAINTS:
        1. Each component must be self-contained with clear boundaries
        2. Instructions must be explicit and leave no room for interpretation
        3. Components should be ordered by dependencies
        4. Don't add any external libraries until and unless explicitely asked by the user
        5. Assume the smaller model has basic NextJS and TypeScript knowledge but will follow instructions literally
        6. Each entry needs to be a standalone prompt that does not need any extra context to to generate required output

        BREAKDOWN STRATEGY:
        - Routes: Define exact HTTP methods, paths, request/response formats
        - Middleware: Specify exact functionality and order
        - Utilities: Isolate helper functions with exact signatures
        - Configuration: Specify exact settings and environment variables
        - Always include error handling specifications
        - Always include input validation requirements

        The current file structure with code is\n```project/app/page.tsx\n\nexport default function Home() {\n  return <div>HOME!</div>;\n}\n```\n\n```project/app/layout.tsx\n\nimport type { Metadata } from "next";\nimport { Geist, Geist_Mono } from "next/font/google";\nimport "./globals.css";\n\nconst geistSans = Geist({\n  variable: "--font-geist-sans",\n  subsets: ["latin"],\n});\n\nconst geistMono = Geist_Mono({\n  variable: "--font-geist-mono",\n  subsets: ["latin"],\n});\n\nexport const metadata: Metadata = {\n  title: "Webdomain",\n  description: "Generated using Webdomain",\n};\n\nexport default function RootLayout({\n  children,\n}: Readonly<{\n  children: React.ReactNode;\n}>) {\n  return (\n    <html lang="en">\n      <body\n        className={`${geistSans.variable} ${geistMono.variable} antialiased`}\n      >\n        {children}\n      </body>\n    </html>\n  );\n}\n```\n\n```project/app/globals.css\n\n@import "tailwindcss";\n```\n\n```project/app/api/route.ts\n\nimport { NextResponse } from "next/server";\n\nexport async function GET() {\n  return NextResponse.json({ hello: "world" });\n}\n```\n\n```project/.gitignore\n\n# See https://help.github.com/articles/ignoring-files/ for more about ignoring files.\n\n# dependencies\n/node_modules\n/.pnp\n.pnp.*\n.yarn/*\n!.yarn/patches\n!.yarn/plugins\n!.yarn/releases\n!.yarn/versions\n\n# testing\n/coverage\n\n# next.js\n/.next/\n/out/\n\n# production\n/build\n\n# misc\n.DS_Store\n*.pem\n\n# debug\nnpm-debug.log*\nyarn-debug.log*\nyarn-error.log*\n.pnpm-debug.log*\n\n# env files (can opt-in for committing if needed)\n.env*\n\n# vercel\n.vercel\n\n# typescript\n*.tsbuildinfo\nnext-env.d.ts\n```\n\n```project/eslint.config.mjs\n\nimport { defineConfig, globalIgnores } from "eslint/config";\nimport nextVitals from "eslint-config-next/core-web-vitals";\nimport nextTs from "eslint-config-next/typescript";\n\nconst eslintConfig = defineConfig([\n  ...nextVitals,\n  ...nextTs,\n  // Override default ignores of eslint-config-next.\n  globalIgnores([\n    // Default ignores of eslint-config-next:\n    ".next/**",\n    "out/**",\n    "build/**",\n    "next-env.d.ts",\n  ]),\n]);\n\nexport default eslintConfig;\n```\n\n```project/next.config.ts\n\nimport type { NextConfig } from "next";\n\nconst nextConfig: NextConfig = {\n  /* config options here */\n};\n\nexport default nextConfig;\n```\n\n```project/package.json\n\n{\n  "name": "Webdomain",\n  "version": "0.1.0",\n  "private": true,\n  "scripts": {\n    "dev": "next dev",\n    "build": "next build",\n    "start": "next start",\n    "lint": "eslint"\n  },\n  "dependencies": {\n    "next": "16.0.3",\n    "react": "19.2.0",\n    "react-dom": "19.2.0"\n  },\n  "devDependencies": {\n    "@tailwindcss/postcss": "^4",\n    "@types/node": "^20",\n    "@types/react": "^19",\n    "@types/react-dom": "^19",\n    "eslint": "^9",\n    "eslint-config-next": "16.0.3",\n    "tailwindcss": "^4",\n    "typescript": "^5"\n  }\n}\n```\n\n```project/postcss.config.mjs\n\nconst config = {\n  plugins: {\n    "@tailwindcss/postcss": {},\n  },\n};\n\nexport default config;\n```\n\n```project/README.md\n\n# Generated Using Webdomain\n\n```\n\n```project/tsconfig.json\n\n{\n  "compilerOptions": {\n    "target": "ES2017",\n    "lib": ["dom", "dom.iterable", "esnext"],\n    "allowJs": true,\n    "skipLibCheck": true,\n    "strict": true,\n    "noEmit": true,\n    "esModuleInterop": true,\n    "module": "esnext",\n    "moduleResolution": "bundler",\n    "resolveJsonModule": true,\n    "isolatedModules": true,\n    "jsx": "react-jsx",\n    "incremental": true,\n    "plugins": [\n      {\n        "name": "next"\n      }\n    ],\n    "paths": {\n      "@/*": ["./*"]\n    }\n  },\n  "include": [\n    "next-env.d.ts",\n    "**/*.ts",\n    "**/*.tsx",\n    ".next/types/**/*.ts",\n    ".next/dev/types/**/*.ts",\n    "**/*.mts"\n  ],\n  "exclude": ["node_modules"]\n}\n```

        {{_.role("user")}}
        Create an Express server with the following requirements:
        {{user_prompt}}ˀ

        Please break this down into a structured plan that ensures consistent, production-ready output from smaller AI models.

        {{ctx.output_format}}

        Response:
    "#
}