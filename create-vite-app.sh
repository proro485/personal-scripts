#!/bin/sh

read -p "Project name: " project_name

# if a folder with the same name already exists, exit
if [ -d $project_name ]; then
    echo "🔴 Folder with the same name already exists"
    exit 1
fi

echo "🤖  Checking if Yarn is installed..."
if ! command -v yarn >/dev/null 2>&1; then
  echo "🔴 Yarn is not installed. Installing yarn..."
  sudo npm install -g yarn
fi  

echo "✅ Yarn is installed. Using vite to create the project..."

yarn create vite $project_name

echo "🤖  Going into the project directory..."
cd $project_name

echo "🔴 Installing dependencies..."
yarn install

echo "🤖 Setting up tailwindcss..."
yarn add -D tailwindcss postcss autoprefixer prettier prettier-plugin-tailwindcss

yarn tailwindcss init -p

config='/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.{vue,js,ts,jsx,tsx}"],
  theme: {
    extend: {},
  },
  plugins: [],
};'

configType='tailwind.config.js'

if [ -f tailwind.config.js ]; then
  echo "🤖  Replacing content in tailwind.config.js..."
  echo "$config" > tailwind.config.js
elif [ -f tailwind.config.cjs ]; then
  echo "🤖  Replacing content in tailwind.config.cjs..."
  configType='tailwind.config.cjs'
  echo "$config" > tailwind.config.cjs
fi


tailwindDirectives='@tailwind base;
@tailwind components;
@tailwind utilities;'

if [ -f src/index.css ]; then
  echo "🤖  Adding tailwind directives to index.css..."
  echo "$tailwindDirectives" > src/index.css
fi

rm src/App.css & rm -rf src/assets

app='const App = () => {
  return (
    <div className="flex min-h-screen items-center justify-center">App</div>
  );
};

export default App;'

if [ -f src/App.js ]; then
  echo "🤖  Replacing content in src/App.js..."
  echo "$app" > src/App.js
elif [ -f src/App.tsx ]; then
  echo "🤖  Replacing content in src/App.tsx..."
  echo "$app" > src/App.tsx
elif [ -f src/App.jsx ]; then
  echo "🤖  Replacing content in src/App.jsx..."
  echo "$app" > src/App.jsx
fi


mkdir src/components

# print the action we are about to do with emojis
git init
git add .
git commit -m "Initial react + tailwind setup"

echo "✅ Git repo initialized and you are ready to go!"