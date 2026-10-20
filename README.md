# MediaPad App

## Summary

MediaPad was initially created as a final project for a Mobile App Development class. MediaPad allows user to search and make lists of books, as well as set reading goals they can view on a dashboard. This app is built in Dart/Flutter and the app includes sign up/log in functionality via Firebase, as well as cloud storage via Firestore.

## Set Up Instructions

For the project to run, you need to put the `.env` file with the API Key into the `assets` folder so the directory is as such: `assets/.env` (not provided in public version).

## Project Checklist

### User Authentication

- [x] User authentication is handled on the cloud via **Firebase**. Sign in is through email and password.

### Data

- [x] User data is fetched properly to the app
- [x] User Book data is stored on **Firestore**
- [x] Google Books API is implemented
- [ ] User Movie data is stored on **Firestore**
- [ ] OMDb (Movie) API is implemented

#### Models

- [x] Book model is complete
- [ ] Movie model is complete

### General Functionality

- [x] User can register, log in, and log out
- [x] User can view their list of Books
- [x] User can add, edit and delete Books in the app
- [x] User can search for Books
- [ ] User can view their list of Movies
- [ ] User can add, edit and delete Movies in the app
- [ ] User can search for Movies

#### Pages

- [x] Home page complete
- [x] Dashboard page complete
- [x] Book List page complete
- [x] Book Details page complete
- [x] Book Search page complete
- [ ] Movie List page complete
- [ ] Movie Details page complete
- [ ] Movie Search page complete
- [x] Goals page complete (now pop, not a page)

#### Styling

- [x] Global styling is complete

#### Documentation/User Guide

- [ ] Documentation is written
