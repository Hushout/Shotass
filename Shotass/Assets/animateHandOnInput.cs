using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;

public class animateHandOnInput : MonoBehaviour
{
    public InputActionProperty pinchAnimation;
    public Animator handAnimator;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        float triggerValue = pinchAnimation.action.ReadValue<float>();
        if (triggerValue != 0)
        {
            handAnimator.SetBool("changeColor", true);
        }
        else handAnimator.SetBool("changeColor", false);
    }
}
