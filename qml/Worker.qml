import Felgo 3.0
import QtQuick 2.12


EntityBase {
  id: worker
  entityType: "worker"
  property int workerID
  property bool speech: false
  property int diameter: 20
  property  string workerBorder
  // hide block if outside of game area
  visible: y >= 0
  z:10000
  Connections {
    target: scene
    onPlayerShotMonster: {
      // compare the monsters entityId with the on that is passed from the signal
      if(worker.entityId === entityId) {
        getShot()
      }
    }
  }
  function getShot(){
//  worker.visible = false
  recWorker.color = "red"
  }



  ///////////
 Component.onCompleted: {
         console.debug("worker has been constructed")
       }
//  // each block knows its type and its position on the field
//  property int type
//  property int row
//  property int column

  // emit a signal when block is clicked
  signal clicked(int workerID )

  // show different images for block types
  width: worker.diameter
  height: worker.diameter

  Rectangle {
      id:recWorker
       width: worker.diameter
       height: worker.diameter
       z:1000000000

       // only collider since we want the wall to be invisible

       color: mouseArea.pressed ? "lightgreen" : dragHandler.active ? "lightyellow" : "#546632"
       border.color: workerBorder
       border.width: 1
       radius: width*0.5
//       Text {
//           anchors.fill:parent
//            color: "red"
//            text: "Boom"
//       }




  }
  CircleCollider {
//      anchors.fill: parent
      radius: diameter/2
//      bodyType: Body.Static
//       collisionTestingOnlyMode: true
      y: 20
      fixture.onBeginContact: {
          console.log("onbegin")
          var fixture = other
          var body = other.getBody()
          var component = other.getBody().target
          var collidingType = component.entityType

          //var
          console.debug("car contact with: ", other, body, component)
          console.debug("car collided entity type:", collidingType)
            recWorker.color = "red"
//          console.debug("car contactNormal:", contactNormal, "x:", contactNormal.x, "y:", contactNormal.y)

      }
  //         bodyType: Body.Static // the body shouldn't move
//      fixture.onCollidesWithChanged: {
//          console.log("onwithchanged")
//          recWorker.color = "yellow"
//          var fixture = other
//          var body = other.getBody()
//          var component = other.getBody().target
//          var collidingType = component.entityType

//          //var
//          console.debug("car contact with: ", other, body, component)
//          console.debug("car collided entity type:", collidingType)

////          console.debug("car contactNormal:", contactNormal, "x:", contactNormal.x, "y:", contactNormal.y)

//      }
//      fixture.onContactChanged: {
//          console.log("oncontactchanged")
//          recWorker.color = "yellow"
//          var fixture = other
//          var body = other.getBody()
//          var component = other.getBody().target
//          var collidingType = component.entityType

//          //var
//          console.debug("car contact with: ", other, body, component)
//          console.debug("car collided entity type:", collidingType)

////          console.debug("car contactNormal:", contactNormal, "x:", contactNormal.x, "y:", contactNormal.y)

//      }
      fixture.onEndContact: {
          console.log("onendchanged")
          recWorker.color = "yellow"
          var fixture = other
          var body = other.getBody()
          var component = other.getBody().target
          var collidingType = component.entityType

          //var
          console.debug("car contact with: ", other, body, component)
          console.debug("car collided entity type:", collidingType)

//          console.debug("car contactNormal:", contactNormal, "x:", contactNormal.x, "y:", contactNormal.y)

      }


    }
   DragHandler { id: dragHandler }

  MultiResolutionImage  {
      id: speech
      source: "../assets/Speech.png"
      width:50
      height:50
      anchors.bottom: parent.top
      opacity: worker.speech

  }
  // handle click event on blocks (trigger clicked signal)
  MouseArea {
    id:mouseArea
    anchors.fill: recWorker
    onClicked: parent.clicked(worker.workerID)
    Component.onCompleted: {
           console.debug("mouseArea has been constructed")
         }

  }

  // fade out block before removal
  NumberAnimation {
    id: fadeOutAnimation
    target: worker
    property: "opacity"
    duration: 100
    from: 1.0
    to: 0

    // remove block after fade out is finished
    onStopped: {
      entityManager.removeEntityById(worker.entityId)
    }
  }
  Dialog {
    id: customDialog
    width: dp(150)
    height:100
    scale: 0.5
//    Scale:0.5
    anchors.centerIn: worker
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



  // start fade out / removal of block
  function remove() {
    fadeOutAnimation.start()
  }

  function jump(){
   x=x+1
    worker.speech = !worker.speech
      customDialog.open()

//    console.log(worker.speech?"true":"false")
//      fallDown(300)
  }



  function randomMove(){

      worker.x = worker.x+[1,-1,0][[Math.floor(Math.random() * [1,-1,0].length)]]*5
//      worker.x > scene.width?worker.x=scene.width-diameter:""
//      console.log("trigered")
      worker.y = worker.y+[1,-1,0][[Math.floor(Math.random() * [1,-1,0].length)]]*5
//      worker.y > scene.height?worker.y=scene.height-diameter:""

   }
  Timer {
    interval: Math.floor(Math.random()*1000)
//      interval: 1000

    running: true
    repeat: true
    onTriggered: {
//        workerAnimation.start()
//        randomMove()
//        animX.complete()
//        animY.complete()
        animX.start()
        animY.start()
//        console.log("trigered")
    }
  }

  // moves the entity to x position 100 within 2 seconds
  NumberAnimation on x {
      id:animX
      to: worker.x+[1,-1,1,-1][Math.floor(Math.random() * [1,-1,1,-1].length)]*10 *(Math.random()+0.001)
    duration: Math.random()*2000+2000
  }
  // moves the entity to x position 100 within 2 seconds
  NumberAnimation on y {
      id:animY
      to: worker.y+[1,-1,1,-1][Math.floor(Math.random() * [1,-1,1,-1].length)]*10*(Math.random()+0.001)
//    duration: Math.random()*2000 +2000
    duration: Math.random()*2000 +2000
  }




  // trigger fall down of block
  function fallDown(distance) {
    // complete previous fall before starting a new one
    fallDownAnimation.complete()
//      console.log("starte")

    // move with 100 ms per block
    // e.g. moving down 2 blocks takes 200 ms
    fallDownAnimation.duration = 100 * distance
    fallDownAnimation.to = y + distance * height

    // wait for removal of other blocks before falling down
    fallDownTimer.start()
  }
  // animation to let blocks fall down
  NumberAnimation {
    id: fallDownAnimation
    target: worker
    property: "y"
  }



  // timer to wait for other blocks to fade out
  Timer {
    id: fallDownTimer
    interval: fadeOutAnimation.duration
    repeat: false
    running: false
    onTriggered: {
      fallDownAnimation.start()
//        console.log("trig")
    }
  }

}
