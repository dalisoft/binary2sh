# binary2sh

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

> This method not working yet, but soon will be

```sh
curl -fsSLO https://raw.githubusercontent.com/dalisoft/binarh2sh/master/bin-dl.sh | sh
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

```sh
bin-dl --repository=jsona/jsona --name=jsona --version=v0.6.0
```

## License

Apache-2.0
