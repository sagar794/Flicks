# Pre-work - tipCalculator 

tipCalculator is a tip calculator application for iOS.

Submitted by: Sagar Ali

Time spent: 14 hours spent in total. Took 1 hour to implement the basic function. 

## User Stories

The following **required** functionality is complete:

Y - Yes
N - No

* [Y] User can enter a bill amount, choose a tip percentage, and see the tip and total values.

The following **optional** features are implemented:
* [Y] Settings page to change the default tip percentage.
* [Y] UI animations
* [Y] Remembering the bill amount across app restarts (if <10mins)
* [N] Using locale-specific currency and currency thousands separators.
* [Y] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- Swiping the total amount left will spilt the total bill. The total will be divided by the number of emojis seen on the sceen which represents the number of people the bill is being spilt between. 
- Added a light/dark theme option in the settings screen


## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src= 'http://i.imgur.com/UmKt2bc.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

My lack of understanding of how auto layout and constraints work made it difficult for me to move Labels around on the screen. I ended up turning off auto layout but I would like to learn more about it so that my app can adjust to any orientation. 

## License

    Copyright 2015 Sagar Ali

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.