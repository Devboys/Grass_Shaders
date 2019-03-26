using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
[ExecuteInEditMode]
public class LinePointMeshGen : MonoBehaviour
{

    private Mesh mesh;
    public int numPoints = 10;

    // Use this for initialization
    void Start()
    {
        mesh = new Mesh();

        GetComponent<MeshFilter>().mesh = mesh;
        CreateMesh();
    }

    void CreateMesh()
    {
        Vector3[] points = new Vector3[numPoints];
        int[] indecies = new int[numPoints];
        Color[] colors = new Color[numPoints];

        for(int i = 0; i < numPoints; i++)
        {
            float x = (i * 0.2f) - 1;
            points[i] = new Vector3(x, 0, 0);
            indecies[i] = i;
            colors[i] = Color.white;
        }

        mesh.vertices = points;
        mesh.colors = colors;
        mesh.SetIndices(indecies, MeshTopology.Points, 0);

    }
}
