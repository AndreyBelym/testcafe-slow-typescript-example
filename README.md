# TestCafé Slow TypeScript Example

TestCafé offers TypeScript support OOTB, but there is significant overhead incurred compared to compiling the TypeScript, then running the output.

This problem appears to get exponentially worse as more modules are introduced.

## Benchmarks

The following benchmarks were ran on a mid-2015 Macbook Pro w/ 2.2GHz i7 CPU and 16GB RAM:

```
> npm run benchmark

> testcafe-slow-modules-example@ benchmark /Users/caseywebb/Code/testcafe-example
> echo TestCafé Version: $(testcafe --version) && npm run benchmark:prebuild && npm run benchmark:native

TestCafé Version: 0.16.2

> testcafe-slow-modules-example@ benchmark:prebuild /Users/caseywebb/Code/testcafe-example
> time sh -c 'tsc && testcafe chrome fixture/dist/index.js' > /dev/null


real    0m7.073s
user    0m3.328s
sys     0m0.370s

> testcafe-slow-modules-example@ benchmark:native /Users/caseywebb/Code/testcafe-example
> time testcafe chrome fixture/src/index.ts > /dev/null


real    0m20.673s
user    0m16.759s
sys     0m0.997s
```

## About / Usage

This repo is written for a UNIX-like environment; Windows users will need to modify the npm run scripts.

Install dependencies with `npm install`; this will also trigger a post-installation hook to generate
the fixture.

The fixture has the following structure:

```
fixture
├── dist
│   ├── index.js
│   └── modules
│       ├── index.js
│       ├── a.js
│       ├── b.js
│       ├── c.js
│       └── ...
└── src
    ├── index.ts
    └── modules
        ├── index.ts
        ├── a.ts
        ├── b.ts
        ├── c.ts
        └── ...
```

Where `src` contains the TypeScript files that the "native" benchmark is ran against, and
`dist` contains the transpiled output from `tsc` that the "prebuilt" benchmark is ran against.

Each lettered file — i.e. `a.ts`, `b.ts`, etc. — consists only of a single named export.

`src/modules/index.ts` exports all of the other files in the directory, and is imported wholesale
by `src/index.ts`.

`src/index.ts` contains a single dummy test, and a reference to the imported modules to prevent
dead code removal.

After installing dependencies and generating the fixture, run the benchmarks with...

```
$ npm run benchmark
```

...or to run a single benchmark...

```
$ npm run benchmark:native
$ npm run benchmark:prebuild
```

You may tweak the number of modules by changing the range — `{a..z}` — in `create_fixture.sh`