# Godot SFX Library Editor
SFX Library Editor aims to give a simple GUI in the bottom panel for managing a projects AudoStream SFX. Drag n Drop Functionality allows for multiple resources at once to be dropped and loaded into the library.


# How To Install
Download the SFX Editor and create a "addons" folder in your res:// file system, in your Godot project (if one doesn't already exist). Put the SFX Editor folder into the addons folder.
Navigate to Project -> Project Settings -> Plugins -> Enable SFX Library Editor.


# How To Uninstall
Navigate to Project -> Project Settings -> Plugins -> Disable SFX Library Editor.
Delete the SFX Editor Folder from Res://addons

# How To Use
Create a new resource of Type SFX Library.
When clicking the resource the SFX Library Editor will auto open in the bottom panel.

# Main Controls
* New SFX Tag -> Adds a new SFX Tag to the SFX Library as a key using the supplied tag from the Line Edit input. If no tag is supplied, no tag will be created.
* Delete SFX Tag -> Deletes a selected SFX Tag.
* Delete SFX -> Deletes a selected SFX from the selected SFX Tag.
* Line Edit -> Text Edit to supply a SFX Tag.
* Drag n Drop -> Drag AudoStream files into the Editor and drop them to load them into the selected tag. Multiple files can be dropped at once.
* Play -> Plays the selected audio stream.
* Pause -> Pauses the selected audio stream.
* Restart -> Restarts the selected audio stream.


# Aquiring SFX Data From SFX Library
To aquire the sfx data from the library, you will need a reference to the specific library and simply access it as a dictionary.
library_name.sfx_library.get(tag)[id]
