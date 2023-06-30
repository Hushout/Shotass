using System;
using System.Collections;
using System.Collections.Generic;
using System.Threading.Tasks;
using Unity.Netcode;
using Unity.Netcode.Transports.UTP;
using Unity.Networking.Transport.Relay;
using Unity.Services.Authentication;
using Unity.Services.Core;
using Unity.Services.Relay;
using Unity.Services.Relay.Models;
using UnityEngine;

public class Relay : MonoBehaviour
{
    public static Relay Instance;

    // Start is called before the first frame update
    private async void Start()
    {
        await UnityServices.InitializeAsync();  

        AuthenticationService.Instance.SignedIn += () =>
        {
            Debug.Log("Signed in " + AuthenticationService.Instance.PlayerId);
        };

        await AuthenticationService.Instance.SignInAnonymouslyAsync();
        Instance = this;
    }

    public async Task<String> CreateRelay()
    {
        Debug.Log("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAaa");
        try
        {
            Allocation allocation = await RelayService.Instance.CreateAllocationAsync(3);
            string joinCode = await RelayService.Instance.GetJoinCodeAsync(allocation.AllocationId);
            Debug.Log("Join code " + joinCode);

            RelayServerData relayServerData = new RelayServerData(allocation, "dtls");
            NetworkManager.Singleton.GetComponent<UnityTransport>().SetRelayServerData(relayServerData);

            NetworkManager.Singleton.StartHost();

            return joinCode;

        }catch(RelayServiceException e){
            Debug.Log("Allocation failed " + e.Message);
            return null;
        }
    }

    private async void JoinRelay()
    {
        try{
            string joinCode = "YOUR_JOIN_CODE";
            JoinAllocation joinAllocation = await RelayService.Instance.JoinAllocationAsync(joinCode);
            Debug.Log("Joined relay ");

            RelayServerData relayServerData = new RelayServerData(joinAllocation, "dtls");

            NetworkManager.Singleton.GetComponent<UnityTransport>().SetRelayServerData(relayServerData);
            NetworkManager.Singleton.StartClient();

        }catch(System.Exception e){
            Debug.Log("Join failed " + e.Message);
        }
    }

    public async void JoinRelayWithCode(String code)
    {
        Debug.Log("Join lobby code: " + code);
        try
        {
            JoinAllocation joinAllocation = await RelayService.Instance.JoinAllocationAsync(code);
            Debug.Log("Joined relay ");

            RelayServerData relayServerData = new RelayServerData(joinAllocation, "dtls");

            NetworkManager.Singleton.GetComponent<UnityTransport>().SetRelayServerData(relayServerData);
            NetworkManager.Singleton.StartClient();

        }catch(System.Exception e)
        {
            Debug.Log("Join failed " + e.Message);
        }
    }
}
