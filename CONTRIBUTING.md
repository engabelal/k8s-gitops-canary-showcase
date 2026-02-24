# Contributing to K8s GitOps Canary Showcase

Thank you for your interest in contributing! 🎉

## How to Contribute

### Reporting Issues

- Check existing issues before creating a new one
- Provide clear description and steps to reproduce
- Include environment details (K8s version, ArgoCD version, etc.)

### Suggesting Enhancements

- Open an issue with the `enhancement` label
- Describe the feature and its benefits
- Provide examples if possible

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Make your changes
4. Test thoroughly
5. Commit with clear messages: `git commit -m 'feat: add amazing feature'`
6. Push to your fork: `git push origin feature/amazing-feature`
7. Open a Pull Request

## Commit Message Convention

Follow conventional commits:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

Examples:
```
feat: add Prometheus monitoring integration
fix: correct traffic weight calculation
docs: update setup instructions for EKS
```

## Code Style

- Use consistent YAML formatting (2 spaces indentation)
- Add comments for complex configurations
- Follow Kubernetes best practices
- Keep manifests simple and readable

## Testing

Before submitting:

1. Test on a local Kubernetes cluster
2. Verify ArgoCD sync works correctly
3. Test traffic distribution
4. Check all documentation links

## Documentation

- Update README.md if adding features
- Add comments in YAML files
- Update CHANGELOG.md
- Include examples where helpful

## Questions?

Feel free to open an issue for any questions!

---

**Thank you for contributing!** 🙏
