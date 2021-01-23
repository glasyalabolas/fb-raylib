#pragma once

extern "C"

#define PHYSAC_H
'' TODO: #define PHYSACDEF extern
#define PHYSAC_MALLOC(size) malloc(size)
#define PHYSAC_FREE(ptr) free(ptr)
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
