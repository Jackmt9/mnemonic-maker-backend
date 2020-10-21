# Mnemonic Maker 🧠 (BACKEND)
This project is designed to create [acrostic mnemonic devices](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.898.2352&rep=rep1&type=pdf) using song lyrics to help users better remember things.

### Table of Contents
- [Features](#features)

- [Getting Started](#getting-started)

- [Tools](#tools)

- [Project Layout](#project-layout)

### Features
- TO BE ADDED

### Getting Started
This project is created in conjunction with this [frontend](https://github.com/Jackmt9/mnemonic-maker-frontend). 

To start the backend server:
1. Clone this repository.
2. Install all dependencies by running ```$ bundle install```
3. Be sure you have a [Postgresql](https://www.postgresql.org/) server running.
4. Create your database table by running ```$ rails db:create```
5. Migrate to set up your database schema by running ```$ rails db:migrate```.
6. Register and receive an authorization token from [Genius](https://docs.genius.com/).
7. Add a ```.env``` file in the root directory that contains ```GENIUS_API_KEY=<YOUR_GENIUS_AUTHORIZATION_TOKEN>```.
8. Run ```$ rails server``` to start your server. 
9. Open your browser and navigate to http://localhost:3001/ to access the backend routes or follow the [frontend README](https://github.com/Jackmt9/mnemonic-maker-frontend/blob/master/README.md).

### Tools
- Ruby on Rails

- ActiveRecord

- Postgresql

- SQL

- Bcrypt

### Project Layout
To view this project outline and domain models, please refer to [Figma](https://www.figma.com/file/FTc7kkD4KNCCM48LuoAGWz/Mnemonic-Maker?node-id=0%3A1).