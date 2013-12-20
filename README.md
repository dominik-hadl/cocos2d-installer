![cocos2d-iphone](https://raw.github.com/cocos2d/cocos2d-iphone/develop-v3/templates/Support/Base/base_ios.xctemplate/Resources/Icons/Icon-76@2x.png)  
cocos2d-installer
=================
This is an installer for the popular [cocos2d](http://www.cocos2d-iphone.org cocos2d-iphone) game development framework. It installs all the required files, templates and documentation into Xcode from the Github repo. It can also uninstall or update the files.  

[![Build Status](https://travis-ci.org/nickskull/cocos2d-installer.png?branch=master)](https://travis-ci.org/nickskull/cocos2d-installer)
## Requirements

* Mac OS X 10.7 (Lion) and up
* Xcode 4.0 and up
* Some app/game ideas (otherwise cocos2d has no use for you!)

## How to install?
For now, there is only this repository from where you can build the installer, however there should be a direct download of the installer in the future - I just need to figure out where it will be hosted. The installer itself should have ~7MB and installation is as easy as double clicking on the icon and then continuing according to installer instructions.

#### Compiling installer from source
Follow this steps to compile and run the installer from the source code. 

1. Download the installer ([zip](https://github.com/nickskull/cocos2d-installer/archive/master.zip as a zip), preferably)
2. Extract it by double clicking on the downloaded file
3. Open the Xcode project file called `cocos2d Installer.xcodeproj` in Xcode
4. Press Run and continue with steps in the [Installing](#installing) section

#### Installing
Follow this steps to easily install the cocos2d framework and templates.  

1. Double click on the installer to open it (if not already opened).
2. You should see information about your current installation on the first view. When ready press **Continue**.
3. On the *What to install?* view you can check if you also want to install the documentation (on by default). When ready press **Install**.
4. The files will download and installation will start. After the installation ends (with or without success) a new screen will show up.
5. If everything was successful, you can safely press **Close**.
<br>If not, then check the reason of the failure and please open an issue here on Github. You can press **Close** afterwards.

### How to update?
... todo ...  
### How to uninstall?
... todo ...  

## Todo
These are the things that should be added someday:

* News section (featuring latest blog posts, etc.) on Intro view
* Buttons for cocos2d website, forums and repo on Intro view (now only in menu bar)
* Option to send feedback (along with logs, if installation wasn't successful)
* Option to copy the actual downloaded repo files somewhere (user specified dir) if user wants to
* Make the installer a more like "manager", with notifications about new github releases (like "new version available") and more
* Better keyboard control of the installer - right now you can't control it only be keyboard (which is sad)

## FAQ
#### Can I help somehow?
Of course you can! If you have any idea or issue then please write it into the issue. Better yet, if you know how to fix it or implement it then fork this repo and submit a pull request.  

You can also help by translating the installator strings - all of them are located in the `Localizable.strings` file.

#### I am a designer, can I redo the horrible UI an its animations?
Please do! I am only a programmer, my designing skills are not good and I would really welcome any help with the design. I had some ideas (I failed to do them myself), but I am open to anything by an experienced UI designer :)
