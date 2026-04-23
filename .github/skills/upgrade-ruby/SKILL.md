name: upgrade-ruby
description: 'Update Ruby version in the kaminari-api-meta-data gem repo. Run after /upgrade-ruby-setup has checked out main and created the upgrade branch. Updates .ruby-version and the GitHub Actions CI matrix.'
argument-hint: '<new-version> (e.g. 4.1.0)'
---

# Upgrade Ruby — kaminari-api-meta-data

## Prerequisites
Run `/upgrade-ruby-setup` first to install Ruby via rbenv and create the upgrade branch.

## Required Inputs
- **New version** (e.g. `4.1.0`)

---

## Procedure

### 1. Read the current version and update `.ruby-version`

Before making changes, capture the current version from `.ruby-version`:

```bash
CURRENT_VERSION=$(cat .ruby-version)
```

File: `.ruby-version` — set to `<new-version>` (bare version string only).

### 2. Update GitHub Actions CI matrix

File: `.github/workflows/ci.yml` — only update the Ruby version matrix for **major/minor** upgrades (for example `4.0` -> `4.1` or `3.4` -> `4.0`).

For **patch-only** upgrades (for example `4.0.1` -> `4.0.2`), do not change the matrix.

When a matrix update is needed, add `<new-version>` (or the matching major/minor entry used in that file). Old versions can remain for compatibility.

### 3. Update `ruby/setup-ruby` pin

File: `.github/workflows/ci.yml` — update to the latest `v1` SHA:

```bash
LATEST=$(curl -s "https://api.github.com/repos/ruby/setup-ruby/commits/master" | python3 -c "import sys,json; print(json.load(sys.stdin)['sha'])")
sed -i '' "s#ruby/setup-ruby@[a-f0-9]*#ruby/setup-ruby@${LATEST}#g" .github/workflows/ci.yml
```

### 4. Re-bundle

```bash
bundle update --bundler
bundle install
```

### 5. Fix Appraisals lock file versions

The `gemfiles/*.lock` files will have the bundler version pinned to an old version. Update them to match the bundler version in the root `Gemfile.lock`:

```bash
BUNDLER_VERSION=$(grep -A1 'BUNDLED WITH' Gemfile.lock | tail -1 | xargs)
find gemfiles -name "*.lock" -exec sed -i '' "/BUNDLED WITH/,+1s/[0-9.]*/${BUNDLER_VERSION}/" {} \;
```

### 6. Regenerate Appraisals gemfiles

After updating `.ruby-version` and fixing lock file versions, regenerate the gemfiles so they reflect the new Ruby version:

```bash
bundle exec appraisal install
```

This updates the auto-generated files in `gemfiles/`. Commit these alongside the other changes.

### 7. Verify

```bash
grep -r "$CURRENT_VERSION" \
  --include="*.yml" --include=".ruby-version" \
  .
```

### Files that do NOT need changes

- `Gemfile` — no Ruby pin
- `kaminari_api_meta_data.gemspec` — floor constraint only
- `Appraisals` — ActiveRecord-version variation only; do not edit directly
