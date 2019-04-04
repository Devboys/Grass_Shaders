using UnityEngine;
using UnityEditor;

[CustomEditor(typeof(MeshGen_Base), true)]
public class MeshGenEditor : Editor
{
    public override void OnInspectorGUI()
    {
        DrawDefaultInspector();
        MeshGen_Base myScript = (MeshGen_Base)target;
        if(GUILayout.Button("Build Mesh"))
        {
            myScript.BuildMesh();
        }
    }
}
