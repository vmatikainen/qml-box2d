#ifndef BOX2DPARTICLESYSTEM_H
#define BOX2DPARTICLESYSTEM_H

#include <QObject>

#include <Box2D.h>

class Box2DWorld;

class Box2dParticleSystem : public QObject
{
    Q_OBJECT

    Q_PROPERTY(Box2DWorld *world READ world WRITE setWorld NOTIFY worldChanged)
    Q_PROPERTY(qreal particleRadius READ particleRadius WRITE setParticleRadius NOTIFY particleRadiusChanged)

public:
    explicit Box2dParticleSystem(QObject *parent = 0);

    Box2DWorld * world() const;
    Q_INVOKABLE QList<qreal> particleCoordinates();

    qreal particleRadius() const;

signals:
    void worldChanged(Box2DWorld * arg);

    void particleRadiusChanged(qreal arg);

public slots:
    void setWorld(Box2DWorld *world);
    void printParticleData();
    void addParticle(int x, int y);

    void setParticleRadius(qreal arg);

private:
    void createParticleSystem();

protected:
    Box2DWorld* m_world;

    b2ParticleSystem* m_particleSystem;

    b2ParticleHandle* m_particleHandle;
    qreal m_particleRadius;

};

#endif // BOX2DPARTICLESYSTEM_H
