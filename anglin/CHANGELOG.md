VERSION 4.3.2
* Scaling adjusted and able to go to 3 now for 4k screens, window size will scale with the slider as well

VERSION 4.3.2
* Cleaned up some remnants from old versions in the settings.lua file. Corrected first load default of background image being enabled from true to false.

VERSION 4.3.1
* Popup will appear during Sunbreeze fishing now. And event fish pt values will show in statistics window (not totals, just what each fish is worth)

VERSION 4.3
* Adjusted how background images work so they should display better for folks that use them.
* Changed Anglin's character detection timing to wait for the game to load a character before trying to load settings which should allow switching characters and loading that characters settings
* Added the fish from the Sunbreeze Festival to the guide

VERSION 4.2.2
* Guide updated to default to filter to current zone. Minor bugfix to location filtering. Reclassified Denizanasi as an ITEM.

VERSION 4.2.1
* Fixed anglin not detecting Moghancement: Fishing properly since the TOaU/Ashita update. This should now be reflected in your + fishing skill displayed.

VERSION 4.2
* Removed dependancy on imguistyle. It should look pretty with or without it now. I learned some things. Thank you. I love you - say it back.

VERSION 4.1.3
* Fixed for ToAU release. If it doesn't work, please delete your imguistyle CONFIG folder to clear broken config, then load imguistyle to rebuild it. Anglin should work after that. Reach out to Astika on discord if you need a hand sorting. Thanks!

VERSION 4.1.2
* Price Check: Updated the NPC min sale price for Silver Sharks (from 500gil to 400gil)

VERSION 4.1.1
* BUGFIX: Updater will now properly pull all files

VERSION 4.1
* Added Isolating Baits tab

VERSION 4.0.9.13
* Corrected detection of Fisherman's Gloves and Fisherman's Tunica. Minor bugfixes.

VERSION 4.0.9.11
* Suggested fish will now consider your EFFECTIVE skill (with gear and bonuses)

  
VERSION 4.0.9.10
* Can now use a background image with your themes

  
VERSION 4.0.9.1
* Added display of bonus fishing skill from guild support/advanced support

  
VERSION 4.0.9
* Added display of bonus fishing skill from gear/moghancement

  
VERSION 4.0.8
* Added a sound notification for fishing skill increase

  
VERSION 4.0.7
* Corrected how catch detection works for NM mobs - this should work now.

  
VERSION 4.0.6
* Added a confirmation check when clicking reset stats for daily and lifetime

  
VERSION 4.0.5
* Added fish sale price range (prices slightly change depending on fame where you're selling) to guide and Est. Total tracker

  
VERSION 4.0.4
* Adjusted the trigger for evaluating catches for personal best fish to not require contest window to be open
* Added a restock timer that will show next restock time, and earth time remaining until it happens

  
VERSION 4.0.3
* Added more "personal bests" to the Fishing Contest window


VERSION 4.0.2
* Changed the trigger for the initial update check if addon loads with game client (from default.txt script) so that it always shows.
* Changelog will now show ALL changes between your previous version (starting from v4), and the version you updated to.


VERSION 4.0.1
* Corrected when the fishing contest data is loaded on client start so that data populates properly without having to reload addon.


VERSION 4.0
* Added Fishing Contest window (/anglin contest)
* Contest window shows live phase countdown, current fish, criteria, and measure
* Phase timeline projects forward automatically from cached data - no repeated NPC visits needed
* Contest phase and countdown persist across relogs via per-character JSON cache
* Per-fish reference data: length/weight ranges, estimated weights, best hour/moon conditions, location, bait, rod
* Personal best tracking: length and weight recorded automatically when sized fish are in inventory
* Added key item requirement indicators to Fishing Guide
* Auto-update now displays change notes in chat after a successful update
* Just wanted to say thanks for trying this addon out. Hope it helps you!


VERSION 3.9.12
* Updated for ToAU content
* Improved fishing session tracking
* Added lure loss tracking
* Various bug fixes and stability improvements
