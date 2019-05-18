using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
[ExecuteInEditMode]
public class LinePointMeshGen : MeshGen_Base
{

    private Mesh mesh;
    public int numPoints = 10;

    public override void BuildMesh()
    {
        mesh = new Mesh();

        GetComponent<MeshFilter>().mesh = mesh;
        CreateMesh();
    }

    private void CreateMesh()
    {
        Vector3[] points = new Vector3[numPoints];
        int[] indecies = new int[numPoints];
        Color[] colors = new Color[numPoints];

        for(int i = 0; i < numPoints / 2; i++)
        {
            float x = (i * 0.2f);
            points[i] = new Vector3(x, 0, 0);
            indecies[i] = i;
            colors[i] = Color.white;
        }

        for (int j = 1; j < numPoints / 2; j++)
        {
            float x = -(j * 0.2f);
            points[j + numPoints/2] = new Vector3(x, 0, 0);
            indecies[j + numPoints / 2] = j + numPoints / 2;
            colors[j + numPoints / 2] = Color.white;
        }

        mesh.vertices = points;
        mesh.colors = colors;
        mesh.SetIndices(indecies, MeshTopology.Points, 0);

    }
}
