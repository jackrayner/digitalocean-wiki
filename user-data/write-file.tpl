# Author: Jack Rayner <hello@jrayner.net>

write_files:
- encoding: b64
  owner: ${owner}:${group}
  path: ${path}
  permissions: '${mode}'
  content: ${content}