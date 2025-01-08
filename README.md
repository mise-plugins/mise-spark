<div align="center">

# mise-spark [![Build](https://github.com/benberryallwood/mise-spark/actions/workflows/build.yml/badge.svg)](https://github.com/benberryallwood/mise-spark/actions/workflows/build.yml) [![Lint](https://github.com/benberryallwood/mise-spark/actions/workflows/lint.yml/badge.svg)](https://github.com/benberryallwood/mise-spark/actions/workflows/lint.yml)

[Apache Spark](https://spark.apache.org/documentation.html) plugin for the [mise version manager](https://mise.jdx.dev).

</div>

## Contents

- [Dependencies](#dependencies)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Dependencies

- `bash`, `curl`, `tar`, and [POSIX utilities](https://pubs.opengroup.org/onlinepubs/9699919799/idx/utilities.html)
- `Java 8/11/17` - see [Spark docs](https://spark.apache.org/docs/latest/)

## Usage

### Add plugin

```bash
mise plugins install spark https://github.com/benberryallwood/mise-spark
```

### List and set Spark versions

This is currently slow, so may require increasing the [fetch_remote_versions_timeout](https://mise.jdx.dev/configuration/settings.html#fetch_remote_versions_timeout) setting:

```bash
# As mise setting
mise settings set fetch_remote_versions_timeout 30s

# As environment variable
export MISE_FETCH_REMOTE_VERSIONS_TIMEOUT=30s
```

Apache provide various distributions, including/excluding Hadoop, supporting different Scala versions, etc.

> [!IMPORTANT]
> `mise ls-remote spark` lists all installable versions, some of which may not be installable on your machine

`mise latest spark` gives the short version, so by combining the two you can find a suitable version.
Unless you know otherwise, you probably want the version including `hadoop` with no Scala version specified.

```bash
# Get all versions for the latest stable release
mise ls-remote spark | grep $(mise latest spark)

# Install specific version
mise install spark@3.5.4-bin-hadoop3

# Set a version globally (on your ~/.config/mise/config.toml file)
mise use --global spark@3.5.4-bin-hadoop3

# Now spark commands are available
spark-shell --help
```

Check [mise](https://mise.jdx.dev) docs for more instructions on how to install & manage versions.

### Using provided scripts

If you wish to use Spark scripts provided in `sbin/`, such as [Spark Connect](https://spark.apache.org/docs/latest/api/python/getting_started/quickstart_connect.html), you can do so with `mise where`:

```bash
$(mise where spark)/sbin/start-connect-server.sh --help
```

## Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/benberryallwood/mise-spark/graphs/contributors)!

Thanks also to the [asdf-spark](https://github.com/joshuaballoch/asdf-spark) author and contributors.

## License

See [LICENSE](LICENSE) © [Ben Berry-Allwood](https://github.com/benberryallwood/)
