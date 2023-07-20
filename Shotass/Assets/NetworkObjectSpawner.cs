using System.Collections;
using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class NetworkObjectSpawner : NetworkBehaviour
{
    [SerializeField] private GameObject BattonPrefab;
    [SerializeField] private Vector3 Staffpos;

    // Start is called before the first frame update
    void Start()
    {
        if(NetworkManager.Singleton.IsHost)
        {
            GameObject SpawnBaton = Instantiate(BattonPrefab, new Vector3(-4,1,-9), Quaternion.identity);
            GameObject SpawnBaton2 = Instantiate(BattonPrefab, Staffpos, Quaternion.identity) as GameObject;
            SpawnBaton.GetComponent<NetworkObject>().Spawn(true);
            SpawnBaton2.GetComponent<NetworkObject>().Spawn(true);
            Debug.Log("Staff spawn");
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
