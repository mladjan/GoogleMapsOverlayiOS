GoogleMapsOverlayiOS
====================

**** THIS SOLUTION IS APPROVED BY APPLE ****

If you want to have Google maps instead of Apple maps in your app on iOS6, this is simple solution for this

***********************************************************************************************************
As you already saw, Apple made his own maps solution, which is implemented in iOS6. It's great, but, unfortunately, here in Serbia is unusable. I heard a lot of people from countries like UK that maps are not good enough in their Cities, it's huge problem for people who already have some app in appStore that's based on Google maps and Google maps API (for example geocoding API which must to be used only with Google maps by Google maps TOS).

<img src="http://www.mladjanantic.com/wp-content/uploads/2012/09/Taksiko_maps1.jpg" alt"Taksiko Google vs Apple maps" />

I found solution for implementing Open Street Maps as overlay on the MKMapView: <a href="http://wiki.openstreetmap.org/wiki/OSM_in_MapKit" alt="" target="_blank">http://wiki.openstreetmap.org/wiki/OSM_in_MapKit</a>

Because they just downloading OSM tiles and showing them as overlay, I made some changes to use Google maps tiles.
I posted demo on GitHub: <a href="https://github.com/mladjan/GoogleMapsOverlayiOS" alt="" target="_blank">https://github.com/mladjan/GoogleMapsOverlayiOS</a>

Implementation:
Use this, it's the same: <a href="http://wiki.openstreetmap.org/wiki/OSM_in_MapKit" alt="" target="_blank">http://wiki.openstreetmap.org/wiki/OSM_in_MapKit</a>

Thanks to Nutiteq team for providing source code for OSM!