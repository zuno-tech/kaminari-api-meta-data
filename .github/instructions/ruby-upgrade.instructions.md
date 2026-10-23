---
applyTo: "ruby-upgrade-kaminari"
---

# Ruby Version Upgrade — kaminari-api-meta-data

This document covers updating Ruby in the kaminari-api-meta-data gem repository.

**Current version:** See `.ruby-version`

**Target:** Update to the latest stable Ruby version.

The following must support the target Ruby version:

* [ruby-build](https://github.com/rbenv/ruby-build)
* [ruby/setup-ruby](https://github.com/ruby/setup-ruby)

## Files to Update

### 1. `.ruby-version` File

```bash
.ruby-version
```

### 2. `kaminari_api_meta_data.gemspec`

Leave `required_ruby_version` unchanged unless dropping support for a minor series. It is the oldest Ruby consumers may use, not the development version.

### 3. Update `ruby/setup-ruby` Pin

Pin `.github/workflows/ci.yml` to the latest release commit, not `master`. The trailing comment records the tag:

```bash
TAG=$(curl -s "https://api.github.com/repos/ruby/setup-ruby/releases/latest" | python3 -c "import sys,json; print(json.load(sys.stdin)['tag_name'])")
SHA=$(curl -s "https://api.github.com/repos/ruby/setup-ruby/commits/${TAG}" | python3 -c "import sys,json; print(json.load(sys.stdin)['sha'])")
perl -pi -e "s|ruby/setup-ruby\@[a-f0-9]{40}.*|ruby/setup-ruby\@${SHA} # ${TAG}|" .github/workflows/ci.yml
```

The CI matrix lists minor series (e.g. `"4.0"`). Add an entry only for a new minor series; a patch upgrade needs no change.

### 4. Update Lockfiles

Pass the latest stable Bundler version (`gem search '^bundler$' --remote`). Plain `--bundler` uses the newest installed Bundler, which may be a prerelease:

```bash
bundle update --bundler=X.Y.Z
for g in gemfiles/*.gemfile; do BUNDLE_GEMFILE="$PWD/$g" bundle update --bundler=X.Y.Z; done
```

Bundler also adds your local platform (e.g. `arm64-darwin-27`) to the lockfiles. That is expected.

Do not run `bundle exec appraisal install` for a Ruby upgrade. It regenerates `gemfiles/*.gemfile` from the current `Gemfile` and `Appraisals`, which pulls in unrelated dependency changes and can fail to resolve or build older ActiveRecord appraisals. Run it only when `Gemfile` or `Appraisals` change.

## Testing

```bash
ruby -v # Must print the target version. An exported RBENV_VERSION overrides .ruby-version.
bundle install # Verify dependencies resolve
bundle exec rubocop # Lint code
bundle exec appraisal rspec # Run tests across ActiveRecord versions
```
