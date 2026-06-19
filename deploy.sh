#!/bin/bash
set -e

echo "Building Flutter web..."
flutter build web --release --base-href "/sandeep-vats/"

echo "Copying to temp..."
rm -rf /tmp/flutter_web_build
cp -r build/web /tmp/flutter_web_build

echo "Deploying to gh-pages..."
git checkout gh-pages
git rm -rf . --quiet
cp -r /tmp/flutter_web_build/. .
touch .nojekyll
git add .
git commit -m "Deploy $(date '+%Y-%m-%d %H:%M')"
git push origin gh-pages

echo "Switching back to main..."
git checkout main

echo "Done! Site will update at https://hridaya-mohit.github.io/sandeep-vats/ in ~2 minutes."
