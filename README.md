# IOSChallenge



High Level Architecture 
Since this is a small App, our mobile client only need to talk with backend server to to get the meal data, there is no other components like caching or messaging queue service


High Level client Design 
To achieve modular design, I used layers to organize modules so that it will be easier to test and reuse
The benefit will be I can easily swap the UI layer from UIkit to SwiftUI```
Those layers are abstracted by protocol and use DI (Dependency Injection) to manage dependencies


UI Architecture
Eventhough this is a small app and MVC archtecture is sufficient to do the job, it will be hard to scale, maintain, and test if we add more features and multiple team work on the same app. Imagine if the viewcontrollers need to do the layout, networking, event handling, and formatting of data, those components will be highly coupled with viewcontrolelrs.
To adhere to the software design principle: Separation of concern, I decided to adopt the MVVM architecture with delegate/protocol as a way to do the communication. Other communication mechinsm like Rxswift, combine, and KVO would add an extra layer of complexity to the project and hard for people to understand if they don't have relevant expereice with these frameworks.
  
UI Design 
Storyboards have some benefits when we have tight deadlines for the project. However, it is aslo hard to maintain and build time will also increase.
swift UI: backward support 
So in this project, I created all layouts programmatically with UIKit
 
Navigation Mechinism 
I used coordinator pattern to handle navigation and flow between viewcontrollers. 
coordinator pattern: central place to improve navigation management  
Router/Flow controlelrs: Each view controller is responsible for presenting or dismissing other view controllers as needed. coupling issue: X
View Model-based Navigation: need to use rxswift, combine, callback, coupling issue X
Storyboard Segues and Storyboard References: we are doing UI programmatically X

Cache
NSCache requires manual implementation of caching logic, such as retrieving, storing, and removing images. So i used Kingfisher. It offers a range of features and optimizations for handling image caching, including memory caching, disk caching, prefetching, and caching control strategies

Error handling 


Testing
Report 

Device Testing


Anything to do in the future 
Localizaiton 
UI improvements
pagination
since the API doesn't provide pagination support for querying a list of meal and the list is reasonably small, fetching it all at once should not be a problem.

appverion - 1
