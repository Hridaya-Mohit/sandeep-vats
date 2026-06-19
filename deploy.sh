#!/bin/bash
set -e

echo "Building Flutter web..."
flutter build web --release --base-href "/"

echo "Copying to temp..."
rm -rf /tmp/flutter_web_build
cp -r build/web /tmp/flutter_web_build

echo "Deploying to gh-pages..."
git checkout gh-pages
git rm -rf . --quiet

# Copy only the web build files
cp -r /tmp/flutter_web_build/. .

# Essential files for GitHub Pages
touch .nojekyll
echo "sandeepvats.com" > CNAME

# Gitignore to prevent source files being committed
cat > .gitignore << 'EOF'
.dart_tool/
build/
.idea/
android/
ios/
linux/
macos/
windows/
lib/
test/
*.dart
*.yaml
*.iml
EOF

git add .
git commit -m "Deploy $(date '+%Y-%m-%d %H:%M')"
git push origin gh-pages

echo "Switching back to main..."
git checkout main

echo "Done! Site live at https://sandeepvats.com in ~2 minutes."
