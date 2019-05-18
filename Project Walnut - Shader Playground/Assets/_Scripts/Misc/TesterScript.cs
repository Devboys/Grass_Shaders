using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TesterScript : MonoBehaviour
{
    //public float HighestFPS { get; private set; }
    //public float LowestFPS  { get; private set; }
    public float AverageFPS { get; private set; }

    public int frameRange = 60;
    float[] fpsBuffer;
    int fpsBufferIndex;

    void Update()
    {
        if(fpsBuffer == null || fpsBuffer.Length != frameRange)
        {
            InitializeBuffer();
        }
        UpdateBuffer();
        CalculateFPS();
    }

    void InitializeBuffer()
    {
        fpsBuffer = new float[frameRange];
        fpsBufferIndex = 0;
    }

    void UpdateBuffer()
    {
        fpsBuffer[fpsBufferIndex++] = (1f / Time.deltaTime);
        if(fpsBufferIndex >= frameRange)
        {
            fpsBufferIndex = 0;
        }
    }

    void CalculateFPS()
    {
        float sum = 0;
        //float highest = 0;
        //float lowest = 0;
        foreach(float i in fpsBuffer)
        {
            sum += i;
            //if (i > highest || highest == 0) highest = i;
            //if (i < lowest  || lowest  == 0) lowest  = i;
        }
        AverageFPS = sum / fpsBuffer.Length;
        //HighestFPS = highest;
        //LowestFPS = lowest;
    }

    private void OnApplicationQuit()
    {
        Debug.Log("Time Elapsed: " + Time.realtimeSinceStartup + "\n" +
                  "Average FPS: " + AverageFPS + "\n");
                  //"Highest FPS: "   + HighestFPS + "\n" +
                  //"Lowest FPS: "    + LowestFPS);
    }
}
