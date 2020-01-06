import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls 2.4 as QTC
import QtWebView 1.1
//App{
//    licenseKey: "EAA9DAADFE3AA67EBB8D3092FD39074978C8FEF80000307C933E4F6F0CC93A18D33B12B619BA12FEB277553A6559A943C9B91760080FF9F6CA1A7BFFD2E661540886FD0A7D59031BE9F6BEB899DCC9312FC80F586962F412E80ED0402FD2EC4B954A089D667AFAEC6579D9FDAB4881E506B4E09D9E4B1FA0F7192CA910C2781BA0F07BD7905230157D92F5772A0D4848AF7E68A1D8846DB71983A6F8EB05676CCF21AE867DA3538A9B1938841FE339AEC413AFD6D28C7D851A5C8648F3564917A28766D024CACF26E01B78795FD35E79768F97102CFCB06DA333F1C0E2200ACD0BDCAE9EF1C6312A76D686849D811174A99D47E7718D9AF3E693585FC491335982E78AC50B6AEF4E1DCE573DD1D3DDA63B038A724BB2930B4FB514E9869EB590F72229D8C0B2590A676694D4521C90063CAB05A4792D317E9AF6F7DAB4CF88E06B7C10C37E2975BB131045EE37260E162E4A76068092DBA39785415A12E47802470458EB05CF593BAB8B4E07D818D57008736ECC6C45F1A43E1AC6DFBDE33EEB7EAAD1BD6C03E09F5F873A0332A1475D4AE1050DCBEB67B61ED5CA212F8FEDD9"
    GameWindow {
      id: gameWindow
      property bool select:false
      property var selectedBlocks:[]

      property date startDateValue:new Date()
      property date endDateValue:new Date()
      property string datePickerLuncerh:""
      property var reservedSpaces:[]

      // You get free licenseKeys from https://felgo.com/licenseKey
      // With a licenseKey you can:
      //  * Publish your games & apps for the app stores
      //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
      //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
      // licenseKey: "<generate one from https://felgo.com/licenseKey>"
      licenseKey: "EAA9DAADFE3AA67EBB8D3092FD39074978C8FEF80000307C933E4F6F0CC93A18D33B12B619BA12FEB277553A6559A943C9B91760080FF9F6CA1A7BFFD2E661540886FD0A7D59031BE9F6BEB899DCC9312FC80F586962F412E80ED0402FD2EC4B954A089D667AFAEC6579D9FDAB4881E506B4E09D9E4B1FA0F7192CA910C2781BA0F07BD7905230157D92F5772A0D4848AF7E68A1D8846DB71983A6F8EB05676CCF21AE867DA3538A9B1938841FE339AEC413AFD6D28C7D851A5C8648F3564917A28766D024CACF26E01B78795FD35E79768F97102CFCB06DA333F1C0E2200ACD0BDCAE9EF1C6312A76D686849D811174A99D47E7718D9AF3E693585FC491335982E78AC50B6AEF4E1DCE573DD1D3DDA63B038A724BB2930B4FB514E9869EB590F72229D8C0B2590A676694D4521C90063CAB05A4792D317E9AF6F7DAB4CF88E06B7C10C37E2975BB131045EE37260E162E4A76068092DBA39785415A12E47802470458EB05CF593BAB8B4E07D818D57008736ECC6C45F1A43E1AC6DFBDE33EEB7EAAD1BD6C03E09F5F873A0332A1475D4AE1050DCBEB67B61ED5CA212F8FEDD9"

      activeScene: scene

      // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
      // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
      // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
      // this resolution is for iPhone 4 & iPhone 4S
      screenWidth: 640

      screenHeight: 960

      // initialiaze game when window is fully loaded
      onSplashScreenFinished: scene.startGame()


      // for dynamic creation of entities
      EntityManager {
        id: entityManager
        entityContainer: gameArea
      }

      // custom font loading of ttf fonts
      FontLoader {
        id: gameFont
        source: "../assets/fonts/akaDylan Plain.ttf"
      }
      //component like player
      function shootMonster(entityId) {
        scene.playerShotMonster(entityId)
      }

      Dialog {
        id: customDialog2
        width: dp(400)
        height:100
//        scale: 0.5
    //    Scale:0.5
        anchors.centerIn: scene
    //    title: "Do you think this is awesome?"
        positiveActionLabel: "Yes"
        negativeActionLabel: "No"
        onCanceled: title = "Think again!"
        onAccepted: close()
        RadioButton{
        data:["red", "blue", "yellow"]
        onHighlightedIndexChanged: {
        console.debug(currentText, currentIndex)
        recWorker.color=currentText

        }
        }
      }
        Column{
            Row{
                SimpleButton {
                  id:startDate
                  text:startDateValue.toLocaleDateString()
//                  onClicked: nativeUtils.openUrl("https://felgo.com")
                  onClicked: {
                      datePickerLuncerh = "startDate"
                      nativeUtils.displayDatePicker(startDateValue)}
                }
                SimpleButton {
                  id:endDate
                  text: endDateValue.toLocaleDateString()
//                  onClicked: nativeUtils.openUrl("https://felgo.com")
                  onClicked: {
                  datePickerLuncerh = "endDate"
                  nativeUtils.displayDatePicker()
                  }//displayDatePicker(date initialDate, date minDate, date maxDate)
                }
                // the result of the input dialog is received with a connection to the signal textInputFinished
                   Connections {

                       target: nativeUtils

                       // this signal has the parameters accepted and enteredText
                       onDatePickerFinished: {
                         // if the input was confirmed with Ok, store the userName as the property
                         if(accepted) {
//                             var someDate = new Date()
//                               someDate.setDate(date.getDate() - startDateValue.getDate())
                             if(datePickerLuncerh === "startDate"){
                                 startDateValue = date//.toLocaleDateString(Qt.locale("fi_FI"),"dd.MM.yyyy");
                                 sliderDay.value = Math.floor((Math.abs(startDateValue - new Date()))/86400000)
                             }
                             else if (datePickerLuncerh === "endDate"){
                                 endDateValue = date

                         }
                         }
                         datePickerLuncerh = ""
                       }
                   }
                RadioButton{
                    id:teams
                    data:["HVAC_1", "HVAC_2",  "Plumbing_1","Drywall_1"]
                }
                RadioButton{
                    id:floors
                    data:["floor_1", "floor_2",  "floor_3","floor_4"]
                }
                RadioButton{
                    id:spaceType
                    data:["Unusable", "Activity",  "Storage","Free"]
                }

                Rectangle{
                    color: select?"green":"grey"

                    Text {
                        id: spacesButton
                        text: qsTr(select?"Activated":"Add Spaces")
                        anchors.centerIn: parent
                        color: "white"
                    }
                    width: 90
                    height: 52.5
                    z:10000
                    // handle click event on blocks (trigger clicked signal)
                    MouseArea {
                      anchors.fill: parent
                      onClicked: {
                          select=!select
//                          shootMonster("worker_175")
                          if (!select){
                              for (var i=0; i<selectedBlocks.length; i++){
                                console.log("Array item:", selectedBlocks[i])
                                var someEntity = entityManager.getEntityById(selectedBlocks[i])
                                someEntity.type=spaceType.currentIndex
                                  reservedSpaces.push(selectedBlocks)

                                  selectedBlocks=[]
                              }
                              console.log(reservedSpaces)
customDialog2.open()
                          }

                      }
                    }
                }

            }
            Row{
                QTC.Slider {
                    id:sliderDay
                    snapMode:QTC.Slider.SnapOnRelease
                    from: 0
                    value: 0
                    to: 140
                    width:gameWindow.width
                    stepSize: 1
                    onMoved: {
                        sliderDay.value
                        console.log(sliderDay.value)

                            var today = new Date();
                            today.setDate(today.getDate()+(sliderDay.value))
                            startDateValue = today
                            console.log(Qt.formatDate(today, "dd.MM.yy"))

                    }

                }
            }
            Row{
                Scene {

//                    // the "Back" key is used on Android to close the app when in the main scene
//                    focus: true // this guarantees the key event is received
//                    Keys.onBackButtonPressed: openMessageBoxWithQuitQuestion()


//                    signal playerShotMonster(string entityId)


                    // make the balloons float up
                    PhysicsWorld {
              //          debugDrawVisible: true // set this to false to hide the physics debug overlay
                        updatesPerSecondForPhysics: 1
                        z: 1000 // set this high enough to draw on top of everything else
              //          z: 1;y:1; x:1


                    } //gravity.y: -1
                  id: scene
                  width: 480
                  height: 320
                  // the "logical size" - the scene content is auto-scaled to match the GameWindow size
                  WebView {
            //        anchors.fill: parent
                      width: 480
                      height: 320
                    url: "https://www.google.com"
                    z:0
                  }
                  // property to hold game score
                  property int score

                  // background image
                  BackgroundImage {
                    source: "../assets/hvac.png"
                    anchors.centerIn: scene.gameWindowAnchorItem
                    width: parent.width
                    height: parent.height
                  }
                  //...
                  // left wall
                  Wall {height:parent.height; anchors.right:scene.right}

                  // ceiling
                  Wall {width:parent.width; anchors.top:scene.top}
                  // ceiling
                  Wall {width:parent.width; anchors.bottom:scene.bottom}
                  // right wall
                  Wall {height:parent.height; anchors.left:scene.left}


              //    // display score
              //    Text {
              //      // set font
              //      font.family: gameFont.name
              //      font.pixelSize: 12
              //      color: "red"
              //      text: scene.score

              //      // set position
              //      anchors.horizontalCenter: parent.horizontalCenter
              //      y: 446
              //    }


                  // game area holds game field with blocks
                  GameArea {
                    id: gameArea
                    anchors.horizontalCenter: scene.horizontalCenter
                    y: 20
                    blockSize: 60
                    onGameOver: gameOverWindow.show()
                  }

                  // configure gameover window
                  GameOverWindow {
                    id: gameOverWindow
                    y: 90
                    opacity: 0 // by default the window is hidden
                    anchors.horizontalCenter: scene.horizontalCenter
                    onNewGameClicked: scene.startGame()
                  }

                  // initialize game
                  function startGame() {
                    gameOverWindow.hide()
                     gameArea.initializeField()
                     gameArea.initializeWorkers()
                    scene.score = 0
                  }
                }
            }

        }


      }

//}
