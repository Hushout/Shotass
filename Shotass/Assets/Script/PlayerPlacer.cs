using System.Collections;
using System.Collections.Generic;
using Unity.Netcode;
using UnityEngine;

public class PlayerPlacer : MonoBehaviour
{
    // Start is called before the first frame update
    [SerializeField] private Vector3 startPos;

    private void Awake()
    {
        GameObject player = GameObject.FindWithTag("Player");
        Debug.Log(player);
        if( player != null)
        {
            player.transform.position = startPos;
        }
    }
}
