using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class ProjectPointCloudMeshGen : MeshGen_Base
{

    public int numPoints = 50;
    public float sizeX = 1;
    public float sizeZ = 1;
    public LayerMask groundMask = ~0;
    public bool projectDownward = true;

    private void Start()
    {
        BuildMesh();
    }

    public override void BuildMesh()
    {
        Mesh mesh = new Mesh();

        GetComponent<MeshFilter>().mesh = mesh;
        if (numPoints != 1) CreateMeshAll(mesh);
        else CreateMeshSingle(mesh);
    }

    void CreateMeshAll(Mesh mesh)
    {
        Vector3[] points = new Vector3[numPoints];
        int[] indecies = new int[numPoints];
        Color[] colors = new Color[numPoints];

        for (int i = 0; i < points.Length; ++i)
        {
            Vector3 origin = new Vector3(Random.Range(-sizeX/2, sizeX/2), 0, Random.Range(-sizeZ / 2, sizeZ / 2));

            points[i] = origin;

            if (projectDownward)
            {
                origin = transform.TransformPoint(origin);
                RaycastHit rayHit;

                if (Physics.Raycast(origin, Vector3.down, out rayHit, 10, groundMask))
                {
                    points[i] = transform.InverseTransformPoint(rayHit.point);
                }
            }

            indecies[i] = i;
            colors[i] = Color.white;
        }

        mesh.vertices = points;
        mesh.colors = colors;
        mesh.SetIndices(indecies, MeshTopology.Points, 0);

    }

    void CreateMeshSingle(Mesh mesh)
    {
        Vector3[] points = new Vector3[1];
        int[] indecies = new int[1];
        Color[] colors = new Color[1];

        Vector3 origin = new Vector3(0, 0, 0);

        points[0] = origin;

        if (projectDownward)
        {
            origin = transform.TransformPoint(origin);
            RaycastHit rayHit;

            if (Physics.Raycast(origin, Vector3.down, out rayHit, 10, groundMask))
            {
                points[0] = transform.InverseTransformPoint(rayHit.point);
            }
        }

        indecies[0] = 0;
        colors[0] = Color.white;

        mesh.vertices = points;
        mesh.colors = colors;
        mesh.SetIndices(indecies, MeshTopology.Points, 0);

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
