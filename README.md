# Aunjai
An AI powered mobile app for detecting online scams in order to warn the user and provide information for dealing with scamers with such scamming methods. **The app is only developped for Android at the moment**.

> [!IMPORTANT]
> TO DEVS! PLEASE CONNECT API TO TS BC IDK HOW TO!!

> [!Note]
> This repository only contains **The Application Part** of the project!

## Modes
### 1. Message Mode
Allows the user to paste scammer's messages from SMS or chatting application, such as Line, Facebook Messenger, Instagram, etc. into the app. The AI will then analyze the message, and return how likely it maybe a scam.

### 2. Image Mode
Allows the user to upload multiple images onto the app, which the AI will analize whether it's likely to be a scam or not.

### 3. Quick Mode / Call Mode
The app will ask the user about the scammer's behaviour, which the user can answer the question in real time. The question may be multiple choices or a text answer. After a set amount of question, or if the AI is absolutely sure about the analysis, it'll then give the user the percentage of the probablity of it being a scammer.

## Scoring Criteria
### 1. Identity Risk — 50% 
- Pretending to be a Government Worker or an Organization
- Using fake name, organization, or rank as facade
- Mismatching phone number or social media / Line account.

### 2. Action & Request Risk — 50%
- Asking for sensitive informations
- Demanding the user to transfer money

Each criteria has a full score of 100%, which will then be weigh down before averaging to the final 100%, for example:
| Criteria | Weight | Score |
| -------- | ------ | ----- |
| Identity Risk | 50% | 80% |
| Action & Request Risk | 50% | 70% |
| Final Score | 100% | 75% |

## Reporting Results
After reviewing the results given by the AI, the user can choose to report the results / threat to the government database. They can choose to specify the following information to make tracking easier for the government.
### 1. Method of Scam (Required)
- Telephone Call
- Chats
- Social Network
- E-mail
- Images
### 2. Provinces (Optional)
The user can choose to specify the province from 77 provinces of Thailand.
### 3. Remarks (Optional)
Remarks as paragraph text

## Government Portal
All reports will be summarized into statistics, displayed on the government portal. It'll be filtered into types of scam, method of scams, time reported, and provinces reported from. Take a look at the [Aunjai Government Portal](https://github.com/craned-project/AunjaiGovPortal) (Currently Private) here!


*มีอุ่นใจ อุ่นใจปลอดภัยแน่นอน*<br>
*With Aunjai, Both safety and peace of mind are guaranteed.*
