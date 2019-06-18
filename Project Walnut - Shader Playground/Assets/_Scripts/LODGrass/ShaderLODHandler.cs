using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class ShaderLODHandler : MonoBehaviour
{

    private Material mat;

    [SerializeField] private float[] LOD_Thresholds;
    [SerializeField] private Shader[] LOD_Shaders;
    [SerializeField] private Camera mainCam;

    // Start is called before the first frame update
    void Start()
    {
        Shader.WarmupAllShaders(); //prepares all shaders for use.
        mat = GetComponent<MeshRenderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        //calculate distance to main camera
        float distanceToCamera = Vector3.Distance(mainCam.transform.position, transform.position);

        //SUPER BASIC IMPLEMENTATION, REDO LATER
        if(distanceToCamera < LOD_Thresholds[0])
            mat.shader = LOD_Shaders[0];

        else if(distanceToCamera < LOD_Thresholds[1])
            mat.shader = LOD_Shaders[1];

        else
            mat.shader = LOD_Shaders[2];
    }
}
