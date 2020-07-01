#!/usr/bin/env bats

load '/usr/local/lib/bats/load.bash'

# Uncomment the following to get more detail on failures of stubs
# export AWS_STUB_DEBUG=/dev/tty

load _helpers

@test "Files synced to bucket locations" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination

  npm_init

  stub aws \
    "s3 sync source/ s3://destination/1.0.0/ --delete : echo sync failed ; exit 0" \
    "s3 sync source/ s3://destination/latest/ --delete : echo sync failed ; exit 0"

  run "$PWD/hooks/post-command"

  npm_rm

  assert_success
  assert_output --partial "sync failed"
  unstub aws
}

@test "Files synced with PACKAGE_JSON set" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_PACKAGE_JSON=client/package.json

  npm_init "${BUILDKITE_PLUGIN_AWS_S3_SYNC_PACKAGE_JSON}"

  stub aws \
    "s3 sync source/ s3://destination/1.0.0/ --delete : echo sync failed ; exit 0" \
    "s3 sync source/ s3://destination/latest/ --delete : echo sync failed ; exit 0"

  run "$PWD/hooks/post-command"

  npm_rm "${BUILDKITE_PLUGIN_AWS_S3_SYNC_PACKAGE_JSON}"

  assert_success
  assert_output --partial "sync failed"
  unstub aws
}

@test "Files synced with SYNC_ACL set" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_ACL=public-read

  npm_init

  stub aws \
    "s3 sync source/ s3://destination/1.0.0/ --delete --acl public-read : echo sync failed ; exit 0" \
    "s3 sync source/ s3://destination/latest/ --delete --acl public-read : echo sync failed ; exit 0"

  run "$PWD/hooks/post-command"

  npm_rm

  assert_success
  assert_output --partial "sync failed"
  unstub aws
}

@test "Files synced with SUB_DIRECTORY set" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SUB_DIRECTORY=subdir

  npm_init

  stub aws \
    "s3 sync source/ s3://destination/1.0.0/subdir --delete : echo sync failed ; exit 0" \
    "s3 sync source/ s3://destination/latest/subdir --delete : echo sync failed ; exit 0"

  run "$PWD/hooks/post-command"

  npm_rm

  assert_success
  assert_output --partial "sync failed"
  unstub aws
}

@test "Files synced with CACHE_CONTROL set" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_CACHE_CONTROL=max-age=86400

  npm_init

  stub aws \
    "s3 sync source/ s3://destination/1.0.0/ --delete --cache-control max-age=86400 : echo sync failed ; exit 0" \
    "s3 sync source/ s3://destination/latest/ --delete --cache-control max-age=86400 : echo sync failed ; exit 0"

  run "$PWD/hooks/post-command"

  npm_rm

  assert_success
  assert_output --partial "sync failed"
  unstub aws
}

@test "Don't sync if package.json is missing" {
  export BUILDKITE_COMMAND_EXIT_STATUS=0
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination

  run "$PWD/hooks/post-command"

  assert_failure
}

@test "Don't sync files if the step command fails" {
  export BUILDKITE_COMMAND_EXIT_STATUS=1
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_SOURCE=source/
  export BUILDKITE_PLUGIN_AWS_S3_SYNC_DESTINATION=s3://destination

  run "$PWD/hooks/post-command"

  assert_success
}
