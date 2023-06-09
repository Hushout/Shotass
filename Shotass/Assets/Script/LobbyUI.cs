using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;
using static LobbyManager;

public class LobbyUI: MonoBehaviour
{
    public static LobbyUI Instance { get; private set; }


    [SerializeField] private Button createButton;


    // Start is called before the first frame update
    private void Awake()
    {
        createButton.onClick.AddListener(() => {
            LobbyManager.Instance.CreateLobby();
        });
    }
}
