using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[RequireComponent(typeof(MeshFilter), typeof(MeshRenderer))]
public class PlanePointCloudMeshGen : MonoBehaviour
{

    private Mesh mesh;
    public int numPoints = 50;

    public void BuildMesh()
    {
        mesh = new Mesh();

        GetComponent<MeshFilter>().mesh = mesh;
        if (numPoints != 1) CreateMeshAll();
        else CreateMeshSingle();
    }

    void CreateMeshAll()
    {
        Vector3[] points = new Vector3[numPoints];
        int[] indecies = new int[numPoints];
        Color[] colors = new Color[numPoints];
        for (int i = 0; i < points.Length; ++i)
        {
            points[i] = new Vector3(Random.Range(-1f, 1f), 0, Random.Range(-1f, 1f));
            indecies[i] = i;
            colors[i] = Color.white;
        }

        mesh.vertices = points;
        mesh.colors = colors;
        mesh.SetIndices(indecies, MeshTopology.Points, 0);

    }

    void CreateMeshSingle()
    {
        Vector3[] points = new Vector3[1];
        int[] indecies = new int[1];
        Color[] colors = new Color[1];

        points[0] = new Vector3(0, 0, 0);
        indecies[0] = 0;
        colors[0] = Color.white;

        mesh.vertices = points;
        mesh.colors = colors;
        mesh.SetIndices(indecies, MeshTopology.Points, 0);

    }
}
