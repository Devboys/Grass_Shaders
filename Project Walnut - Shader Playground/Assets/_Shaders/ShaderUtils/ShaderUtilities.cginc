//seeded PRNG function, returns a fraction between max and min.
float randomRange(float2 st, float min, float max) 
{
    float num = frac(sin(dot(st.xy,
        float2(12.9898, 78.233)))*
        43758.5453123);
    return (num + min) * (max-min);
}

//Rotate a point around a given axis with a given angle (in RAD)
float3 rotateAroundAxis(float3 origin, float angle, float3 axis)
{
    float k = 1 - cos(angle);
    //axis = normalize(axis);
    float x = axis.x;
    float y = axis.y;
    float z = axis.z;

    float3x3 rotAxisMat = { pow(x, 2) * k + cos(angle),  x*y*k - z * sin(angle),     x*z*k + y * sin(angle),
                            x*y*k + z * sin(angle),      pow(y, 2) * k + cos(angle), y*z*k - x * sin(angle),
                            x*z*k - y * sin(angle),      y*z*k + x * sin(angle),     pow(z, 2) * k + cos(angle) };

    return mul(rotAxisMat, origin);
}

//Rotate methods for simple rotations around x, y and z axes
float3 rotateAroundX(float3 origin, float angle) { return rotateAroundAxis(origin, angle, float3(1, 0, 0)); }
float3 rotateAroundY(float3 origin, float angle) { return rotateAroundAxis(origin, angle, float3(0, 1, 0)); }
float3 rotateAroundZ(float3 origin, float angle) { return rotateAroundAxis(origin, angle, float3(0, 0, 1)); }

//TODO: Rotation functions using quartenions;

//Angle conversion
float angleToRad(float angle)
{
    return angle * (UNITY_PI / 180);
}

float radToAngle(float rad) 
{
    return rad * (180 / UNITY_PI);
}


//Color stuff
float3 czm_saturation(float3 rgb, float adjustment)
{
    float3 W = float3(0.2125, 0.7154, 0.0721);
    float intensity = dot(rgb, W);
    return lerp(intensity, rgb, adjustment);
}

//vec3 czm_saturation(vec3 rgb, float adjustment)
//{
//    // Algorithm from Chapter 16 of OpenGL Shading Language
//    const vec3 W = vec3(0.2125, 0.7154, 0.0721);
//    vec3 intensity = vec3(dot(rgb, W));
//    return mix(intensity, rgb, adjustment);
//}
