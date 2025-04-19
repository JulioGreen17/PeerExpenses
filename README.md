# Xpense

## Table of Contents

1. [Overview](#Overview)
2. [Product Spec](#Product-Spec)
3. [Wireframes](#Wireframes)
4. [Schema](#Schema)

## Overview

### Description

**Xpense** is an expense tracking app.
<div>
    <a href="https://www.loom.com/share/3a434ec256034ffda2e4d654b14f7f5f">
      <img style="max-width:300px;" src="https://cdn.loom.com/sessions/thumbnails/3a434ec256034ffda2e4d654b14f7f5f-b4d89fd646d5055e-full-play.gif">
    </a>
  </div>

### App Evaluation

- **Category:** Finance
- **Mobile:** Yes, it is a mobile application only
- **Story:** You’re juggling bills, subscriptions, savings goals, maybe even debt. We get it. Our app helps you cut through the noise and actually see your money clearly and simply.
- **Market:** General audience
- **Habit:** Daily use
- **Scope:** Narrow

## Product Spec

### 1. User Stories (Required and Optional)
> [!NOTE]
> Completed user stories have been crossed out

**Required Must-have Stories**

* ~~User can track their expenses~~
* ~~User can view home page (with home icon/button at the bottom)~~
* ~~User can add expenses/etc. by pressing the Plus (**+**) icon/button at bottom~~
* ~~User can sign up for an account~~
* ~~User can log into an account~~

**Optional Nice-to-have Stories**

* ~~User can choose between light and dark mode~~
* ~~User can view generated graphs based on their data~~
* User can view calendar or something to show spending per week, month, etc.
* User can view daily/weekly/etc. tips providing useful financial advice, etc.
* ~~User can view and modify profile and/or settings page (also has icon/button at bottom)~~
* User can login to account with ocal authentication framework (i.e. Local FaceID/Biometric Login)
* User can view notifications page/tab (also has icon/button at bottom)
* ~~User can separate expenses by category (e.g. food/drink, traveling, entertainment, bills/taxes, etc.)~~
* User can scan/upload image of receipt to add receipt data to expenses (i.e. automated receipt capture)
* ~~User can view overview page with [circle] graphs displaying expenses (also has icon/button at bottom)~~
* ~~User can track and see how expenses differ from one week/month/etc. to another (e.g. mean expenses on food, gas, etc.)~~
* User can create budgets and keep track of them/notify when the budget is exceeded or close to being exceeded
* User can use tags feature; similar to categories, except users can define the tag

### 2. Screen Archetypes

- [x] **Login Screen/Sign Up**
* User can log in
* User can sign up
- [x] **Home Screen**
* User can view transactions
- [x] **User Screen**
* User can view and edit username
* User can view and edit email
* User can view and edit password
- [x] **Expense Screen**
* User can add expenses (name, amount, category)
- [x] **Graph Screen**
* User can view expenses in different forms of data (graph, line graph, chart)
  
### 3. Navigation

**Tab Navigation** (Tab to Screen)

- [x] Home Page
- [x] Graph Page
- [x] User Page
- [x] Expense Page
- [x] Logout

**Flow Navigation** (Screen to Screen)

- [x] **Home Page**
  * Leads to **Sign-in Page**
  * Leads to **User Page**
  * Leads to **Expense Page**
  * Leads to **Graph Page**
- [x] **Sign-in Page**
  * Leads to **Home Page**
  * Leads to **Sign up Page**
- [x] **Sign-up Page**
  * Leads to **Home Page**
- [x] **User Page**
  * Leads to **Sign-in Page**
  * Leads to **Home Page**
  * Leads to **Expense Page**
  * Leads to **Graph Page**
- [x] **Expense Page**
  * Leads to **Home Page**

## Wireframes
**Light Mode**
![image](https://github.com/user-attachments/assets/6b7de888-6acd-4e77-bc14-a9b917a34772)

**Dark Mode**
![image](https://github.com/user-attachments/assets/ba3fda52-046e-45d8-b0ba-40947997ffed)

## Schema 

### Models

#### Expense Model
| Property  | Type   | Description                                  |
|-----------|--------|----------------------------------------------|
| id        | String | unique id associated with expense            |
| name      | String | name of expense                              |
| amount    | Double | expense price (usd)                          |
| category  | String | expense category (e.g. food, etc.)           |
| timestamp |  Date  | timestamp containing date                    |
| username  | String | username associated with the expense         |

#### User Model
| Property | Type   | Description                                  |
|----------|--------|----------------------------------------------|
| email    | String | user's email                                 |
| password | String | user's password for login authentication     |

### Networking

- `[GET] /users` - to retrieve user data
- `[GET] /expenses` - to retrieve expense data
- `[POST] /users` - to save user data
- `[POST] /expenses` - to save expense data
