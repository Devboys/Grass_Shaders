using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class GridPointMeshGen : MeshGen_Base
{

    public int numPointsX = 50;
    public int numPointsZ = 50;
    public float sizeX = 1;
    public float sizeZ = 1;

    private int numPoints;

    private void Start()
    {
        BuildMesh();
    }

    public override void BuildMesh()
    {
        Mesh mesh = new Mesh();

        GetComponent<MeshFilter>().mesh = mesh;
        numPoints = numPointsX * numPointsZ;
        CreateMeshAll(mesh);
    }

    void CreateMeshAll(Mesh mesh)
    {
        Vector3[] points = new Vector3[numPoints];
        int[] indecies = new int[numPoints];
        Color[] colors = new Color[numPoints];

        float distanceX = sizeX / numPointsX;
        float distanceZ = sizeZ / numPointsZ;

        int index = 0;

        for (int i = 0; i < numPointsX; ++i)
        {
            float posX = (-sizeX/ 2) + i * distanceX;

            for(int j = 0; j < numPointsZ; j++)
            {
                float posZ = -(sizeZ /2 ) + j * distanceZ;

                points[index] = new Vector3(posX, 0, posZ);
                indecies[index] = index;
                colors[index] = Color.white;
                index++;
            }
        }

        mesh.vertices = points;
        mesh.colors = colors;
        mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32; //make mesh-length be up to 32 bit (instead of default 16)
        mesh.SetIndices(indecies, MeshTopology.Points, 0);

        Debug.Log(index);
    }

    private void OnDrawGizmosSelected()
    {
        //Draws an outline of the 
        //4 corners of the 'empty-square'
        Vector3 UR = transform.position + new Vector3(sizeX/2,  0, sizeZ/2);
        Vector3 UL = transform.position + new Vector3(-sizeX/2, 0, sizeZ/2);
        Vector3 LR = transform.position + new Vector3(sizeX/2,  0, -sizeZ/2);
        Vector3 LL = transform.position + new Vector3(-sizeX/2, 0, -sizeZ/2);


        Gizmos.color = Color.blue;
        Gizmos.DrawLine(UR, UL);
        Gizmos.DrawLine(UL, LL);
        Gizmos.DrawLine(LL, LR);
        Gizmos.DrawLine(LR, UR);

    }
}
