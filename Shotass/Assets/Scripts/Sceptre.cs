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
    
    private float cd = 0f;
    private bool isCharged = false;
    private float maxCooldown = 5f;

    private GameObject currentBullet;
    private Coroutine chargeCoroutine;
    private Coroutine cooldownCoroutine;
    
    
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

    public GameObject CreateProjectile()
    {
        var gameObj = Instantiate(_projectilePrefab, _projectileOrigin.position, _projectileOrigin.rotation);
        var projectile = gameObj.GetComponent<Projectile>();
        gameObj.transform.SetParent(this.transform);
        projectile.SetDamage(_damage);
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
        if (cd == 0f) {
            isCharged = true;
            currentBullet = CreateProjectile();
            chargeCoroutine = StartCoroutine(GrowBullet());
        }
    }

    public void Fire(DeactivateEventArgs arg)
    {
        if (cd == 0f && isCharged) {
            VRDebug.Log("IN if Fire");
            cd = maxCooldown;
            isCharged = false;
            VRDebug.Log("calling cooldown");
            cooldownCoroutine = StartCoroutine(coolDown());
            if (chargeCoroutine != null)
            {
                StopCoroutine(chargeCoroutine);
                chargeCoroutine = null;
            }
            StopCoroutine(cooldownCoroutine);
            cooldownCoroutine = null;
            currentBullet.GetComponent<Projectile>().SetDamage(_damage * (finaleBulletScale / 2.5));
            currentBullet.transform.position = _projectileOrigin.position;
            currentBullet.GetComponent<Rigidbody>().velocity = _projectileOrigin.up * fireSpeed;
            // Move outside Sceptre parent 
            currentBullet.transform.SetParent(null);
            Destroy(currentBullet, 60);
            currentBullet = null;
        }
    }

    public IEnumerator coolDown() {
        float elapsedTime = 0f;
        VRDebug.Log($"In cooldown: {maxCooldown}, {cd}");
        if (cd != maxCooldown)
            yield return null;
        
        while (elapsedTime < maxCooldown && cd != 0f)
        {
            VRDebug.Log("start loop");
            VRDebug.Log($"Elapsed time: {elapsedTime}");
            VRDebug.Log($"CD: {cd}");
            VRDebug.Log($"is charged: {isCharged}");
            float t = elapsedTime / maxCooldown;
            cd = Mathf.Lerp(maxCooldown, 0f, t);


            elapsedTime += Time.deltaTime;
            yield return null;
        }
    }

}
