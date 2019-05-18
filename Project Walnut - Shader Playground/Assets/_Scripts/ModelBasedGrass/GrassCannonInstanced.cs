using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GrassCannonInstanced : MeshGen_Base
{
    public GameObject prefab;
    public Vector2 size;

    public int grassNumber;

    public override void BuildMesh()
    {

        InstantiateStuff();
    }

    void InstantiateStuff()
    {

        float distanceX = size.x / grassNumber;
        float distanceZ = size.y / grassNumber;

        int index = 0;

        for (int i = 0; i < grassNumber; ++i)
        {
            Vector3 origin = transform.position;
            origin.x = -(size.x / 2) + i * distanceX;

            for(int j = 0; j < grassNumber; j++)
            {
                origin.z = -(size.y / 2) + j * distanceZ;

                Instantiate(prefab, origin, Quaternion.identity, this.transform);
                index++;
            }
        }
    }
}