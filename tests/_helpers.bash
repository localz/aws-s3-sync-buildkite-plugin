# creates a dummy package.json
npm_init() {
    if [ $# -eq 0 ]; then
    cat > package.json <<EOF
{
    "name": "aws-s3-sync-buildkite-plugin",
    "version": "1.0.0",
    "main": "index.js",
    "repository": "https://github.com/localz/aws-s3-sync-buildkite-plugin.git",
    "author": "SRE <sre@localz.co>",
    "license": "MIT"
}
EOF
    else
    mkdir -p "client/"
    cat > "${1}" <<EOF
{
    "name": "aws-s3-sync-buildkite-plugin",
    "version": "1.0.0",
    "main": "index.js",
    "repository": "https://github.com/localz/aws-s3-sync-buildkite-plugin.git",
    "author": "SRE <sre@localz.co>",
    "license": "MIT"
}
EOF
    fi
}

npm_rm() {
    if [ $# -eq 0 ]; then
        rm -f package.json
    else
        rm -rf "client/"
    fi
}