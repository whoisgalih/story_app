#!/bin/bash

echo "🚀 Starting code generation..."

{{#enableJsonAnnotation}}
echo "📦 Running build_runner for JSON serialization..."
flutter packages pub run build_runner build --delete-conflicting-outputs
{{/enableJsonAnnotation}}

{{#enableLocalization}}
echo "🌍 Generating localization files..."
flutter gen-l10n
{{/enableLocalization}}

echo "✅ Code generation completed!"
echo "🎉 Your {{appName.titleCase()}} is ready!"