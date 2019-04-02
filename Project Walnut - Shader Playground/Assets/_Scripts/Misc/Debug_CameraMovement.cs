using UnityEngine;

public class Debug_CameraMovement : MonoBehaviour
{
    public float xSpeed = 1;
    public float ySpeed = 0.5f;

    void Update()
    {
        float xAxisValue = Input.GetAxisRaw("Horizontal") * xSpeed;
        float zAxisValue = Input.GetAxisRaw("Vertical") * xSpeed;

        float yValue = 0.0f;

        if (Input.GetKey(KeyCode.Q))
        {
            yValue = -ySpeed;
        }
        if (Input.GetKey(KeyCode.E))
        {
            yValue = ySpeed;
        }

        transform.position = new Vector3(transform.position.x + xAxisValue, transform.position.y + yValue, transform.position.z + zAxisValue);
    }
}