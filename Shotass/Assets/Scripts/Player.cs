using System;
using System.Collections;
using System.Collections.Generic;
using Unity.VisualScripting;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;


public class Player : MonoBehaviour
{
    public GameObject playerContainer;
    public Target[] Targets;
    public TeleportationArea TeleportationArea;
    
    void Start()
    {
        if (playerContainer is null)
            VRDebug.LogWarning("Player is " + playerContainer.ToString());
        
        initialzeTargets();
    }

    void initialzeTargets()
    {
        VRDebug.Log("Initializing Targets");
        VRDebug.Log("Targets length: " + Targets.Length);
    }
    
    public bool CheckGameOverByPlayTargets(Target[] targets)
    {
        VRDebug.Log("CheckGameOverByPlayTargets");
        foreach (var target in targets)
        {
            if (!target.IsDead())
            {
                VRDebug.Log("Target is not dead");
                return false;       
            }
            VRDebug.Log("Target is dead");
        }
        return true;
    }

    public bool IsMyTarget(Target target)
    {
        foreach (var t in Targets)
        {
            if (t == target)
            {
                return true;
            }
        }
        return false;
    }
    
    //Coldown teleportation on nInteractable event Teleport
    public void OnSelectExited(SelectExitEventArgs args)
    {
        StartCoroutine(WaitAndReactivateArea(1f));
    }
    
    //WaitAndTeleport
    IEnumerator WaitAndReactivateArea(float waitTime)
    {
        TeleportationArea.enabled = false;
        yield return new WaitForSeconds(waitTime);
        TeleportationArea.enabled = true;
    }
    
}