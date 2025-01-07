# Contributing

Testing Locally:

```shell
# link the plugin
mise plugins link --force "${PWD}"

mise --verbose x spark@latest -- spark-shell --version
```

Tests are automatically run in GitHub Actions on push and PR.
