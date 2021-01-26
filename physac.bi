#pragma once

extern "C"

#define PHYSAC_H

'' TODO: #define PHYSACDEF extern
#define PHYSAC_MALLOC(size) allocate(size)
#define PHYSAC_FREE(ptr) deallocate(ptr)
const PHYSAC_MAX_BODIES = 64
const PHYSAC_MAX_MANIFOLDS = 4096
const PHYSAC_MAX_VERTICES = 24
const PHYSAC_CIRCLE_VERTICES = 24
const PHYSAC_COLLISION_ITERATIONS = 100
const PHYSAC_PENETRATION_ALLOWANCE = 0.05f
const PHYSAC_PENETRATION_CORRECTION = 0.4f
const PHYSAC_PI = 3.14159265358979323846
const PHYSAC_DEG2RAD = PHYSAC_PI / 180.0f

type PhysicsShapeType as long
enum
	PHYSICS_CIRCLE
	PHYSICS_POLYGON
end enum

type PhysicsBody as PhysicsBodyData ptr

type Matrix2x2
	m00 as single
	m01 as single
	m10 as single
	m11 as single
end type

type PolygonData
	vertexCount as ulong
	positions(0 to 23) as Vector2
	normals(0 to 23) as Vector2
end type

type PhysicsShape
	as PhysicsShapeType type
	body as PhysicsBody
	radius as single
	transform as Matrix2x2
	vertexData as PolygonData
end type

type PhysicsBodyData
	id as ulong
	enabled as bool
	position as Vector2
	velocity as Vector2
	force as Vector2
	angularVelocity as single
	torque as single
	orient as single
	inertia as single
	inverseInertia as single
	mass as single
	inverseMass as single
	staticFriction as single
	dynamicFriction as single
	restitution as single
	useGravity as bool
	isGrounded as bool
	freezeOrient as bool
	shape as PhysicsShape
end type

type PhysicsManifoldData
	id as ulong
	bodyA as PhysicsBody
	bodyB as PhysicsBody
	penetration as single
	normal as Vector2
	contacts(0 to 1) as Vector2
	contactsCount as ulong
	restitution as single
	dynamicFriction as single
	staticFriction as single
end type

type PhysicsManifold as PhysicsManifoldData ptr
declare sub InitPhysics()
declare sub RunPhysicsStep()
declare sub SetPhysicsTimeStep(byval delta as double)
declare function IsPhysicsEnabled() as bool
declare sub SetPhysicsGravity(byval x as single, byval y as single)
declare function CreatePhysicsBodyCircle(byval pos as Vector2, byval radius as single, byval density as single) as PhysicsBody
declare function CreatePhysicsBodyRectangle(byval pos as Vector2, byval width as single, byval height as single, byval density as single) as PhysicsBody
declare function CreatePhysicsBodyPolygon(byval pos as Vector2, byval radius as single, byval sides as long, byval density as single) as PhysicsBody
declare sub PhysicsAddForce(byval body as PhysicsBody, byval force as Vector2)
declare sub PhysicsAddTorque(byval body as PhysicsBody, byval amount as single)
declare sub PhysicsShatter(byval body as PhysicsBody, byval position as Vector2, byval force as single)
declare function GetPhysicsBodiesCount() as long
declare function GetPhysicsBody(byval index as long) as PhysicsBody
declare function GetPhysicsShapeType(byval index as long) as long
declare function GetPhysicsShapeVerticesCount(byval index as long) as long
declare function GetPhysicsShapeVertex(byval body as PhysicsBody, byval vertex as long) as Vector2
declare sub SetPhysicsBodyRotation(byval body as PhysicsBody, byval radians as single)
declare sub DestroyPhysicsBody(byval body as PhysicsBody)
declare sub ResetPhysics()
declare sub ClosePhysics()

end extern
