using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.XR.Interaction.Toolkit;


public class Sceptre : Weapon
{
    [SerializeField]
    public Transform _projectileOrigin;
    [SerializeField]
    public GameObject _projectilePrefab;
    [SerializeField]
    public float fireSpeed = 20f;
    [SerializeField]
    public float chargeDuration = 2f;
    [SerializeField]
    public float maxBulletScale = 2f;
    [SerializeField]
    public float finaleBulletScale;
    
    private bool coldownExpired = true;
    private float maxCooldown = 0.8f;
    private Player _player = null;

    private GameObject currentBullet;
    private Coroutine chargeCoroutine;
    
    
    void Start()
    {
        XRGrabInteractable grabbable = GetComponent<XRGrabInteractable>();
        grabbable.activated.AddListener(Charge);
        grabbable.deactivated.AddListener(Fire);
    }

    void Update()
    {
        if (currentBullet != null)
        {
            currentBullet.transform.position = _projectileOrigin.position;
        }
    }

    public void AttachPlayer(Player player)
    {
        this._player = player;
    }
    
    public GameObject CreateProjectile()
    {
        var gameObj = Instantiate(_projectilePrefab, _projectileOrigin.position, _projectileOrigin.rotation);
        var projectile = gameObj.GetComponent<Projectile>();
        gameObj.transform.SetParent(this.transform);
        projectile.SetDamage(_damage);
        projectile.SetPlayer(_player);
        return gameObj;
    }

    private IEnumerator GrowBullet()
    {
        float elapsedTime = 0f;
        Vector3 initialScale = currentBullet.transform.localScale;

        while (elapsedTime < chargeDuration)
        {
            float t = elapsedTime / chargeDuration;
            float scale = Mathf.Lerp(1f, maxBulletScale, t);
            currentBullet.transform.localScale = initialScale * scale;
            finaleBulletScale = scale;

            elapsedTime += Time.deltaTime;
            yield return null;
        }
    }
    
    public void Charge(ActivateEventArgs arg)
    {
        if (!coldownExpired) return;
        currentBullet = CreateProjectile();
        chargeCoroutine = StartCoroutine(GrowBullet());
        // Start coldown
        StartCoroutine(Cooldown());
    }
    
    public void Fire(DeactivateEventArgs arg)
    {
        getAllchildren();
        if (chargeCoroutine != null)
        {
            StopCoroutine(chargeCoroutine);
            chargeCoroutine = null;
        }
        currentBullet.GetComponent<Projectile>().SetDamage(_damage * (finaleBulletScale / 2.5));
        currentBullet.transform.position = _projectileOrigin.position;
        currentBullet.GetComponent<Rigidbody>().velocity = _projectileOrigin.up * fireSpeed;
        // Move outside Sceptre parent 
        currentBullet.transform.SetParent(null);
        Destroy(currentBullet, 60);
        currentBullet = null;
    }
    
    private IEnumerator Cooldown()
    {
        coldownExpired = false;
        yield return new WaitForSeconds(maxCooldown);
        coldownExpired = true;
    }

    public void crystalOn()
    {
    }

    public void crystalOff()
    {
    }

    public void hoverEntered(HoverEnterEventArgs arg)
    {
        crystalOn();
    }

    public void hoverExit(HoverExitEventArgs arg)
    {
        crystalOff();
    }

    public void getAllchildren()
    {
        Transform[] children = GetChildren(transform);

        // Parcourir tous les enfants et les afficher
        foreach (Transform child in children)
        {
            if(child.name == "slot")
            {
                Transform[] childSlot = GetChildren(child);
                foreach(Transform subChild in childSlot)
                {
                    if (subChild.name == "attach")
                    {
                        Transform[] childattach = GetChildren(subChild);
                        foreach (Transform subattach in childattach)
                        {
                            VRDebug.Log(subattach.name);
                        }
                    }
                }
            }
        }
    }

    private Transform[] GetChildren(Transform parent)
    {
        Transform[] children = new Transform[parent.childCount];

        for (int i = 0; i < parent.childCount; i++)
        {
            children[i] = parent.GetChild(i);
        }

        return children;
    }
}
