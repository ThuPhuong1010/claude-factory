---
name: cli-tool
description: "Node.js CLI tool. Trigger khi build CLI app, npm package chạy terminal, tool với arguments/flags."
---

# CLI Tool (Node.js)

## Stack: Commander.js + tốc độ
```bash
npm install commander chalk ora
npm install -D @types/node tsx
```

## Structure
```
my-cli/
├── src/
│   ├── index.ts     # entry, define commands
│   └── commands/
│       ├── init.ts
│       └── build.ts
├── package.json
└── tsconfig.json
```

## Entry Point Pattern
```ts
// src/index.ts
#!/usr/bin/env node
import { Command } from 'commander'
import chalk from 'chalk'
import { initCommand } from './commands/init'

const program = new Command()

program
  .name('mytool')
  .description('My CLI tool')
  .version('1.0.0')

program
  .command('init <name>')
  .description('Initialize a new project')
  .option('-t, --template <type>', 'template type', 'default')
  .option('--dry-run', 'preview without writing files')
  .action(initCommand)

program.parseAsync()
```

## Command Pattern
```ts
// src/commands/init.ts
import ora from 'ora'
import chalk from 'chalk'

interface Options { template: string; dryRun: boolean }

export async function initCommand(name: string, options: Options) {
  const spinner = ora(`Creating ${name}...`).start()
  try {
    if (!options.dryRun) {
      await createProject(name, options.template)
    }
    spinner.succeed(chalk.green(`✓ Created ${name}`))
  } catch (err) {
    spinner.fail(chalk.red(`Failed: ${err.message}`))
    process.exit(1)
  }
}
```

## package.json
```json
{
  "bin": { "mytool": "./dist/index.js" },
  "scripts": {
    "dev": "tsx src/index.ts",
    "build": "tsc",
    "start": "node dist/index.js"
  }
}
```

## Output Conventions
```ts
import chalk from 'chalk'

console.log(chalk.blue('ℹ info message'))
console.log(chalk.green('✓ success'))
console.log(chalk.yellow('⚠ warning'))
console.error(chalk.red('✗ error'))
```

## Thư viện hay dùng
| Need | Package |
|------|---------|
| Interactive prompts | `@inquirer/prompts` |
| Progress bar | `cli-progress` |
| Table output | `cli-table3` |
| Config file (~/.config) | `conf` |
| Exec shell commands | `execa` |
