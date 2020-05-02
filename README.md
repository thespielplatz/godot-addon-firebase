# Firebase Plugin for Godot 3
Godot 3.x Plugin for Firebase

I will implement the features of Google Firebase on the way, as I need them or they are requested by the community

Did you use my code and and it worked without problems? You could ...<br>
<a href='https://ko-fi.com/T6T31O7TS' target='_blank'><img height='36' style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi2.png?v=2' border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>


WIP: https://patreon.com/

### Implementations
- Auth
	- Anonymous Auth

## Install & Configuration

1. Copy the folder **addons/tsp_gp_firebase** to the project path res://addons/
2. Open your Project Settings
3. Go to Plugins
4. Activate the TSP GodotPlugin Firebase
5. From there, you will have an autoload singleton with the variables 

## Creating A Firebase Web App 
1. Create a Firebase App / Guide: [Here](https://firebase.google.com/docs/projects/learn-more#setting_up_a_firebase_project_and_connecting_apps)

2. Once the app has been created, add a web app to it [Here](https://firebase.google.com/docs/web/setup)
	- Only do Step 1 and 2

3. This will show a series of values called "config". These must be set to the plugin as Dictionary

You can save the config as json and load it / Exmaple Code:
```
var file = File.new()
var err = file.open("res://firebase-config.json", file.READ)
var json = file.get_as_text()
var config = parse_json(json)
Firebase.set_config(config)
```
4. Check the section about Firebase Authentification

#### Firebase Authentification 

For **Anonymous Login**: Goto your Firebase Console / Authentication / Sign-In Method and enbale *Anonymous*


## Code Examples

yeah I know / Please check out the sample project!
