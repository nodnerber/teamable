#! /bin/bash
set -e

echo "=== 1. Ensure Xcode Command Line Tools are installed ==="
if ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Please follow the prompts to install Xcode Command Line Tools."
    exit 1
else
    echo "Command Line Tools already installed."
fi

echo "=== 2. Install Homebrew ==="
if ! command -v brew >/dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew already installed."
fi

echo "=== 3. Install MongoDB ==="
brew tap mongodb/brew
brew install mongodb-community

echo "=== 4. Start MongoDB ==="
brew services start mongodb-community

echo "=== 5. Wait a moment for MongoDB to start ==="
sleep 5

echo "=== 6. Verify MongoDB is running ==="
if ! pgrep -fl mongod >/dev/null 2>&1; then
    echo "MongoDB is not running. Please check the logs for errors."
    exit 1
else
    echo "MongoDB is running."
fi

echo "=== 7. Create initial database, collection, and document ==="
mongosh "mongodb://127.0.0.1:27017" --eval
    const dbName = "company_db";
    const collName = "employees";
    const doc = {
    id: 1,
    name: "John Doe",
    email: "john@example.com",
    interests: "Hiking, reading"
    };

    const db = db.getSiblingDB(dbName);
    const coll = db.getCollection(collName);
    coll.updateOne({id: 1}, {$set: doc}, {upsert: true});
    print('Initialized ${dbName}.${collName} with id:1 document');

echo "=== 8. Summary ==="
echo "MongoDB is running on mongodb://127.0.0.1:27017"
echo "Database: ${dbName}"
echo "Collection: ${collName}"
echo "Document: ${doc}"
echo "Your existing backend connection string in server.js should work now."