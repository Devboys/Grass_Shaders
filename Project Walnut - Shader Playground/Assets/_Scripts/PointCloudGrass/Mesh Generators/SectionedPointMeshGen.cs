using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

[ExecuteInEditMode]
public class SectionedPointMeshGen : MeshGen_Base
{

    public int numPointsX = 50;
    public int numPointsZ = 50;
    public float size = 1;
    public int maxPoints = 40000;
    public GameObject meshPrefab;

    private int numPoints;
    private int numMeshes;
    private float perMeshSize;
    private int perMeshPoints;

    private void Start()
    {
        BuildMesh();
    }

    public override void BuildMesh()
    {

        //destroy every child
        for(int i = transform.childCount-1; i >= 0; i--)
        {
            Transform child = transform.GetChild(i);
            DestroyImmediate(child.gameObject);
        }

        numPoints = numPointsX * numPointsZ;

        //find amount of meshes necessary to split
        //float x = numPoints / (float)maxPoints;
        //x = Mathf.Sqrt(x);
        //x = Mathf.Ceil(x);
        //x = Mathf.Pow(x, 2);
        numMeshes = (int)Mathf.Pow(Mathf.Ceil(Mathf.Sqrt(numPoints/(float)maxPoints)), 2);
        perMeshPoints = numPoints / numMeshes; //this technically makes the implementation slightly unreliable when numPoints cannot be divided by numMeshes
        perMeshSize = size / Mathf.Sqrt(numMeshes);
        Debug.Log(perMeshPoints);

        for (int i = 0; i < Mathf.Sqrt(numMeshes); i++)
        {
            for (int j = 0; j < Mathf.Sqrt(numMeshes); j++)
            {
                GameObject child = Instantiate(meshPrefab, this.transform, false);
                child.transform.localPosition = new Vector3(-(size / 2) + i * perMeshSize + perMeshSize / 2, 0, -(size / 2) + j * perMeshSize + perMeshSize / 2);

                Mesh childMesh = new Mesh();
                child.GetComponent<MeshFilter>().mesh = childMesh;
                CreateMesh(childMesh, perMeshSize, perMeshPoints);
            }
        }
    }

    void CreateMesh(Mesh mesh, float meshSize, int meshPointCount)
    {
        Vector3[] points = new Vector3[meshPointCount];
        int[] indecies = new int[meshPointCount];
        Color[] colors = new Color[meshPointCount];

        int meshPoints = (int) Mathf.Ceil(Mathf.Sqrt(meshPointCount));

        float distanceX = meshSize / meshPoints;
        float distanceZ = meshSize / meshPoints;

        int index = 0;

        for (int i = 0; i < meshPoints; ++i)
        {
            float posX = (-size/ 4) + i * distanceX;

            for(int j = 0; j < meshPoints; j++)
            {
                float posZ = -(size / 4 ) + j * distanceZ;

                points[index] = new Vector3(posX, 0, posZ);
                indecies[index] = index;
                colors[index] = Color.white;
                index++;
            }
        }

        mesh.vertices = points;
        mesh.colors = colors;
        //mesh.indexFormat = UnityEngine.Rendering.IndexFormat.UInt32; //make mesh-length be up to 32 bit (instead of default 16)
        mesh.SetIndices(indecies, MeshTopology.Points, 0);
    }

    private void OnDrawGizmosSelected()
    {
        //Draws an outline of the 
        //4 corners of the 'empty-square'
        Vector3 UR = transform.position + new Vector3(size/2,  0, size/2);
        Vector3 UL = transform.position + new Vector3(-size/2, 0, size/2);
        Vector3 LR = transform.position + new Vector3(size/2,  0, -size/2);
        Vector3 LL = transform.position + new Vector3(-size/2, 0, -size/2);


        Gizmos.color = Color.blue;
        Gizmos.DrawLine(UR, UL);
        Gizmos.DrawLine(UL, LL);
        Gizmos.DrawLine(LL, LR);
        Gizmos.DrawLine(LR, UR);

    }

    private void FindMeshSize(float meshSizeCalc, int numPoints)
    {
        if(numPoints > maxPoints)
        {
            //split into 4
            int pointsPrMesh = numPoints / 4;
            float sizePrMesh = meshSizeCalc / 2; //4 squares of half size = whole size
            numMeshes += 3;

            FindMeshSize(sizePrMesh, pointsPrMesh);
        }
        else
        {
            perMeshSize = meshSizeCalc;
            perMeshPoints = numPoints;
        } 
    }
}
