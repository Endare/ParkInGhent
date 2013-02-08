import bb.cascades 1.0
import bb.system 1.0

NavigationPane {
    id: navigationPane
    property variant parkingViewVar
    property variant inDetailVar
    Menu.definition: MenuDefinition {
	    actions: [
	        // An action item that calls the C++ function that retrieves
	        // the contact list
	        ActionItem {
	            title: qsTr("Vernieuw")
	            onTriggered: {
	                if(inDetailVar)
	                {
	                    navigationPane.pop();
	                }
	                app.initiateRequest();
	            }
	            imageSource: "asset:///images/rotate.png"
	        },
	        ActionItem {
	            title: qsTr("Over");
	            imageSource: "asset:///images/info.png" 
	            onTriggered: {
	                aboutDialog.show();
	            }
	        }
	    ] 
	}   
	Page {
	    id: parkingList
	    property variant myBackground: Color.create("#0D1C2E")    
	    content: Container {
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
	                text: qsTr("Gent")
	                textStyle {
	                     base: SystemDefaults.TextStyles.BigText
	                     color: Color.White   
	                }    
	            }
	        }
	        Container {
	            layout: DockLayout{}
		        // A list that has two list item components, one for a header
		        // and one for contact names. The list has an object name so
		        // that we can set the data model from C++.
		        ListView {
		            id: parkingListView
		            objectName: "parkingListView"
		            verticalAlignment: VerticalAlignment.Center
		            horizontalAlignment: HorizontalAlignment.Center
		                         
		            layout: FlowListLayout {
		                 
		            }
		            // A simple data model is loaded with just a header.
		            // This will be replaced when we load the real one
		            // from C++.
		            dataModel: XmlDataModel {}
		             
		            listItemComponents: [
		                ListItemComponent {
		                    type: "parkings"
		                    Container {
		                        layout: DockLayout {}
		                        verticalAlignment: VerticalAlignment.Center
		                        horizontalAlignment: HorizontalAlignment.Left
		                        leftPadding: 10
		                        rightPadding: 10
	                            Container {
	                                layout: DockLayout {}
	                                verticalAlignment: VerticalAlignment.Top
	                                horizontalAlignment: HorizontalAlignment.Center
	                                preferredHeight: 2
	                                preferredWidth: 800
	                                background: Color.White    
	                            }
		                        Label {
		                            text: ListItemData.description
		                            textStyle {
					                     base: SystemDefaults.TextStyles.BigText
					                     color: Color.White   
		                            }   
		                        }
		                        Container {
		                            layout: DockLayout {}
		                            verticalAlignment: VerticalAlignment.Center
		                            horizontalAlignment: HorizontalAlignment.Right
		                            background: Color.Black
		                            preferredHeight: 80
		                            preferredWidth: 140
		                            topMargin: 10
		                            bottomMargin: 10
		                            ImageView {
		                                imageSource: ListItemData.statusImage
		                                verticalAlignment: VerticalAlignment.Center
		                                horizontalAlignment: HorizontalAlignment.Center   
		                            }
		                        }
		                        Container {
		                            layout: DockLayout {}
		                            verticalAlignment: VerticalAlignment.Bottom
		                            horizontalAlignment: HorizontalAlignment.Center
		                            preferredHeight: 2
		                            preferredWidth: 800
		                            background: Color.White    
		                        }
		                    }
		                }
		            ]
		             
                    onTriggered: {
                        select(indexPath);
                        var page = parkingDetails.createObject();
                        inDetailVar = true;
                        navigationPane.push(page);
                    }
                    
                    onSelectionChanged: {
                        if (selected) 
                        {
                            parkingViewVar = dataModel.data(indexPath);
                        }
                    }
		        }
		        // The activity indicator has an object name set so that
		        // we can start and stop it from C++
		        ActivityIndicator {
		            objectName: "indicator"
		            verticalAlignment: VerticalAlignment.Center
		            horizontalAlignment: HorizontalAlignment.Center
		            preferredWidth: 200    
		            preferredHeight: 200   
		        }
		    }
	    }
	    attachedObjects: [
	        ComponentDefinition {
                id: parkingDetails
                source: "ParkingDetails.qml"
            },
            SystemDialog {
                id: aboutDialog
                title: qsTr("Over Park in Ghent")  
                body: qsTr("overTekst")
            }
	    ]
	}
	
	onTopChanged: {
	    if(page == parkingList) 
	    {
            parkingListView.clearSelection();
        }
    }
        
    onPopTransitionEnded: {
        page.destroy();
        inDetailVar = false;
    }
}