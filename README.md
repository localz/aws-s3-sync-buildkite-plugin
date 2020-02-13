# AWS S3 Sync Buildkite Plugin

A [Buildkite plugin] that syncs files to S3.   
When run it will sync the source folder to two folders at the destination - one named with the version number defined in the `package.json` file and the other named `latest`.

### Path example
`destination: s3://bucket_name/service_name/blue`   
The above configuration would sync files to:
`s3://bucket_name/service_name/blue/<VERSION_NUMBER>`   
`s3://bucket_name/service_name/blue/latest`

The `latest` folder is mapped to our green environment in CloudFront and the `version` folder gives us the ability to roll back a deployment quickly if needed.

To use this plugin you MUST have a `package.json` file in the root of your repository.

## Plugin configuration xample

```yml
steps:
  - label: "Generate files and push to S3"
    command: npm build
    plugins:
      - localz/aws-s3-sync#v0.1.0:
          source: src/
          destination: s3://bucket_name/service_name/blue
```

## Configuration

### `source` (required)
The source directory containing the files to sync to S3.

### `destination` (required)
The S3 URI describing where to sync the files to.

### `acl` (optional)
The S3 ACL to apply to all synced files (ie. `public-read`)

[Buildkite plugin]: https://buildkite.com/docs/agent/v3/plugins