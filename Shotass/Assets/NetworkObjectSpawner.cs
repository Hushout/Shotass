using System.Collections;
using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class NetworkObjectSpawner : NetworkBehaviour
{
    [SerializeField] private GameObject BattonPrefab;
    // Start is called before the first frame update
    void Start()
    {
        if(NetworkManager.Singleton.IsHost)
        {
            GameObject SpawnBaton = Instantiate(BattonPrefab);
            GameObject SpawnBaton2 = Instantiate(BattonPrefab, new Vector3(1, 1, 1), Quaternion.identity) as GameObject;
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
