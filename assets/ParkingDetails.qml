import bb.cascades 1.0
import bb.platform 1.0

Page {
    Container {
        background: parkingList.myBackground
        layout: StackLayout {
            orientation: LayoutOrientation.TopToBottom
        }
        // A container for the header
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            leftPadding: 10
            topPadding: 10
            ImageView {
                imageSource: "asset:///images/parking.png"
                preferredWidth: 80
                preferredHeight: 80
                rightMargin: 10
                scalingMethod: ScalingMethod.AspectFit
            }
            Label {
                text: parkingViewVar.description
                textStyle {
                     base: SystemDefaults.TextStyles.BigText
                     color: Color.White   
                }    
            }
        }
        // A container for the opening hours information
        Container {
            layout: DockLayout {}
            preferredHeight: 120
            preferredWidth: 700
            topMargin: 20
            bottomMargin: 40
            horizontalAlignment: HorizontalAlignment.Center
            Label {
                text: qsTr("Openingsuren:")
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Left   
                textStyle.base: parkingDetailTitle.style
            }
            Label {
                text: parkingViewVar.openingHours
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Right  
                textStyle.base: parkingDetailContent.style 
            }
            Label {
                text: qsTr("Open:")
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Left   
                textStyle.base: parkingDetailTitle.style
            }
            Label {
                text: parkingViewVar.open
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Right   
                textStyle.base: parkingDetailContent.style 
            }
        }
        // A container for the capacity information
        Container {
            layout: DockLayout {}
            preferredHeight: 120
            preferredWidth: 700
            horizontalAlignment: HorizontalAlignment.Center
            Label {
                text: qsTr("Capaciteit:")
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Left  
                textStyle.base: parkingDetailTitle.style
            }
            Label {
                text: parkingViewVar.totalCapacity
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Right  
                textStyle.base: parkingDetailContent.style 
            }
            Label {
                text: qsTr("Vrije plaatsen:")
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Left   
                textStyle.base: parkingDetailTitle.style
            }
            Label {
                text: parkingViewVar.availableCapacity
                verticalAlignment: VerticalAlignment.Bottom
                horizontalAlignment: HorizontalAlignment.Right  
                textStyle.base: parkingDetailContent.style 
            }
        }
        // A container for the address information
        Container {
            layout: DockLayout {}
            preferredHeight: 150
            preferredWidth: 700
            topMargin: 40
            horizontalAlignment: HorizontalAlignment.Center
            Label {
                text: qsTr("Adres:")
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Left   
                textStyle.base: parkingDetailTitle.style
            }
            Label {
                text: parkingViewVar.address
                multiline: true
                verticalAlignment: VerticalAlignment.Top
                horizontalAlignment: HorizontalAlignment.Right 
                textStyle.base: parkingDetailContent.style 
            }
        }
    }
    actions: [
//        ActionItem {
//            title: qsTr("Bekijk op kaart")
//            ActionBar.placement: ActionBarPlacement.InOverflow
//            imageSource: "asset:///images/map.png"
//            onTriggered: {
//                mapInvoker.go();
//            }
//        },
//        ActionItem {
//	        title: qsTr("Geef route weer")
//	        ActionBar.placement: ActionBarPlacement.InOverflow
//            imageSource: "asset:///images/route.png"
//            onTriggered: {
//                routeInvoker.go();
//            }
//        },
	    InvokeActionItem {
            id: invoke
            query {
                mimeType: "text/plain"
                invokeActionId: "bb.action.SHARE"
                data: qsTr("Er zijn nog %1 parkeerplaatsen vrij in Parking %2.").arg(parkingViewVar.availableCapacity).arg(parkingViewVar.description)
            }
        }
    ]
    attachedObjects: [
        TextStyleDefinition {
            id: parkingDetailTitle
            base: SystemDefaults.TextStyles.PrimaryText
            color: Color.create("#9c9ea1")
        },
        TextStyleDefinition {
            id: parkingDetailContent
            base: SystemDefaults.TextStyles.PrimaryText
            color: Color.create("#d7d9db")
        },
        RouteMapInvoker {
            id: routeInvoker
            endLatitude: parkingViewVar.latitude;
            endLongitude: parkingViewVar.longitude;
            endName: parkingViewVar.address
            endDescription: "Parking " + parkingViewVar.description
        },
        LocationMapInvoker {
            id: mapInvoker
            centerLatitude: parkingViewVar.latitude;
            centerLongitude: parkingViewVar.longitude;
            altitude: 200
            locationLatitude: parkingViewVar.latitude;
            locationLongitude: parkingViewVar.longitude;
            locationName: "Parking " + parkingViewVar.description
        }
    ]
}
