# binary2sh

> This is `posix shell` version of
> [binary2npm](https://github.com/dalisoft/binary2npm)

Prepare execution script for linking binaries from other tools/languages

Currently supports only **GitHub API**

## Installation

```sh
npm install dalisoft/binary2sh
# or
yarn install dalisoft/binary2sh
# or
bun add dalisoft/binary2sh
```

## No-installation method

> Replace `jsona` with your repository

```sh
npx --yes dalisoft/binary2sh --repository=jsona/jsona --name=jsona
# or
bunx dalisoft/binary2sh --repository=jsona/jsona --name=jsona
# or
curl -fsSL https://raw.githubusercontent.com/dalisoft/binary2sh/master/bin-dl.sh | sh /dev/stdin --repository=jsona/jsona --name=jsona
```

## Environment variables

| Name           | Description                                                                                     | Required |
| -------------- | ----------------------------------------------------------------------------------------------- | -------- |
| `GITHUB_TOKEN` | For [GitHub API](https://docs.github.com/rest/overview/resources-in-the-rest-api#rate-limiting) | Yes      |

## Options

| Name         | Description       | Required |
| ------------ | ----------------- | -------- |
| `repository` | GitHub repository | Yes      |
| `name`       | Binary name       | Yes      |
| `version`    | Binary version    | No       |

## Usage

> Replace `jsona` with your repository

```sh
bin-dl --repository=jsona/jsona --name=jsona --version=v0.6.0
```

## License

Apache-2.0
