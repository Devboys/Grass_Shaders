using UnityEngine;

public class Debug_CameraMovement : MonoBehaviour
{
    public float Speed = 50;

    void Update()
    {
        float xAxisValue = Input.GetAxis("Horizontal") * Speed;
        float zAxisValue = Input.GetAxis("Vertical") * Speed;
        float yValue = 0.0f;

        if (Input.GetKey(KeyCode.Q))
        {
            yValue = -Speed * 0.3f;
        }
        if (Input.GetKey(KeyCode.E))
        {
            yValue = Speed * 0.3f;
        }

        transform.position = new Vector3(transform.position.x + xAxisValue, transform.position.y + yValue, transform.position.z + zAxisValue);
    }
}