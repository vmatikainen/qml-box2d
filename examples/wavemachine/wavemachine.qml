import QtQuick 2.2
import Box2D 2.0
import QtQuick.Particles 2.0

import "../shared"

Rectangle {
    id: screen
    width: 800
    height: 500

    property int maxNumOfParticles: 50000
    property real particleRadius: 3

    World {
        id: physicsWorld
    }

    ScreenBoundaries {
    }

    RectangleBoxBody {
        x: 100
        y: 100
        width: 10
        height: 10

        bodyType: Body.Dynamic
        world: physicsWorld

        density: 1
        friction: 0.3
        restitution: 0.5
    }

    Item {
        x: 150
        y: 150
        id: waveBox
        width: 500
        height: 200

        transformOrigin: Item.Center

        property int halfAnimationDuration: 1300

        SequentialAnimation {
            running: true; loops:
            Animation.Infinite
            PropertyAnimation { target: waveBox; property: "rotation"; easing.type: Easing.OutQuad; from: 0; to: 15; duration: waveBox.halfAnimationDuration/2; }
            PropertyAnimation { target: waveBox; property: "rotation"; easing.type: Easing.InOutQuad; from: 15; to: -15; duration: waveBox.halfAnimationDuration; }
            PropertyAnimation { target: waveBox; property: "rotation"; easing.type: Easing.InQuad; from: -15; to: 0; duration: waveBox.halfAnimationDuration/2; }
        }


        property int wallThickness: 20

        Body {
            id: waveBoxBody

            target: waveBox
            bodyType: Body.Kinematic

            Box {
                id: left
                x: leftRect.x
                y: leftRect.y

                width: waveBox.wallThickness
                height: waveBox.height
            }
            Box {
                id: right
                x: rightRect.x
                y: rightRect.y

                width: waveBox.wallThickness
                height: waveBox.height
            }
            Box {
                id: top
                x: topRect.x
                y: topRect.y

                width: waveBox.width
                height: waveBox.wallThickness
            }
            Box {
                id: bottom
                x: bottomRect.x
                y: bottomRect.y

                width: waveBox.width
                height: waveBox.wallThickness
            }
        }

        Rectangle {
            id: leftRect
            anchors.left: parent.left

            width: waveBox.wallThickness
            height: waveBox.height
            border.color: "black"
            border.width: 2
        }
        Rectangle {
            id: rightRect
            anchors.right: parent.right

            width: waveBox.wallThickness
            height: waveBox.height
            border.color: "black"
            border.width: 2
        }

        Rectangle {
            id: topRect
            anchors.top: parent.top

            width: waveBox.width
            height: waveBox.wallThickness
            border.color: "black"
            border.width: 2
        }
        Rectangle {
            id: bottomRect
            anchors.bottom: parent.bottom

            width: waveBox.width
            height: waveBox.wallThickness
            border.color: "black"
            border.width: 2
        }
    }

    Box2DParticleSystem {
        id: box2DParticleSystem
        particleRadius: screen.particleRadius / physicsWorld.pixelsPerMeter
        world: physicsWorld
    }

    Component {
        id: blueBall
        Rectangle {
            width: screen.particleRadius * 2
            height: screen.particleRadius * 2
            radius: screen.particleRadius
            border.color: "#550000ff"
            border.width: 1
            color: "transparent"
        }
    }

    ParticleSystem {
        id: particleSystem
        ItemParticle {
            fade: false
            delegate: blueBall
        }
    }

    Emitter {
        id: emitter
        anchors.centerIn: parent
        width: 160; height: 80
        system: particleSystem
        emitRate: 0
        lifeSpan: Emitter.InfiniteLife

        maximumEmitted: screen.maxNumOfParticles
    }

    Affector {
        system: particleSystem
        onAffectParticles: {
            var coordinates = box2DParticleSystem.particleCoordinates();
            var pixelsPerMeter = physicsWorld.pixelsPerMeter
            for( var i = 0; i < particles.length; i++) {
                var p = particles[i];
                p.x = coordinates[i*2] * pixelsPerMeter
                p.y = coordinates[i*2 + 1] * pixelsPerMeter * -1
                p.update = true
            }
        }
    }
//    DebugDraw {

//    }

    Component.onCompleted: {
        createParticleRectangle (waveBox.x + 30, waveBox.y +30, 400, 100, 4);
    }

    function createParticleRectangle (x, y, width, height, particleDistance) {
        var pixelsPerMeter = physicsWorld.pixelsPerMeter
        for(var i = x; i < x + width; i += particleDistance)     {
            for(var j = y; j < y + height; j += particleDistance)     {
                box2DParticleSystem.addParticle(i / pixelsPerMeter, -j / pixelsPerMeter);
                emitter.burst(1);
            }

    }

}
}

