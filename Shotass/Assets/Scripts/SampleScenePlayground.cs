using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SampleScenePlayground : MonoBehaviour
{
    
    public GameObject sceptre = null; 
    
    void Start()
    { }
    

    public void Update()
    {
        //Each 5 seconds, cast a spell
        if (Time.time % 5 == 0)
        {
            sceptre.GetComponent<Sceptre>().Charge(null);
            sceptre.GetComponent<Sceptre>().Fire(null);
        }
        
    }
}
