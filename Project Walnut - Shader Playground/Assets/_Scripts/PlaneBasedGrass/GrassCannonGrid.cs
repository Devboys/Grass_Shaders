using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GrassCannonGrid : MonoBehaviour
{
    public Mesh grassMesh;
    public Material material;

    public Vector2 size;

    [Range(1, 18)]
    public int grassNumber;


    void Update()
    {
        List<Matrix4x4> grassMaterices = new List<Matrix4x4>(grassNumber*3);

        float distanceX = size.x / grassNumber;
        float distanceZ = size.y / grassNumber;

        for (int i = 0; i < grassNumber; ++i)
        {
            Vector3 origin = transform.position;
            origin.x = -(size.x / 2) + i * distanceX;

            for(int j = 0; j < grassNumber; j++)
            {
                origin.z = -(size.y / 2) + j * distanceZ;

                grassMaterices.Add(Matrix4x4.TRS(origin, Quaternion.identity, Vector3.one));
                grassMaterices.Add(Matrix4x4.TRS(origin, Quaternion.AngleAxis(60, Vector3.up), Vector3.one));
                grassMaterices.Add(Matrix4x4.TRS(origin, Quaternion.AngleAxis(120, Vector3.up), Vector3.one));
            }

        }
        Graphics.DrawMeshInstanced(grassMesh, 0, material, grassMaterices);
    }
}