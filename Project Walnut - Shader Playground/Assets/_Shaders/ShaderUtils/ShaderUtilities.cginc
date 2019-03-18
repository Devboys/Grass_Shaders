//random function, returns a fraction between max and min.
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

//Rotation functions using quartenions, angles in RAD
float3 rotateAroundZQuart(float3 origin, float angle) 
{
    return float3(0, 0, 0);
}

float3 rotateAroundYQuart(float3 origin, float angle) 
{
    return float3(0, 0, 0);
}

float3 rotateAroundXQuart(float3 origin, float angle) 
{
    return float3(0, 0, 0);
}

