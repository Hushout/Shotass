using System.Collections;
using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;

public class NetworkPlayer : NetworkBehaviour
{
    // Start is called before the first frame update
    void Awake()
    {
        DontDestroyOnLoad(gameObject);
    }
    public override void OnNetworkSpawn()
    {
        if (IsClient && !IsOwner)
        {
            DisableClientInput();
        }
    }

    public void DisableClientInput()
    {
        if ( IsClient && !IsOwner)
        {
            Debug.Log("Oscour");
            var clientControllers = gameObject.GetComponentsInChildren<ActionBasedController>();
            var clientCamera = gameObject.GetComponentInChildren<Camera>();

            clientCamera.enabled = false;
        
           foreach (var controller in clientControllers)
            {
                Debug.Log("aled gmal");
                controller.enableInputActions = false;
                controller.enableInputTracking = false;
            }
        
        }

    }

  
}
