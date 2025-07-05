# 🧳 Travel Planner App (UIKit)

A multi-user iOS app for planning trips, saving destinations, and checking real-time weather — built using Swift, UIKit, Core Data, and public APIs.

> I created this as part of a mobile development assignment  
> Features user login, destination browsing, trip management, and more

---

## Features

### Multi-User Login & Signup
- User authentication using **Core Data**
- Separate saved destinations and trips per user

### Destination Browser
- Fetches destinations from an **Express.js API**
- Displays image, name, and category
- Tap to view details

### Destination Details
- Shows full description and image
- Fetches **real-time weather data**
- Add to favorites (stored in Core Data)

### Saved Destinations
- Collection View of user favorites
- Displays image and name
- Option to **unfavorite**

### Trip Planner
- Create trips by selecting destinations
- Set travel mode (Car, Flight, Train)
- View trips in list view with name, date, and destination count
- View/Edit individual trip details

---

## 🛠️ Tech Stack

![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=for-the-badge&logo=swift)
![Xcode](https://img.shields.io/badge/Xcode-UIKit-blue?style=for-the-badge&logo=xcode)
![CoreData](https://img.shields.io/badge/Storage-CoreData-lightgrey?style=for-the-badge)
![Express.js API](https://img.shields.io/badge/API-Express.js-black?style=for-the-badge)
![Weather API](https://img.shields.io/badge/API-Weather-blue?style=for-the-badge)

---

## 📸 Screenshots

| Login                                                                                           | Destination List                                                                                       | Destination Details                                                                                         |
| ----------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------- |
| ![travellogin](https://github.com/user-attachments/assets/da61892d-e3e6-421f-ba00-7134b55c71b1) | ![traveldestinations](https://github.com/user-attachments/assets/0948f07c-1ee3-45e4-8a09-51a2475ff685) | ![traveldestinationdetail](https://github.com/user-attachments/assets/c3f7deeb-8732-4cb5-a565-61fb35d0321f) |
| Favorites                                                                                           | Create Trip                                                                                          | My Trips                                                                                          |
|  |  |  |
| ![travelfavorites](https://github.com/user-attachments/assets/b2ace8bf-7ae4-44ef-aed3-c47bea4107ec) | ![travelcreatetrip](https://github.com/user-attachments/assets/d5fc0e09-9ecf-433c-84cc-3fa2bac52b5d) | ![travelmytrips](https://github.com/user-attachments/assets/04058a08-51db-4d52-a942-ec6363a83720) |
| Trip Details                                                                                            |   |   |
|  | - | - |
| ![travelmytripdetails](https://github.com/user-attachments/assets/7b88127d-7319-49c9-9ce3-4c2bb00aa0dc) |   |   |

---

## Demo Video

[Watch on YouTube](https://www.youtube.com/watch?v=NQtSFJcvmOU)

---

## Notes

- All trip and favorite data are stored locally per user using Core Data.
- Weather is fetched live from the public API during detail view load.
- Followed MVC structure with separation of concerns.

---

## Author

**Kate de Leon**  
Built as part of a college mobile development assessment.

---

