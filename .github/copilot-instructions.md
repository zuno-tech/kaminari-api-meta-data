# GitHub Copilot Instructions

## Project-Specific Guidelines

### Ruby Upgrades

Ruby version updates are coordinated across the entire workspace. When upgrading Ruby in this gem:

1. **Reference project-specific workflow** in [ruby-upgrade.instructions.md](ruby-upgrade.instructions.md)
2. Update `.ruby-version` in this gem
3. Update `kaminari_api_meta_data.gemspec` `required_ruby_version` constraint
4. Update `Appraisals` file with new Ruby version in test matrix
5. Run tests locally before pushing

**Current Ruby version:** See `.ruby-version`
