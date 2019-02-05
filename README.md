# Landmark Remark

An app that posts geotagged notes on the map

This app demonstrates the following functionality
1. As a user (of the application) I can see my current location on a map
2. As a user I can save a short note at my current location
3. As a user I can see notes that I have saved at the location they were saved on the map
4. As a user I can see the location, text, and user-name of notes other users have saved
5. As a user I have the ability to search for a note based on contained text or user-name

## Solution

I first identified the data models involved in this project, being `User` and `Note` models. 

```
{
    "User" : {
        "userid" : "id",
        "username" : "username",
        "icon" : "icon"
    },
    "Note" : {
        "noteid" : "id",
        "latitude" : "lat",
        "longitude" : "long",
        "notes" : "notes",
        "date" : "date",
        "user" : { \\ user dictionary }
    }
}
```

As the app involved participation of multiple users creating notes within the app, I utilised Firebase platform, in particular, Cloud Firestore as my JSON database persistent store for these simple data models.

The app UI has three parts:
1. Login
    - to simplify the login process, only username was required
    - bird icons can be assigned per user
2. Landmarks Table
    - contains the full list of all users and their notes
    - has the search bar and user filtering capabilities
    - contains a map view showing annotations of the users' notes 
    - logout and new note buttons
3. Add New Note 
    - displays a map of the current user location to where the note will be geotagged

## Effort

13 hours, as extra time was spent on adding minor features and one hour on analyiss and conceptualisation

1. ( 1 hour ) Analysis and conceptualisation of UI, Models, Classes, Views
2. ( 2 hours ) Login Screen
    - creation of User model, User persistence, and User database helpers
3. ( 3 hours ) Add Note
    - creation of Note model and database helpers
    - mapview and textview delegates
4. ( 7 hours ) Landmarks Table
    - creation of note and map view cells
    - mapview, searchbar, user filter
    - creations of custom annotations
    - logout

## Limitations

1. User authentication/identity can be improved by implementing Firebase Authentication 
2. Database helpers can be further improved to store ID's properly, as Cloud Firestore structure generates the document ID on top of the document data
3. Note list retrieval can be further improved by pagination of the results as the number of notes increases
4. Error handling is only through printed console logs, can be further improved by utilising Firebase crashlytics.
5. Unit Test codes not implemented
