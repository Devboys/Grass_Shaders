using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GrassCannon : MonoBehaviour
{
    public Mesh grassMesh;
    public Material material;

    public int seed;
    public Vector2 size;

    [Range(1, 330)]
    public int grassNumber;

    public float startHeight = 1000;
    public float grassOffset = 0.5f;

    // Update is called once per frame
    void Update()
    {
        Random.InitState(seed);
        List<Matrix4x4> grassMaterices = new List<Matrix4x4>(grassNumber*3);
        for (int i = 0; i < grassNumber; ++i)
        {
            Vector3 origin = transform.position;
            origin.y = startHeight;
            origin.x += size.x * Random.Range(-0.5f, 0.5f);
            origin.z += size.y * Random.Range(-0.5f, 0.5f);
            Ray ray = new Ray(origin, Vector3.down);
            RaycastHit hit;
            if (Physics.Raycast(ray, out hit))
            {
                origin = hit.point;
                origin.y += grassOffset;
                
                grassMaterices.Add(Matrix4x4.TRS(origin, Quaternion.identity, Vector3.one));
                grassMaterices.Add(Matrix4x4.TRS(origin, Quaternion.AngleAxis(60, Vector3.up), Vector3.one));
                grassMaterices.Add(Matrix4x4.TRS(origin, Quaternion.AngleAxis(120, Vector3.up), Vector3.one));

            }
        }
        Graphics.DrawMeshInstanced(grassMesh, 0, material, grassMaterices);
      
    }
}