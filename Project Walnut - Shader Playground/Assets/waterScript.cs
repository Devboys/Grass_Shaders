using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class waterScript : MonoBehaviour {


    private void OnCollisionEnter(Collision collision)
    {
        Vector3 impactPoint = collision.contacts[0].point;
        impactPoint = transform.InverseTransformPoint(impactPoint);
        //impactPoint.x = 1 - ((impactPoint.x + 5) / (5 + 5)) * (1 - 0) + 0;


        GetComponent<Renderer>().material.SetFloat("_CollisionPoint", impactPoint.x);
    }


    public Vector3 GetNearestVertexToPoint(Vector3 point)
    {
        //convert point to local space
        point = transform.InverseTransformPoint(point);

        Mesh mesh = GetComponent<MeshFilter>().mesh;
        float minDistanceSqr = Mathf.Infinity;
        Vector3 nearestVertex = Vector3.zero;

        // scan all vertices to find nearest
        foreach (Vector3 vertex in mesh.vertices)
        {
            Vector3 diff = point - vertex;
            float distSqr = diff.sqrMagnitude;
            if (distSqr < minDistanceSqr)
            {
                minDistanceSqr = distSqr;
                nearestVertex = vertex;
            }
        }
        // convert nearest vertex back to world space
        return transform.TransformPoint(nearestVertex);
    }
}
