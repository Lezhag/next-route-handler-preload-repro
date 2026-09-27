# Route handler code is no longer preloaded on `next start` (16.3)

`experimental.preloadEntriesOnStart` (on by default) still requires each app
route's entry at startup. Since 16.3, an App Route keeps its own module behind
a `LazyModule` (`routeModule._lazyUserland`), and the preload never calls
`ensureUserland()`. So the route handler's top-level code runs on its first
request, however long the server has been up.

`app/api/heavy/route.ts` burns 500 ms at module evaluation to stand in for a
large module graph.

## Run

```sh
npm install
npx next build
./measure.sh   # next start, wait 10 s, time two requests
```

## Result (macOS arm64, Node 24.15.0)

| next | first `GET /api/heavy` | second |
|---|---|---|
| 16.2.6 | 9 ms | 2 ms |
| 16.3.6 | 508 ms | 2 ms |
| 16.4.0-canary.50 | 508 ms | 2 ms |

`next build --webpack` on 16.3.6 gives the same 508 ms, so this is the server
runtime, not the bundler. Pages are unaffected.
