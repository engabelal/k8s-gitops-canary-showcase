# Changelog

All notable changes to this project will be documented in this file.

## [2.0.1] - Canary Version

### Added
- Canary deployment with orange/amber theme
- 40% traffic weight allocation
- Single replica for testing

### Changed
- Updated version display to v2.0.1
- Modified color scheme for visual distinction

## [1.0.0] - Stable Version

### Added
- Initial stable deployment with green theme
- 60% traffic weight allocation
- Two replicas for high availability
- Glassmorphism UI design
- Version and traffic weight metrics display

## Project Restructure

### Added
- Professional directory structure
- Comprehensive documentation
- Setup and testing scripts
- MIT License
- .gitignore file
- Multiple README files for each component

### Changed
- Reorganized manifests into logical folders
- Simplified naming convention (stable/canary instead of v1-stable/v2-canary)
- Unified label schema across all resources
- Updated ArgoCD configurations with new paths

### Removed
- Old directory structure (argocd-apps, manifests)
- Inconsistent labels and naming

---

## Version Tags

- `v1.0.0` - Stable version (green theme, 60% traffic)
- `v2.0.1` - Canary version (orange theme, 40% traffic)
