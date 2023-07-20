using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SpellSpawner : MonoBehaviour
{
    [SerializeField]
    public GameObject spawnObject;
    [SerializeField]
    public GameObject _projectilePrefab;
    
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(FireEveryFiveSeconds());
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void Fire()
    {
        var projectileGameObject = Instantiate(_projectilePrefab, spawnObject.transform.position, Quaternion.identity);
        var projectile = projectileGameObject.GetComponent<Projectile>();
        projectile.SetDamage(20f);
        projectile.Launch(spawnObject.transform);
        
    }
    
    // Coroutine to fire every 5 seconds
    IEnumerator FireEveryFiveSeconds()
    {
        while (true)
        {
            yield return new WaitForSeconds(5f);
            Fire();
        }
    }
}
