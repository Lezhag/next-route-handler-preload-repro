// Stands in for a large module graph (an API router, an ORM, SDK clients):
// about 500ms of work when this module is first evaluated.
const started = Date.now();
while (Date.now() - started < 500) {}
const evaluatedAt = new Date().toISOString();

export function GET() {
  return Response.json({ evaluatedAt });
}
