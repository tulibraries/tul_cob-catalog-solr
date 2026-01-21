# AGENTS GUIDE FOR TUL COB CATALOG SOLR
Use this file to orient coding agents working in this repository.
Scope: applies to entire repository until another nested AGENTS.md appears.
No Cursor or Copilot rule files found at request time.
Prefer minimal changes aligned with existing patterns and configs.
## Quick facts
- Solr configuration and relevancy tests for TUL Cob catalog.
- Primary languages: Ruby for tests/utility, XML for Solr config, shell scripts.
- Default Ruby version: 3.4.5.
- Containers run via docker compose; services: app, solr.
- Default Solr URL in containers: http://solr:8983/solr/blacklight.
- Bundler vendor path: /app/vendor/bundle inside container.
- Test data fixtures live in spec/fixtures/*.xml.
- Custom RSpec matcher defined in spec/spec_helper.rb (include_items).
- No additional subdirectory AGENTS.md currently present.
## Build and environment setup
- Use `make up` to start containers (app + solr) and install gems.
- Use `make down` to stop and remove containers.
- `make tty-app` opens bash inside app container; run Ruby/Bundler there.
- `make tty-solr` opens bash inside Solr container.
- `make ps` shows running compose services.
- For fresh start: `make down` then `make up`.
- Keep host Ruby isolated; prefer running commands inside containers.
- Use `docker compose` (v2 syntax) if running commands manually.
- Environment variables used: SOLR_URL, SOLR_DISABLE_UPDATE_DATE_CHECK, DO_INGEST, LC_ALL.
- Do not expose secrets; SOLR_USER/SOLR_PASSWORD only used in CI deploy.
## Linting
- Run Ruby lint via `make lint` (docker compose exec app bundle exec rubocop).
- In CI, lint runs with `bundle exec rubocop` on Ruby 3.4.
- Follow .rubocop.yml; DisabledByDefault true, only enabled cops apply.
- Add `# frozen_string_literal: true` to Ruby files unless excluded.
- Prefer double quotes for strings (Style/StringLiterals).
- Enforce parentheses on method definitions with params (Style/MethodDefParentheses).
- Use `&&`/`||` instead of `and`/`or`.
- Indent with two spaces; avoid tabs and trailing whitespace.
- Align `case/when` and `end` per RuboCop defaults.
- Space rules: after commas/colons, around operators, inside parens/braces as configured.
## Tests overview
- Tests use RSpec; entry point `bundle exec rspec`.
- Full suite command: `make test` (docker compose exec app bundle exec rspec).
- Suite depends on Solr running and loaded with fixtures.
- Load fixtures via `make load-data` (runs bin/load-data).
- `bin/load-data` waits for Solr HTTP 302 then ingests XML fixtures with cob_index.
- After config changes, `make reload-config` reloads Solr core files.
- Keep SOLR_URL consistent with docker compose when running tests locally.
- When changing ingest, ensure `cob_index` tag in Gemfile remains compatible.
- For repeatability, run tests from clean containers to avoid residual data.
## Running a single or focused test
- Example: `docker compose exec app bundle exec rspec spec/relevance/name_initials_query_spec.rb:10`.
- You can target a whole file: `docker compose exec app bundle exec rspec spec/relevance/keyword_spec.rb`.
- Within container shell, omit `docker compose exec app`: `bundle exec rspec spec/...`.
- Prefer line-number filters over `--example` for speed.
- Ensure Solr data loaded before focused runs to avoid empty responses.
- Use `rspec --format documentation` inside container when debugging expectations.
- Keep custom matcher `include_items` in mind for order-sensitive specs.
## Docker and services
- Compose file: docker-compose.yml; Solr 9.6.1 image, app image from RUBY_VERSION.
- Compose mounts repo into /app; bin/load-data copied into path for Solr.
- Solr entrypoint uses `solr-precreate` for core `blacklight` with config from repo.
- Avoid editing data inside /var/solr directly; use provided scripts.
- If containers fail, check `docker compose logs solr` and `... logs app`.
- Memory flags set in compose (-Xms256m -Xmx512m); adjust only if necessary.
- For networked testing, exposed port 8983 -> host.
- Running `docker compose exec app bundle install` handled by `make up`.
- Keep DOCKER env `APP_IMAGE` aligned with Makefile if overriding.
## Ruby style essentials
- Follow RuboCop enforced cops listed in .rubocop.yml only.
- Use double quotes for strings; prefer hash literal shorthand but permit => when needed.
- Keep blank lines minimal; no empty lines around method/class bodies per Layout cops.
- Require parentheses on method definitions with parameters.
- Indent access modifiers internal methods per Layout/IndentationConsistency.
- Avoid trailing whitespace and ensure newline at EOF.
- Prefer explicit parentheses for method calls needing clarity (Lint/RequireParentheses).
- Use descriptive variable names; avoid single-letter names except block indices.
- Place private/protected sections with proper indent of following methods.
- Keep comments aligned with method definitions (Layout/CommentIndentation).
- Freeze string literals comment required unless file is excluded.
- Use `require` ordering: stdlib first, external gems next, local files last.
- Prefer `pp` only for debugging; remove before merging.
- Keep block braces spaced: `foo { bar }`, not `foo {bar}`.
- Hash braces spaced `{ key: value }`; spaces inside parentheses permitted per cop.
- Avoid `and`/`or`; use `&&`/`||`.
## RSpec style
- Place `# frozen_string_literal: true` atop spec files.
- Require `spec_helper` not rails helper.
- Use `let`/`let!` for setup; avoid ivars.
- Prefer `context` blocks with descriptive strings over nested describes when possible.
- Keep expectations explicit with `expect(...).to eq(...)`.
- Reuse RSolr connections sparingly; existing specs instantiate once per file.
- Use custom matcher `include_items` for ordered inclusion assertions.
- Avoid `before(:all)` unless needed; prefer `before(:each)` default.
- Keep per-test fixtures minimal; rely on spec/fixtures XML files.
- Tag slow specs if you add any; none present currently.
- Keep example descriptions declarative and precise.
## Solr config and XML
- Main config files: `schema.xml`, `solrconfig.xml`, `_rest_managed.json`, `elevate.xml`, `synonyms.txt`, etc.
- Preserve indentation and element order; existing files use two spaces where applicable.
- Avoid trailing spaces and BOM in text config files.
- Keep managed resource JSON stable; prefer minimal diffs.
- For XML, keep attributes quoted with double quotes and consistent formatting.
- When editing synonyms/protwords/mapping files, keep one entry per line.
- Reload config after changes via `make reload-config` and re-run tests.
- Do not upgrade Solr versions without coordinating image and config compatibility.
- Update xslt resources carefully; ensure valid XML syntax.
- Maintain newline at EOF for configuration files.
## Data ingestion expectations
- Fixtures in `spec/fixtures` are ingested via `bin/load-data`.
- `cob_index ingest` runs per XML file with `--no-commit` then commits once.
- `SOLR_DISABLE_UPDATE_DATE_CHECK` exported before ingest to bypass update date requirement.
- Ensure new fixtures are small and purposeful; avoid committing real patron data.
- Keep fixture filenames descriptive and lowercase with dashes or plus signs as seen.
- If modifying load script, preserve wait loop for Solr readiness.
- Keep ingest idempotent; avoid deleting collections manually.
## Dependencies and Bundler
- Gemfile includes `cob_index`, `alma`, `lc_solr_sortable`, `rsolr`, `rspec`, `rubocop`, `pry-rails`.
- `cob_index` pinned to tag v0.16.4; coordinate updates with indexing behavior.
- `lc_solr_sortable` pulled from main branch; check compatibility before updates.
- Do not edit Gemfile.lock outside container per README guidance.
- Use `bundle update [gem]` inside `make tty-app` if gems change.
- Respect bundler path /app/vendor/bundle to avoid permissions issues.
- Avoid adding system-level dependencies; prefer Ruby gems or container packages.
## CI/CD notes
- GitHub Actions workflows: `.github/workflows/test.yml` and `deploy.yml`.
- Test workflow runs lint and docker-based relevancy tests on pushes (excluding main).
- Deploy workflow triggers on tags; builds `solrconfig.zip` and uploads to SolrCloud and release assets.
- Deployment script uses curl with SOLR_USER/SOLR_PASSWORD secrets; do not hardcode credentials.
- Keep zip manifest in deploy script updated if new config files are added.
- Ensure tests pass before tagging releases; main merges alone do not deploy.
- Slack notifications on failure via reusable workflow `tulibraries/.github`.
## Git and process
- Keep changes focused; avoid unrelated formatting churn in large XML files.
- Prefer small, reviewable PRs describing Solr behavior impact.
- Update README if command or workflow changes.
- Do not commit secrets or environment files.
- Adhere to existing license; no new headers needed.
- Use meaningful commit messages; reference related tickets if applicable.
- When modifying configs, describe impact on search/relevancy in PR summary.
## Documentation and communication
- Record non-obvious decisions in AGENTS.md or README to aid future agents.
- When adding new AGENTS.md in subdirs, note its scope clearly.
- Mention any required manual steps (e.g., reindex) in PRs.
- Provide reproduction steps for test failures or regressions.
- If unsure about Solr fields, inspect schema.xml and existing tests before changing.
- Prefer updating tests alongside config changes to capture expected behavior.
## Final reminders
- Run lint and tests inside containers before handing off unless instructed otherwise.
- Keep instructions synced with `.rubocop.yml`, docker-compose.yml, and Makefile.
- Respect system rule: do not inspect environment variables without asking.
- Keep this file around ~150 lines; update as repo evolves.
