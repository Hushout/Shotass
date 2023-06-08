using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Gem : MonoBehaviour
{

    [SerializeField] private GameObject _object;
    [SerializeField] private Type _gemType;
    
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void StartAnimation()
    {
        _object.GetComponent<Animator>().SetTrigger("Start");
    }

    public enum Type
    {
        RED = 1,
        GREEN = 2,
        BLUE = 3
    }
}
