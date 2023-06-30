using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Unity.Services.Lobbies.Models;
using UnityEngine.UI;


public class LobbyListElement : MonoBehaviour
{
    [SerializeField] private TextMeshProUGUI lobbyNameText;
    [SerializeField] private TextMeshProUGUI playersCount;
    [SerializeField] private Transform element;

    private Lobby lobby;

    // Start is called before the first frame update
    public void Start()
    {
        lobbyNameText.text = lobby.Name;
        playersCount.text = lobby.Players.Count.ToString() + "/2";
    }
    private void Awake()
    {
        GetComponent<Button>().onClick.AddListener(() => {
            Debug.Log("Join lobyId: " + lobby.Id);
            LobbyManager.Instance.JoinLobby(lobby);
        });
    }

    public void UpdateLobby(Lobby lobby)
    {
        this.lobby = lobby;
        lobbyNameText.text = lobby.Name;
        playersCount.text = lobby.Players.Count.ToString() + "/2" ;
    }
}