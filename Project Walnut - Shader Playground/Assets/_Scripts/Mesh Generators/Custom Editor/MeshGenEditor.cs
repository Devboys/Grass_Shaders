using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(PlanePointCloudMeshGen))]
public class MeshGenEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        PlanePointCloudMeshGen myScript = (PlanePointCloudMeshGen)target;
        if(GUILayout.Button("Build Mesh"))
        {
            myScript.BuildMesh();
        }
    }
}
