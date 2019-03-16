//random function, explanation here.
float random(float2 st) {
    return frac(sin(dot(st.xy,
        float2(12.9898, 78.233)))*
        43758.5453123);
}