# Logbook

## Installing

1) Clone the repository with `git clone github.com/focus172/logbook`
2) Email estokdyk1@hwemail.com asking for the `GoogleService-Info.plist` and put it in the directory `~/logbook/logbook`. MAKE SURE WHEN YOU COMMIT TO NOT PUSH THIS FILE.
3) Run the Logbook.xcworkspace. If you run the .xcodeproj **it will not work**.
4) Press the play button and wait for the code to compile.

If you are getting something that says that something with google in the name doesn't exist then try this:

5) Install [cocoapods](https://cocoapods.org/).
6) Run 'pod install' withing the directory of the project. You will see some warning but should get a message the says it completed.
7) Restart xcode and try again.

## Project Structure

At this point there is 2_000+ lines of code with 70_000+ characters. There is no way I can keep a complete structure of the project so I will do my best to focus on sections at a time. This means that patches to very niche problems might come slowly but I will do my best. 

If you would like to contribute you can do anything on the todo list (which will get much more specific once their is a stable build). Create a PR and I will merge it.

### TODO

- Data Query Efficency
- UI improvments
- Login Failure Feedback

### Sample Accounts

If you would like to test the code (or the app) feel free to use on of these testing accoutns

- U: test1@mail.com P: password
- U: a@a.com P: aaaaaa
