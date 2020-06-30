# AWS S3 Sync Buildkite Plugin

A [Buildkite plugin] that syncs files to S3.   
When run it will sync the source folder to two folders at the destination - one named with the version number defined in the `package.json` file and the other named `latest`.

The `latest` folder is mapped to our green environment in CloudFront and the `version` folder gives us the ability to roll back a deployment quickly if needed.

To use this plugin you MUST have a `package.json` file in the root of your repository.

## Plugin configuration example

```yml
steps:
  - label: "Generate files and push to S3"
    command: npm build
    plugins:
      - localz/aws-s3-sync#v0.1.3:
          source: src/
          destination: s3://bucket_name/service_name/blue
```

The above configuration would sync all files in the `src/` directory to:
`s3://bucket_name/service_name/blue/<VERSION_NUMBER>` and `s3://bucket_name/service_name/blue/latest`

Note: by default the process will delete all the files from destination that don't exist in source.

## Configuration

### `source` (required)
The source directory containing the files to sync to S3.

### `destination` (required)
The S3 URI describing where to sync the files to.

### `acl` (optional)
The S3 ACL to apply to all synced files (ie. `public-read`)

### `package_json` (optional)
The relative to root path to `package.json` file if it isn't in the root dir (ie. `server/package.json`)

### `cache_control` (optional)
Specify caching behaviour for S3 objects (ie. `max-age=3600`)

### `sub_directory` (optional)
Specify a sub directory to deploy to (ie. `register`)

[Buildkite plugin]: https://buildkite.com/docs/agent/v3/plugins
