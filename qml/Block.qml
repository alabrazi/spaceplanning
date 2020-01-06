import Felgo 3.0
import QtQuick 2.0


EntityBase {
  id: block
  entityType: "block"
  property var typesList: ["../assets/Apple.png",
      "../assets/Banana.png","../assets/Orange.png",
      "../assets/Pear.png","../assets/BlueBerry.png"]
  // hide block if outside of game area
  visible: y >= 0

  // each block knows its type and its position on the field
  property int type
  property int row
  property int column

  // emit a signal when block is clicked
  signal clicked(int row, int column, int type)

  // show different images for block types
  Image {

    id : someImage
    anchors.fill: parent
    source:typesList[type]
//    source: {
//      if (type == 0)
//        return
//      else if(type == 1)
//        return
//      else if (type == 2)
//        return "../assets/Orange.png"
//      else if (type == 3)
//        return "../assets/Pear.png"
//      else
//        return "../assets/BlueBerry.png"
//    }
    opacity: 0.2

  }
  BoxCollider {
    anchors.fill: parent
//    bodyType: Body.Static // the body shouldn't move
//    bodyType: Body.Kinematic
     collisionTestingOnlyMode: true
  }
  // handle click event on blocks (trigger clicked signal)
  MouseArea {
    anchors.fill: parent
    onClicked: {parent.clicked(row, column, type)}

//    onMouseXChanged: {

//        block.type =spaceType.currentIndex

//    }
    onPressed: {

        if (select){
            if(block.type !== 3){
            block.type =3
            gameWindow.selectedBlocks.splice(gameWindow.selectedBlocks.indexOf(block.entityId),1)
            }
            else{
                console.log("select");
                block.type =spaceType.currentIndex

                gameWindow.selectedBlocks.push(entityId)
                console.log(gameWindow.selectedBlocks)
            }



        }
        else {
        console.log("not select");
        }

    }

  }

  // fade out block before removal
  NumberAnimation {
    id: fadeOutAnimation
    target: block
    property: "opacity"
    duration: 100
    from: 1.0
    to: 0

    // remove block after fade out is finished
    onStopped: {
      entityManager.removeEntityById(block.entityId)
    }
  }

  // animation to let blocks fall down
  NumberAnimation {
    id: fallDownAnimation
    target: block
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
    }
  }

  // start fade out / removal of block
  function remove() {
    fadeOutAnimation.start()
  }

  // trigger fall down of block
  function fallDown(distance) {
    // complete previous fall before starting a new one
    fallDownAnimation.complete()

    // move with 100 ms per block
    // e.g. moving down 2 blocks takes 200 ms
    fallDownAnimation.duration = 100 * distance
    fallDownAnimation.to = block.y + distance * block.height

    // wait for removal of other blocks before falling down
    fallDownTimer.start()
  }
}
