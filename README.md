# fantastic-journey
The app is fairly easy to set up. All we need to use is to select in the first tab the API we want to use to retrieve locations fix. Possible values are *Visit* (which uses `CLVisit`) and *Significant Changes* (the traditional API. In the current implementation with the added twist of enabling deferred location to accommodate the needs of the system when the app is backgrounded). There is also an option to query the two APIs at once. 

![Settings](https://user-images.githubusercontent.com/275949/30592651-02249c84-9d1e-11e7-974c-a8b139147b43.png)

Once selected the API, tapping “Start” will enable the system (obviously, we are relying on the user granting access to core location). 

Then, each time the app gets a new fix, the user will be notified. I need users to take into consideration the accuracy and reliability of these fixes. Example, is the location fix triggered by a traffic light stop? Or a train stopping in the station? Is the location triggered when you arrive to the office? Or your home? The first two are noise, the other two are important. 

From the map view users can access a table view based log (the same information, but shown as a list), and export. I would prefer users to email me with the logs at [ariel@sp0n.com](ariel@sp0n.com)

![screen shot 2017-09-18 at 7 04 20 pm](https://user-images.githubusercontent.com/275949/30592932-25a3cddc-9d1f-11e7-9b92-24253bab9d57.png)

A rating system has been added to the details view controller. By default the value is “unknown”, but, as said before, it would be of great help if you can rate as many locations as possible. 

The details view controller is accessible from both, the map and the list log. 

![list](https://user-images.githubusercontent.com/275949/30608863-0bc6e986-9d50-11e7-9f54-51630df864f7.gif)
![map](https://user-images.githubusercontent.com/275949/30608961-5f112a84-9d50-11e7-9c3d-16c883ed904f.gif) 


