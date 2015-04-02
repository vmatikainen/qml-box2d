#include "box2dparticlesystem.h"
#include "box2dworld.h"

Box2dParticleSystem::Box2dParticleSystem(QObject *parent) :
    QObject(parent)
  , m_world(0)
  , m_particleSystem(0)
  , m_particleHandle(0)
  , m_particleRadius(1.0)
{
}

void Box2dParticleSystem::addParticle(int x, int y)
{
    if (m_world && m_particleSystem) {
        b2ParticleDef pd;
        pd.flags = b2_elasticParticle;
        pd.color.Set(0, 0, 255, 255);
        pd.position.Set(x, y);
        m_particleSystem->SetRadius(m_particleRadius);
        int tempIndex = m_particleSystem->CreateParticle(pd);
    }
}

void Box2dParticleSystem::setParticleRadius(qreal arg)
{
    if (m_particleRadius == arg)
        return;

    m_particleRadius = arg;

    if (m_particleSystem) {
        m_particleSystem->SetRadius(m_particleRadius);
    }

    emit particleRadiusChanged(arg);
}

QList<qreal> Box2dParticleSystem::particleCoordinates()
{
    QList<qreal> ret;
    int count = m_particleSystem->GetParticleCount();
    b2Vec2* positions = m_particleSystem->GetPositionBuffer();
    for(int i = 0; i < count; i++) {
        ret.append(positions[i].x);
        ret.append(positions[i].y);
    }

    return ret;
}

qreal Box2dParticleSystem::particleRadius() const
{
    return m_particleRadius;
}

Box2DWorld *Box2dParticleSystem::world() const
{
    return m_world;
}

void Box2dParticleSystem::createParticleSystem()
{
    const b2ParticleSystemDef particleSystemDef;
    m_particleSystem = m_world->world().CreateParticleSystem(&particleSystemDef);
}

void Box2dParticleSystem::setWorld(Box2DWorld *world)
{
    if (m_world == world)
        return;

//    if (mWorld)
//        disconnect(mWorld, SIGNAL(pixelsPerMeterChanged()), this, SLOT(onWorldPixelsPerMeterChanged()));
//    if (world)
//        connect(world, SIGNAL(pixelsPerMeterChanged()), this, SLOT(onWorldPixelsPerMeterChanged()));

//    // Destroy body when leaving our previous world
//    if (mWorld && mBody) {
//        mWorld->world().DestroyBody(mBody);
//        mBody = 0;
//    }

    m_world = world;
    createParticleSystem();
}

void Box2dParticleSystem::printParticleData()
{
    if (m_world && m_particleSystem) {
        int count = m_particleSystem->GetParticleCount();
        b2Vec2* positions = m_particleSystem->GetPositionBuffer();
        for(int i = 0; i < count; i++) {
            qDebug() << Q_FUNC_INFO << positions[i].x << positions[i].y;
        }
    }
}
