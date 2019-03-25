//seeded PRNG function, returns a fraction between max and min.
float randomRange(float2 st, float min, float max) 
{
    float num = frac(sin(dot(st.xy,
        float2(12.9898, 78.233)))*
        43758.5453123);
    return (num + min) * (max-min);
}

//Rotation functions using matrix-multiplication, angles in RAD
float3 rotateAroundZ(float3 origin, float angle) 
{
    float3x3 rotZMat = { cos(angle), -sin(angle), 0,
                         sin(angle), cos(angle),  0,
                         0,          0,           1 };

    return mul(rotZMat, origin);
}
float3 rotateAroundY(float3 origin, float angle) 
{
    float3x3 rotZMat = { cos(angle),  0, sin(angle),
                         0,           1, 0,
                         -sin(angle), 0, cos(angle)};

    return mul(rotZMat, origin);
}
float3 rotateAroundX(float3 origin, float angle) 
{
    float3x3 rotZMat = { 1, 0,          0,
                         0, cos(angle), -sin(angle),
                         0, sin(angle), cos(angle)};

    return mul(rotZMat, origin);
}

float3 rotateAroundAxis(float3 origin, float angle, float3 axis) 
{
    float k = 1 - cos(angle);
    float x = axis.x;
    float y = axis.y;
    float z = axis.z;

    float3x3 rotAxisMat = { pow(x, 2) * k + cos(angle),  x*y*k - z * sin(angle),     x*z*k + y * sin(angle),
                            x*y*k + z * sin(angle),      pow(y, 2) * k + cos(angle), y*z*k - angle * sin(angle),
                            x*z*k - y * sin(angle),      y*z*k + angle * sin(angle), pow(z, 2) * k + cos(angle)};

    return mul(rotAxisMat, origin);
}

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

